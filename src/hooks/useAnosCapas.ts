import { useEffect, useState } from 'react';
import { supabase, AnoCapas } from '../lib/supabase';

export function useAnosCapas() {
  const [anos, setAnos] = useState<AnoCapas[]>([]);
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
      .from('anos_capas')
      .select('*')
      .order('ano', { ascending: false });

    if (error) {
      console.error('Erro ao carregar anos de capas:', error);
    } else {
      setAnos(data || []);
    }
    setLoading(false);
  }

  async function criarAno(ano: number, quantidadeCapas: number = 1500) {
    const { data: anoData, error: anoError } = await supabase
      .from('anos_capas')
      .insert({ ano, quantidade_total: quantidadeCapas })
      .select()
      .single();

    if (anoError) {
      console.error('Erro ao criar ano de capas:', anoError);
      throw anoError;
    }

    const capasParaCriar = [];
    for (let i = 1; i <= quantidadeCapas; i++) {
      capasParaCriar.push({
        ano_id: anoData.id,
        numero: i,
        status: 'disponivel',
      });
    }

    const { error: capasError } = await supabase
      .from('capas')
      .insert(capasParaCriar);

    if (capasError) {
      console.error('Erro ao criar capas:', capasError);
      throw capasError;
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
