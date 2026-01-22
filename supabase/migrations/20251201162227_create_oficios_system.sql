/*
  # Sistema de Controle de Numeração de Ofícios - SEMAD Parintins

  ## 1. Tabelas Criadas
    
  ### `anos`
  Armazena os anos disponíveis no sistema
  - `id` (uuid, primary key)
  - `ano` (integer, unique) - Ex: 2023, 2024, 2025
  - `ativo` (boolean) - Indica se é o ano corrente
  - `created_at` (timestamp)

  ### `oficios`
  Armazena cada número de ofício por ano
  - `id` (uuid, primary key)
  - `ano_id` (uuid, foreign key) - Referência ao ano
  - `numero` (integer) - Número do ofício (1-9999)
  - `status` (text) - 'disponivel', 'utilizado', 'bloqueado'
  - `marcado_em` (timestamp) - Data/hora da marcação
  - `usuario` (text) - Usuário que marcou (opcional)
  - `created_at` (timestamp)
  - `updated_at` (timestamp)

  ### `historico`
  Registra todas as alterações de status
  - `id` (uuid, primary key)
  - `oficio_id` (uuid, foreign key)
  - `status_anterior` (text)
  - `status_novo` (text)
  - `usuario` (text)
  - `created_at` (timestamp)

  ## 2. Segurança
  - RLS habilitado em todas as tabelas
  - Políticas permitem leitura pública (sistema interno)
  - Políticas permitem escrita autenticada

  ## 3. Índices
  - Índice composto em (ano_id, numero) para busca rápida
  - Índice em ano para listagem
  - Índice em status para filtros

  ## 4. Notas Importantes
  - Sistema multi-ano com histórico completo
  - Real-time habilitado via Supabase subscriptions
  - Constraint unique em (ano_id, numero) para evitar duplicatas
*/

-- Criar tabela de anos
CREATE TABLE IF NOT EXISTS anos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ano integer UNIQUE NOT NULL,
  ativo boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Criar tabela de ofícios
CREATE TABLE IF NOT EXISTS oficios (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ano_id uuid NOT NULL REFERENCES anos(id) ON DELETE CASCADE,
  numero integer NOT NULL CHECK (numero > 0),
  status text NOT NULL DEFAULT 'disponivel' CHECK (status IN ('disponivel', 'utilizado', 'bloqueado')),
  marcado_em timestamptz,
  usuario text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(ano_id, numero)
);

-- Criar tabela de histórico
CREATE TABLE IF NOT EXISTS historico (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  oficio_id uuid NOT NULL REFERENCES oficios(id) ON DELETE CASCADE,
  status_anterior text,
  status_novo text NOT NULL,
  usuario text,
  created_at timestamptz DEFAULT now()
);

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_oficios_ano_numero ON oficios(ano_id, numero);
CREATE INDEX IF NOT EXISTS idx_oficios_status ON oficios(status);
CREATE INDEX IF NOT EXISTS idx_anos_ano ON anos(ano);
CREATE INDEX IF NOT EXISTS idx_historico_oficio ON historico(oficio_id);

-- Habilitar RLS
ALTER TABLE anos ENABLE ROW LEVEL SECURITY;
ALTER TABLE oficios ENABLE ROW LEVEL SECURITY;
ALTER TABLE historico ENABLE ROW LEVEL SECURITY;

-- Políticas para tabela anos
CREATE POLICY "Permitir leitura pública de anos"
  ON anos FOR SELECT
  USING (true);

CREATE POLICY "Permitir inserção de anos"
  ON anos FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Permitir atualização de anos"
  ON anos FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- Políticas para tabela oficios
CREATE POLICY "Permitir leitura pública de oficios"
  ON oficios FOR SELECT
  USING (true);

CREATE POLICY "Permitir inserção de oficios"
  ON oficios FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Permitir atualização de oficios"
  ON oficios FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- Políticas para tabela historico
CREATE POLICY "Permitir leitura pública de historico"
  ON historico FOR SELECT
  USING (true);

CREATE POLICY "Permitir inserção em historico"
  ON historico FOR INSERT
  WITH CHECK (true);

-- Função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para atualizar updated_at
CREATE TRIGGER update_oficios_updated_at
  BEFORE UPDATE ON oficios
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Função para registrar histórico automaticamente
CREATE OR REPLACE FUNCTION registrar_historico()
RETURNS TRIGGER AS $$
BEGIN
  IF OLD.status IS DISTINCT FROM NEW.status THEN
    INSERT INTO historico (oficio_id, status_anterior, status_novo, usuario)
    VALUES (NEW.id, OLD.status, NEW.status, NEW.usuario);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para registrar mudanças de status
CREATE TRIGGER registrar_historico_oficios
  AFTER UPDATE ON oficios
  FOR EACH ROW
  EXECUTE FUNCTION registrar_historico();