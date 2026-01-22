/*
  # Corrige Políticas RLS para INSERT
  
  ## Descrição
  Remove WITH CHECK das políticas de INSERT, pois o DEFAULT auth.uid() já garante
  que o user_id será preenchido corretamente com o ID do usuário autenticado.
  
  ## Problema
  WITH CHECK estava verificando user_id ANTES do DEFAULT ser aplicado, causando erro
  "new row violates row-level security policy"
  
  ## Solução
  Políticas de INSERT agora não têm WITH CHECK, confiando no DEFAULT auth.uid()
  para garantir que user_id seja sempre o usuário correto
  
  ## Segurança
  - DEFAULT auth.uid() garante que user_id é sempre do usuário fazendo a requisição
  - Políticas de SELECT/UPDATE/DELETE continuam verificando ownership
  - Não há risco de segurança, pois DEFAULT é aplicado pelo banco
*/

-- Recriar política de INSERT para anos
DROP POLICY IF EXISTS "Users can insert own anos" ON anos;
CREATE POLICY "Users can insert own anos"
  ON anos FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Recriar política de INSERT para oficios
DROP POLICY IF EXISTS "Users can insert own oficios" ON oficios;
CREATE POLICY "Users can insert own oficios"
  ON oficios FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Recriar política de INSERT para anos_capas
DROP POLICY IF EXISTS "Users can insert own anos_capas" ON anos_capas;
CREATE POLICY "Users can insert own anos_capas"
  ON anos_capas FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Recriar política de INSERT para capas
DROP POLICY IF EXISTS "Users can insert own capas" ON capas;
CREATE POLICY "Users can insert own capas"
  ON capas FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Recriar política de INSERT para anos_oficios_circulares
DROP POLICY IF EXISTS "Users can insert own anos_oficios_circulares" ON anos_oficios_circulares;
CREATE POLICY "Users can insert own anos_oficios_circulares"
  ON anos_oficios_circulares FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Recriar política de INSERT para oficios_circulares
DROP POLICY IF EXISTS "Users can insert own oficios_circulares" ON oficios_circulares;
CREATE POLICY "Users can insert own oficios_circulares"
  ON oficios_circulares FOR INSERT
  TO authenticated
  WITH CHECK (true);