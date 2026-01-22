/*
  # Sistema de Controle de Ofícios Circulares

  1. Novas Tabelas
    - `anos_oficios_circulares`
      - `id` (uuid, primary key)
      - `ano` (integer, unique) - Ano dos ofícios circulares
      - `quantidade_total` (integer) - Quantidade total de ofícios circulares no ano
      - `created_at` (timestamptz) - Data de criação
      
    - `oficios_circulares`
      - `id` (uuid, primary key)
      - `ano_id` (uuid, foreign key -> anos_oficios_circulares.id)
      - `numero` (integer) - Número do ofício circular
      - `status` (text) - Status: 'disponivel', 'utilizado' ou 'bloqueado'
      - `descricao` (text, nullable) - Descrição opcional do ofício
      - `marcado_em` (timestamptz, nullable) - Data de marcação como utilizado
      - `usuario` (text, nullable) - Usuário que marcou
      - `created_at` (timestamptz) - Data de criação
      - `updated_at` (timestamptz) - Data de atualização
      
  2. Segurança
    - Habilitar RLS em ambas as tabelas
    - Políticas para permitir acesso público de leitura e escrita (sistema interno)
    
  3. Índices
    - Índice em `oficios_circulares.ano_id` para consultas rápidas
    - Índice em `oficios_circulares.status` para filtragem
    - Índice composto único em `oficios_circulares(ano_id, numero)` para evitar duplicatas
*/

-- Criar tabela de anos para ofícios circulares
CREATE TABLE IF NOT EXISTS anos_oficios_circulares (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ano integer UNIQUE NOT NULL,
  quantidade_total integer NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Criar tabela de ofícios circulares
CREATE TABLE IF NOT EXISTS oficios_circulares (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ano_id uuid NOT NULL REFERENCES anos_oficios_circulares(id) ON DELETE CASCADE,
  numero integer NOT NULL,
  status text NOT NULL DEFAULT 'disponivel' CHECK (status IN ('disponivel', 'utilizado', 'bloqueado')),
  descricao text,
  marcado_em timestamptz,
  usuario text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(ano_id, numero)
);

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_oficios_circulares_ano_id ON oficios_circulares(ano_id);
CREATE INDEX IF NOT EXISTS idx_oficios_circulares_status ON oficios_circulares(status);
CREATE INDEX IF NOT EXISTS idx_oficios_circulares_descricao ON oficios_circulares USING gin(to_tsvector('portuguese', coalesce(descricao, '')));

-- Habilitar RLS
ALTER TABLE anos_oficios_circulares ENABLE ROW LEVEL SECURITY;
ALTER TABLE oficios_circulares ENABLE ROW LEVEL SECURITY;

-- Políticas para anos_oficios_circulares
CREATE POLICY "Permitir leitura de anos de ofícios circulares"
  ON anos_oficios_circulares FOR SELECT
  USING (true);

CREATE POLICY "Permitir inserção de anos de ofícios circulares"
  ON anos_oficios_circulares FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Permitir atualização de anos de ofícios circulares"
  ON anos_oficios_circulares FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Permitir exclusão de anos de ofícios circulares"
  ON anos_oficios_circulares FOR DELETE
  USING (true);

-- Políticas para oficios_circulares
CREATE POLICY "Permitir leitura de ofícios circulares"
  ON oficios_circulares FOR SELECT
  USING (true);

CREATE POLICY "Permitir inserção de ofícios circulares"
  ON oficios_circulares FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Permitir atualização de ofícios circulares"
  ON oficios_circulares FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Permitir exclusão de ofícios circulares"
  ON oficios_circulares FOR DELETE
  USING (true);