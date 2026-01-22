/*
  # Sistema de Controle de Capas de Processos

  1. Novas Tabelas
    - `anos_capas`
      - `id` (uuid, primary key)
      - `ano` (integer, unique) - Ano das capas
      - `quantidade_total` (integer) - Quantidade total de capas no ano
      - `created_at` (timestamptz) - Data de criação
      
    - `capas`
      - `id` (uuid, primary key)
      - `ano_id` (uuid, foreign key -> anos_capas.id)
      - `numero` (integer) - Número da capa
      - `status` (text) - Status: 'disponivel' ou 'utilizado'
      - `descricao` (text, nullable) - Descrição opcional da capa
      - `data_utilizacao` (timestamptz, nullable) - Data de utilização
      - `created_at` (timestamptz) - Data de criação
      - `updated_at` (timestamptz) - Data de atualização
      
  2. Segurança
    - Habilitar RLS em ambas as tabelas
    - Políticas para permitir acesso público de leitura e escrita (sistema interno)
    
  3. Índices
    - Índice em `capas.ano_id` para consultas rápidas
    - Índice em `capas.status` para filtragem
    - Índice composto único em `capas(ano_id, numero)` para evitar duplicatas
*/

-- Criar tabela de anos para capas
CREATE TABLE IF NOT EXISTS anos_capas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ano integer UNIQUE NOT NULL,
  quantidade_total integer NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Criar tabela de capas
CREATE TABLE IF NOT EXISTS capas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ano_id uuid NOT NULL REFERENCES anos_capas(id) ON DELETE CASCADE,
  numero integer NOT NULL,
  status text NOT NULL DEFAULT 'disponivel' CHECK (status IN ('disponivel', 'utilizado')),
  descricao text,
  data_utilizacao timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(ano_id, numero)
);

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_capas_ano_id ON capas(ano_id);
CREATE INDEX IF NOT EXISTS idx_capas_status ON capas(status);
CREATE INDEX IF NOT EXISTS idx_capas_descricao ON capas USING gin(to_tsvector('portuguese', coalesce(descricao, '')));

-- Habilitar RLS
ALTER TABLE anos_capas ENABLE ROW LEVEL SECURITY;
ALTER TABLE capas ENABLE ROW LEVEL SECURITY;

-- Políticas para anos_capas
CREATE POLICY "Permitir leitura de anos de capas"
  ON anos_capas FOR SELECT
  USING (true);

CREATE POLICY "Permitir inserção de anos de capas"
  ON anos_capas FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Permitir atualização de anos de capas"
  ON anos_capas FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Permitir exclusão de anos de capas"
  ON anos_capas FOR DELETE
  USING (true);

-- Políticas para capas
CREATE POLICY "Permitir leitura de capas"
  ON capas FOR SELECT
  USING (true);

CREATE POLICY "Permitir inserção de capas"
  ON capas FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Permitir atualização de capas"
  ON capas FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Permitir exclusão de capas"
  ON capas FOR DELETE
  USING (true);