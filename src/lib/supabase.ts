import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Variáveis de ambiente do Supabase não configuradas');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export interface Ano {
  id: string;
  ano: number;
  ativo: boolean;
  created_at: string;
}

export interface Oficio {
  id: string;
  ano_id: string;
  numero: number;
  status: 'disponivel' | 'utilizado' | 'bloqueado';
  marcado_em: string | null;
  usuario: string | null;
  descricao: string | null;
  created_at: string;
  updated_at: string;
}

export interface Historico {
  id: string;
  oficio_id: string;
  status_anterior: string | null;
  status_novo: string;
  usuario: string | null;
  created_at: string;
}

export interface AnoCapas {
  id: string;
  ano: number;
  quantidade_total: number;
  created_at: string;
}

export interface Capa {
  id: string;
  ano_id: string;
  numero: number;
  status: 'disponivel' | 'utilizado';
  descricao: string | null;
  data_utilizacao: string | null;
  created_at: string;
  updated_at: string;
}

export interface AnoOficiosCirculares {
  id: string;
  ano: number;
  quantidade_total: number;
  created_at: string;
}

export interface OficioCircular {
  id: string;
  ano_id: string;
  numero: number;
  status: 'disponivel' | 'utilizado' | 'bloqueado';
  descricao: string | null;
  marcado_em: string | null;
  usuario: string | null;
  created_at: string;
  updated_at: string;
}
