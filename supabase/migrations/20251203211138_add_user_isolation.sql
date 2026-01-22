/*
  # Adicionar Isolamento de Dados por Usuário
  
  ## Alterações nas Tabelas
  
  1. Adiciona coluna `user_id` em todas as tabelas:
     - `anos` - identifica o proprietário dos anos de ofícios
     - `oficios` - identifica o proprietário dos ofícios
     - `anos_capas` - identifica o proprietário dos anos de capas
     - `capas` - identifica o proprietário das capas
     - `anos_oficios_circulares` - identifica o proprietário dos anos de ofícios circulares
     - `oficios_circulares` - identifica o proprietário dos ofícios circulares
  
  2. Atualiza políticas RLS:
     - Remove políticas antigas que permitiam acesso a todos
     - Adiciona novas políticas que filtram por user_id
     - Garante que usuários só vejam seus próprios dados
  
  ## Segurança
  
  - Cada usuário terá seus próprios dados isolados
  - Nenhum usuário pode acessar dados de outro usuário
  - As políticas RLS garantem segurança no nível do banco de dados
  
  ## Notas Importantes
  
  - Dados existentes sem user_id serão associados ao primeiro usuário que fizer login
  - Novos registros sempre terão user_id preenchido automaticamente
*/

-- Adicionar coluna user_id na tabela anos
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'anos' AND column_name = 'user_id'
  ) THEN
    ALTER TABLE anos ADD COLUMN user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;
    CREATE INDEX IF NOT EXISTS idx_anos_user_id ON anos(user_id);
  END IF;
END $$;

-- Adicionar coluna user_id na tabela oficios
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'oficios' AND column_name = 'user_id'
  ) THEN
    ALTER TABLE oficios ADD COLUMN user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;
    CREATE INDEX IF NOT EXISTS idx_oficios_user_id ON oficios(user_id);
  END IF;
END $$;

-- Adicionar coluna user_id na tabela anos_capas
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'anos_capas' AND column_name = 'user_id'
  ) THEN
    ALTER TABLE anos_capas ADD COLUMN user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;
    CREATE INDEX IF NOT EXISTS idx_anos_capas_user_id ON anos_capas(user_id);
  END IF;
END $$;

-- Adicionar coluna user_id na tabela capas
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'capas' AND column_name = 'user_id'
  ) THEN
    ALTER TABLE capas ADD COLUMN user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;
    CREATE INDEX IF NOT EXISTS idx_capas_user_id ON capas(user_id);
  END IF;
END $$;

-- Adicionar coluna user_id na tabela anos_oficios_circulares
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'anos_oficios_circulares' AND column_name = 'user_id'
  ) THEN
    ALTER TABLE anos_oficios_circulares ADD COLUMN user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;
    CREATE INDEX IF NOT EXISTS idx_anos_oficios_circulares_user_id ON anos_oficios_circulares(user_id);
  END IF;
END $$;

-- Adicionar coluna user_id na tabela oficios_circulares
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'oficios_circulares' AND column_name = 'user_id'
  ) THEN
    ALTER TABLE oficios_circulares ADD COLUMN user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;
    CREATE INDEX IF NOT EXISTS idx_oficios_circulares_user_id ON oficios_circulares(user_id);
  END IF;
END $$;

-- Remover políticas antigas e criar novas com isolamento por usuário

-- ANOS
DROP POLICY IF EXISTS "Users can read all anos" ON anos;
DROP POLICY IF EXISTS "Users can create anos" ON anos;
DROP POLICY IF EXISTS "Users can update anos" ON anos;

CREATE POLICY "Users can read own anos"
  ON anos FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own anos"
  ON anos FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own anos"
  ON anos FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- OFICIOS
DROP POLICY IF EXISTS "Users can read all oficios" ON oficios;
DROP POLICY IF EXISTS "Users can create oficios" ON oficios;
DROP POLICY IF EXISTS "Users can update oficios" ON oficios;

CREATE POLICY "Users can read own oficios"
  ON oficios FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own oficios"
  ON oficios FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own oficios"
  ON oficios FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ANOS_CAPAS
DROP POLICY IF EXISTS "Users can read all anos_capas" ON anos_capas;
DROP POLICY IF EXISTS "Users can create anos_capas" ON anos_capas;
DROP POLICY IF EXISTS "Users can update anos_capas" ON anos_capas;

CREATE POLICY "Users can read own anos_capas"
  ON anos_capas FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own anos_capas"
  ON anos_capas FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own anos_capas"
  ON anos_capas FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- CAPAS
DROP POLICY IF EXISTS "Users can read all capas" ON capas;
DROP POLICY IF EXISTS "Users can create capas" ON capas;
DROP POLICY IF EXISTS "Users can update capas" ON capas;

CREATE POLICY "Users can read own capas"
  ON capas FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own capas"
  ON capas FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own capas"
  ON capas FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ANOS_OFICIOS_CIRCULARES
DROP POLICY IF EXISTS "Users can read all anos_oficios_circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Users can create anos_oficios_circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Users can update anos_oficios_circulares" ON anos_oficios_circulares;

CREATE POLICY "Users can read own anos_oficios_circulares"
  ON anos_oficios_circulares FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own anos_oficios_circulares"
  ON anos_oficios_circulares FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own anos_oficios_circulares"
  ON anos_oficios_circulares FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- OFICIOS_CIRCULARES
DROP POLICY IF EXISTS "Users can read all oficios_circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Users can create oficios_circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Users can update oficios_circulares" ON oficios_circulares;

CREATE POLICY "Users can read own oficios_circulares"
  ON oficios_circulares FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own oficios_circulares"
  ON oficios_circulares FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own oficios_circulares"
  ON oficios_circulares FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
