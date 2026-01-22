/*
  # Corrigir Constraints de Unicidade para Permitir Isolamento por Usuário
  
  ## Problema
  As constraints de unicidade em `ano` impedem que diferentes usuários criem
  o mesmo ano. Por exemplo, se o usuário A criar o ano 2026, o usuário B não
  pode criar seu próprio ano 2026.
  
  ## Solução
  - Remover constraints únicas simples em `ano`
  - Adicionar constraints únicas compostas em `(ano, user_id)`
  - Garantir que user_id NOT NULL para todas as tabelas
  
  ## Tabelas Afetadas
  - anos
  - anos_capas
  - anos_oficios_circulares
  
  ## Resultado
  Cada usuário poderá ter seus próprios anos independentemente, mantendo
  o isolamento completo de dados.
*/

-- Fix table: anos
-- Remove existing unique constraint on ano
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'anos_ano_key' AND conrelid = 'anos'::regclass
  ) THEN
    ALTER TABLE anos DROP CONSTRAINT anos_ano_key;
  END IF;
END $$;

-- Make user_id NOT NULL
ALTER TABLE anos ALTER COLUMN user_id SET NOT NULL;

-- Add unique constraint on (ano, user_id)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'anos_ano_user_id_key' AND conrelid = 'anos'::regclass
  ) THEN
    ALTER TABLE anos ADD CONSTRAINT anos_ano_user_id_key UNIQUE (ano, user_id);
  END IF;
END $$;

-- Fix table: anos_capas
-- Remove existing unique constraint on ano
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'anos_capas_ano_key' AND conrelid = 'anos_capas'::regclass
  ) THEN
    ALTER TABLE anos_capas DROP CONSTRAINT anos_capas_ano_key;
  END IF;
END $$;

-- Make user_id NOT NULL
ALTER TABLE anos_capas ALTER COLUMN user_id SET NOT NULL;

-- Add unique constraint on (ano, user_id)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'anos_capas_ano_user_id_key' AND conrelid = 'anos_capas'::regclass
  ) THEN
    ALTER TABLE anos_capas ADD CONSTRAINT anos_capas_ano_user_id_key UNIQUE (ano, user_id);
  END IF;
END $$;

-- Fix table: anos_oficios_circulares
-- Remove existing unique constraint on ano
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'anos_oficios_circulares_ano_key' AND conrelid = 'anos_oficios_circulares'::regclass
  ) THEN
    ALTER TABLE anos_oficios_circulares DROP CONSTRAINT anos_oficios_circulares_ano_key;
  END IF;
END $$;

-- Make user_id NOT NULL
ALTER TABLE anos_oficios_circulares ALTER COLUMN user_id SET NOT NULL;

-- Add unique constraint on (ano, user_id)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'anos_oficios_circulares_ano_user_id_key' AND conrelid = 'anos_oficios_circulares'::regclass
  ) THEN
    ALTER TABLE anos_oficios_circulares ADD CONSTRAINT anos_oficios_circulares_ano_user_id_key UNIQUE (ano, user_id);
  END IF;
END $$;

-- Make user_id NOT NULL for all other related tables
ALTER TABLE oficios ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE capas ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE oficios_circulares ALTER COLUMN user_id SET NOT NULL;