/*
  # Isolamento de Dados por Usuário
  
  ## Descrição
  Esta migration implementa isolamento completo de dados por usuário, garantindo que cada usuário veja apenas seus próprios dados.
  
  ## Alterações
  
  ### 1. Novas Colunas
  - Adiciona coluna `user_id` (uuid) em todas as tabelas:
    - `anos`
    - `oficios`
    - `anos_capas`
    - `capas`
    - `anos_oficios_circulares`
    - `oficios_circulares`
  
  ### 2. Valores Padrão
  - Define `user_id` com valor padrão `auth.uid()` para preencher automaticamente
  - Marca como NOT NULL para garantir que todos os registros tenham proprietário
  
  ### 3. Segurança (RLS Policies)
  - Remove todas as políticas públicas antigas
  - Cria novas políticas restritivas para usuários autenticados:
    - SELECT: Usuários veem apenas seus próprios dados
    - INSERT: user_id é automaticamente preenchido com auth.uid()
    - UPDATE: Usuários editam apenas seus próprios dados
    - DELETE: Usuários deletam apenas seus próprios dados
  
  ## Importante
  - Após esta migration, os dados são totalmente isolados por usuário
  - Cada usuário terá seu próprio conjunto de anos e ofícios
  - Não há compartilhamento de dados entre usuários
*/

-- Adicionar coluna user_id na tabela anos
ALTER TABLE anos 
ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE DEFAULT auth.uid() NOT NULL;

-- Adicionar coluna user_id na tabela oficios
ALTER TABLE oficios 
ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE DEFAULT auth.uid() NOT NULL;

-- Adicionar coluna user_id na tabela anos_capas
ALTER TABLE anos_capas 
ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE DEFAULT auth.uid() NOT NULL;

-- Adicionar coluna user_id na tabela capas
ALTER TABLE capas 
ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE DEFAULT auth.uid() NOT NULL;

-- Adicionar coluna user_id na tabela anos_oficios_circulares
ALTER TABLE anos_oficios_circulares 
ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE DEFAULT auth.uid() NOT NULL;

-- Adicionar coluna user_id na tabela oficios_circulares
ALTER TABLE oficios_circulares 
ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE DEFAULT auth.uid() NOT NULL;

-- Remover políticas antigas da tabela anos
DROP POLICY IF EXISTS "Allow public read access to anos" ON anos;
DROP POLICY IF EXISTS "Allow public insert access to anos" ON anos;
DROP POLICY IF EXISTS "Allow public update access to anos" ON anos;
DROP POLICY IF EXISTS "Allow public delete access to anos" ON anos;

-- Criar novas políticas para anos (isolamento por usuário)
CREATE POLICY "Users can view own anos"
  ON anos FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own anos"
  ON anos FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own anos"
  ON anos FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own anos"
  ON anos FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Remover políticas antigas da tabela oficios
DROP POLICY IF EXISTS "Allow public read access to oficios" ON oficios;
DROP POLICY IF EXISTS "Allow public insert access to oficios" ON oficios;
DROP POLICY IF EXISTS "Allow public update access to oficios" ON oficios;
DROP POLICY IF EXISTS "Allow public delete access to oficios" ON oficios;

-- Criar novas políticas para oficios (isolamento por usuário)
CREATE POLICY "Users can view own oficios"
  ON oficios FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own oficios"
  ON oficios FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own oficios"
  ON oficios FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own oficios"
  ON oficios FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Remover políticas antigas da tabela anos_capas
DROP POLICY IF EXISTS "Allow public read access to anos_capas" ON anos_capas;
DROP POLICY IF EXISTS "Allow public insert access to anos_capas" ON anos_capas;
DROP POLICY IF EXISTS "Allow public update access to anos_capas" ON anos_capas;
DROP POLICY IF EXISTS "Allow public delete access to anos_capas" ON anos_capas;

-- Criar novas políticas para anos_capas (isolamento por usuário)
CREATE POLICY "Users can view own anos_capas"
  ON anos_capas FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own anos_capas"
  ON anos_capas FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own anos_capas"
  ON anos_capas FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own anos_capas"
  ON anos_capas FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Remover políticas antigas da tabela capas
DROP POLICY IF EXISTS "Allow public read access to capas" ON capas;
DROP POLICY IF EXISTS "Allow public insert access to capas" ON capas;
DROP POLICY IF EXISTS "Allow public update access to capas" ON capas;
DROP POLICY IF EXISTS "Allow public delete access to capas" ON capas;

-- Criar novas políticas para capas (isolamento por usuário)
CREATE POLICY "Users can view own capas"
  ON capas FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own capas"
  ON capas FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own capas"
  ON capas FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own capas"
  ON capas FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Remover políticas antigas da tabela anos_oficios_circulares
DROP POLICY IF EXISTS "Allow public read access to anos_oficios_circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Allow public insert access to anos_oficios_circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Allow public update access to anos_oficios_circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Allow public delete access to anos_oficios_circulares" ON anos_oficios_circulares;

-- Criar novas políticas para anos_oficios_circulares (isolamento por usuário)
CREATE POLICY "Users can view own anos_oficios_circulares"
  ON anos_oficios_circulares FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own anos_oficios_circulares"
  ON anos_oficios_circulares FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own anos_oficios_circulares"
  ON anos_oficios_circulares FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own anos_oficios_circulares"
  ON anos_oficios_circulares FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Remover políticas antigas da tabela oficios_circulares
DROP POLICY IF EXISTS "Allow public read access to oficios_circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Allow public insert access to oficios_circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Allow public update access to oficios_circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Allow public delete access to oficios_circulares" ON oficios_circulares;

-- Criar novas políticas para oficios_circulares (isolamento por usuário)
CREATE POLICY "Users can view own oficios_circulares"
  ON oficios_circulares FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own oficios_circulares"
  ON oficios_circulares FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own oficios_circulares"
  ON oficios_circulares FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own oficios_circulares"
  ON oficios_circulares FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);