import { useEffect, useState } from 'react';
import { supabase, AnoOficiosCirculares } from '../lib/supabase';

export function useAnosOficiosCirculares() {
  const [anos, setAnos] = useState<AnoOficiosCirculares[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadAnos();
  }, []);

  async function loadAnos() {
    setLoading(true);
    const { data, error } = await supabase
      .from('anos_oficios_circulares')
      .select('*')
      .order('ano', { ascending: false });

    if (error) {
      console.error('Erro ao carregar anos de ofícios circulares:', error);
    } else {
      setAnos(data || []);
    }
    setLoading(false);
  }

  async function criarAno(ano: number, quantidadeOficios: number = 1500) {
    const { data: anoData, error: anoError } = await supabase
      .from('anos_oficios_circulares')
      .insert({ ano, quantidade_total: quantidadeOficios })
      .select()
      .single();

    if (anoError) {
      console.error('Erro ao criar ano de ofícios circulares:', anoError);
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
      .from('oficios_circulares')
      .insert(oficiosParaCriar);

    if (oficiosError) {
      console.error('Erro ao criar ofícios circulares:', oficiosError);
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
