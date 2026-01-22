import { useEffect, useState } from 'react';
import { supabase, Capa } from '../lib/supabase';

export function useCapas(anoId: string | null) {
  const [capas, setCapas] = useState<Capa[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!anoId) {
      setCapas([]);
      setLoading(false);
      return;
    }

    loadCapas();

    const channel = supabase
      .channel('capas_changes')
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'capas',
          filter: `ano_id=eq.${anoId}`,
        },
        (payload) => {
          if (payload.eventType === 'INSERT') {
            setCapas((prev) => [...prev, payload.new as Capa]);
          } else if (payload.eventType === 'UPDATE') {
            setCapas((prev) =>
              prev.map((c) => (c.id === payload.new.id ? (payload.new as Capa) : c))
            );
          } else if (payload.eventType === 'DELETE') {
            setCapas((prev) => prev.filter((c) => c.id !== payload.old.id));
          }
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [anoId]);

  async function loadCapas() {
    if (!anoId) return;

    setLoading(true);

    let allCapas: Capa[] = [];
    let from = 0;
    const pageSize = 1000;
    let hasMore = true;

    while (hasMore) {
      const { data, error } = await supabase
        .from('capas')
        .select('*')
        .eq('ano_id', anoId)
        .order('numero')
        .range(from, from + pageSize - 1);

      if (error) {
        console.error('Erro ao carregar capas:', error);
        break;
      }

      if (data && data.length > 0) {
        allCapas = [...allCapas, ...data];
        from += pageSize;
        hasMore = data.length === pageSize;
      } else {
        hasMore = false;
      }
    }

    setCapas(allCapas);
    setLoading(false);
  }

  async function marcarCapa(numero: number, status: 'disponivel' | 'utilizado', descricao?: string) {
    if (!anoId) return;

    const capa = capas.find((c) => c.numero === numero);
    if (!capa) return;

    const { error } = await supabase
      .from('capas')
      .update({
        status,
        data_utilizacao: status === 'utilizado' ? new Date().toISOString() : null,
        descricao: status === 'utilizado' ? (descricao || null) : null,
      })
      .eq('id', capa.id);

    if (error) {
      console.error('Erro ao marcar capa:', error);
      throw error;
    }
  }

  async function marcarProximoDisponivel(descricao?: string) {
    const proximoDisponivel = capas.find((c) => c.status === 'disponivel');
    if (proximoDisponivel) {
      await marcarCapa(proximoDisponivel.numero, 'utilizado', descricao);
      return proximoDisponivel.numero;
    }
    return null;
  }

  return {
    capas,
    loading,
    marcarCapa,
    marcarProximoDisponivel,
    reload: loadCapas,
  };
}
