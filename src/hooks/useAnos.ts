import { useEffect, useState } from 'react';
import { supabase, Ano } from '../lib/supabase';

export function useAnos() {
  const [anos, setAnos] = useState<Ano[]>([]);
  const [loading, setLoading] = useState(true);
  const [userId, setUserId] = useState<string | null>(null);

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUserId(session?.user?.id ?? null);
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUserId(session?.user?.id ?? null);
    });

    return () => subscription.unsubscribe();
  }, []);

  useEffect(() => {
    if (userId) {
      loadAnos();
    } else {
      setAnos([]);
      setLoading(false);
    }
  }, [userId]);

  async function loadAnos() {
    setLoading(true);
    const { data, error } = await supabase
      .from('anos')
      .select('*')
      .order('ano', { ascending: false });

    if (error) {
      console.error('Erro ao carregar anos:', error);
    } else {
      setAnos(data || []);
    }
    setLoading(false);
  }

  async function criarAno(ano: number, quantidadeOficios: number = 1500) {
    const { data: anoData, error: anoError } = await supabase
      .from('anos')
      .insert({ ano, ativo: true })
      .select()
      .single();

    if (anoError) {
      console.error('Erro ao criar ano:', anoError);
      throw anoError;
    }

    const oficiosParaCriar = [];
    for (let i = 1; i <= quantidadeOficios; i++) {
      oficiosParaCriar.push({
        ano_id: anoData.id,
        numero: i,
        status: 'disponivel',
      });
    }

    const { error: oficiosError } = await supabase
      .from('oficios')
      .insert(oficiosParaCriar);

    if (oficiosError) {
      console.error('Erro ao criar ofícios:', oficiosError);
      throw oficiosError;
    }

    await loadAnos();
    return anoData;
  }

  return {
    anos,
    loading,
    criarAno,
    reload: loadAnos,
  };
}
