/*
  # Corrigir Isolamento de Usuários - Remover Políticas Públicas

  ## Problema
  - Políticas públicas antigas permitem que qualquer usuário veja todos os dados
  - Usuários deveriam ver apenas seus próprios dados

  ## Solução
  - Remover TODAS as políticas públicas que permitem acesso irrestrito
  - Manter apenas políticas de isolamento de usuário (authenticated)
  - Cada usuário verá apenas seus próprios dados

  ## Tabelas Afetadas
  - anos
  - oficios
  - anos_capas
  - capas
  - anos_oficios_circulares
  - oficios_circulares

  ## Políticas Removidas
  - Todas as políticas com role 'public' que permitem acesso total
*/

-- Remover políticas públicas de ANOS
DROP POLICY IF EXISTS "Permitir leitura pública de anos" ON anos;
DROP POLICY IF EXISTS "Permitir inserção de anos" ON anos;
DROP POLICY IF EXISTS "Permitir atualização de anos" ON anos;

-- Remover políticas públicas de OFICIOS
DROP POLICY IF EXISTS "Permitir leitura pública de oficios" ON oficios;
DROP POLICY IF EXISTS "Permitir inserção de oficios" ON oficios;
DROP POLICY IF EXISTS "Permitir atualização de oficios" ON oficios;

-- Remover políticas públicas de ANOS_CAPAS
DROP POLICY IF EXISTS "Permitir leitura de anos de capas" ON anos_capas;
DROP POLICY IF EXISTS "Permitir inserção de anos de capas" ON anos_capas;
DROP POLICY IF EXISTS "Permitir atualização de anos de capas" ON anos_capas;
DROP POLICY IF EXISTS "Permitir exclusão de anos de capas" ON anos_capas;

-- Remover políticas públicas de CAPAS
DROP POLICY IF EXISTS "Permitir leitura de capas" ON capas;
DROP POLICY IF EXISTS "Permitir inserção de capas" ON capas;
DROP POLICY IF EXISTS "Permitir atualização de capas" ON capas;
DROP POLICY IF EXISTS "Permitir exclusão de capas" ON capas;

-- Remover políticas públicas de ANOS_OFICIOS_CIRCULARES
DROP POLICY IF EXISTS "Permitir leitura de anos de ofícios circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Permitir inserção de anos de ofícios circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Permitir atualização de anos de ofícios circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Permitir exclusão de anos de ofícios circulares" ON anos_oficios_circulares;

-- Remover políticas públicas de OFICIOS_CIRCULARES
DROP POLICY IF EXISTS "Permitir leitura de ofícios circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Permitir inserção de ofícios circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Permitir atualização de ofícios circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Permitir exclusão de ofícios circulares" ON oficios_circulares;

-- Adicionar políticas de DELETE para usuários (faltavam nas tabelas anos e oficios)
CREATE POLICY "Users can delete own anos"
  ON anos FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own oficios"
  ON oficios FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own anos_capas"
  ON anos_capas FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own capas"
  ON capas FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own anos_oficios_circulares"
  ON anos_oficios_circulares FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own oficios_circulares"
  ON oficios_circulares FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);
