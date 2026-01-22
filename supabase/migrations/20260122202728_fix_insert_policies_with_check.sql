/*
  # Corrigir Políticas de INSERT - Enforce User ID Check
  
  ## Problema
  As políticas de INSERT tem WITH CHECK = true, permitindo que qualquer usuário
  autenticado crie registros sem verificar se o user_id é dele mesmo.
  
  ## Solução
  Atualizar todas as políticas de INSERT para verificar que o user_id
  corresponde ao usuário autenticado (auth.uid()).
  
  ## Tabelas Afetadas
  - anos
  - oficios
  - capas
  - anos_capas
  - oficios_circulares
  - anos_oficios_circulares
  
  ## Segurança
  Após esta migration, usuários só poderão inserir registros com seu próprio user_id.
*/

-- Fix INSERT policy for anos
DROP POLICY IF EXISTS "Users can insert own anos" ON anos;
CREATE POLICY "Users can insert own anos"
  ON anos FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Fix INSERT policy for oficios  
DROP POLICY IF EXISTS "Users can insert own oficios" ON oficios;
CREATE POLICY "Users can insert own oficios"
  ON oficios FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Fix INSERT policy for capas
DROP POLICY IF EXISTS "Users can insert own capas" ON capas;
CREATE POLICY "Users can insert own capas"
  ON capas FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Fix INSERT policy for anos_capas
DROP POLICY IF EXISTS "Users can insert own anos_capas" ON anos_capas;
CREATE POLICY "Users can insert own anos_capas"
  ON anos_capas FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Fix INSERT policy for oficios_circulares
DROP POLICY IF EXISTS "Users can insert own oficios_circulares" ON oficios_circulares;
CREATE POLICY "Users can insert own oficios_circulares"
  ON oficios_circulares FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Fix INSERT policy for anos_oficios_circulares
DROP POLICY IF EXISTS "Users can insert own anos_oficios_circulares" ON anos_oficios_circulares;
CREATE POLICY "Users can insert own anos_oficios_circulares"
  ON anos_oficios_circulares FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);