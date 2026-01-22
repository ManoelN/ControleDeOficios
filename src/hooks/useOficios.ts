import { useEffect, useState } from 'react';
import { supabase, Oficio } from '../lib/supabase';

export function useOficios(anoId: string | null) {
  const [oficios, setOficios] = useState<Oficio[]>([]);
  const [loading, setLoading] = useState(true);
  const [userId, setUserId] = useState<string | null>(null);

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUserId(session?.user?.id ?? null);
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      const newUserId = session?.user?.id ?? null;
      if (newUserId !== userId) {
        setOficios([]);
        setUserId(newUserId);
      }
    });

    return () => subscription.unsubscribe();
  }, []);

  useEffect(() => {
    if (!anoId || !userId) {
      setOficios([]);
      setLoading(false);
      return;
    }

    loadOficios();

    const channel = supabase
      .channel('oficios_changes')
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'oficios',
          filter: `ano_id=eq.${anoId}`,
        },
        (payload) => {
          if (payload.eventType === 'INSERT') {
            setOficios((prev) => [...prev, payload.new as Oficio]);
          } else if (payload.eventType === 'UPDATE') {
            setOficios((prev) =>
              prev.map((o) => (o.id === payload.new.id ? (payload.new as Oficio) : o))
            );
          } else if (payload.eventType === 'DELETE') {
            setOficios((prev) => prev.filter((o) => o.id !== payload.old.id));
          }
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [anoId]);

  async function loadOficios() {
    if (!anoId) return;

    setLoading(true);

    let allOficios: Oficio[] = [];
    let from = 0;
    const pageSize = 1000;
    let hasMore = true;

    while (hasMore) {
      const { data, error } = await supabase
        .from('oficios')
        .select('*')
        .eq('ano_id', anoId)
        .order('numero')
        .range(from, from + pageSize - 1);

      if (error) {
        console.error('Erro ao carregar ofícios:', error);
        break;
      }

      if (data && data.length > 0) {
        allOficios = [...allOficios, ...data];
        from += pageSize;
        hasMore = data.length === pageSize;
      } else {
        hasMore = false;
      }
    }

    setOficios(allOficios);
    setLoading(false);
  }

  async function marcarOficio(numero: number, status: 'disponivel' | 'utilizado' | 'bloqueado', descricao?: string) {
    if (!anoId) return;

    const oficio = oficios.find((o) => o.numero === numero);
    if (!oficio) return;

    const { error } = await supabase
      .from('oficios')
      .update({
        status,
        marcado_em: status === 'utilizado' ? new Date().toISOString() : null,
        usuario: 'Sistema',
        descricao: status === 'utilizado' ? (descricao || null) : null,
      })
      .eq('id', oficio.id);

    if (error) {
      console.error('Erro ao marcar ofício:', error);
      throw error;
    }
  }

  async function marcarProximoDisponivel(descricao?: string) {
    const proximoDisponivel = oficios.find((o) => o.status === 'disponivel');
    if (proximoDisponivel) {
      await marcarOficio(proximoDisponivel.numero, 'utilizado', descricao);
      return proximoDisponivel.numero;
    }
    return null;
  }

  return {
    oficios,
    loading,
    marcarOficio,
    marcarProximoDisponivel,
    reload: loadOficios,
  };
}
