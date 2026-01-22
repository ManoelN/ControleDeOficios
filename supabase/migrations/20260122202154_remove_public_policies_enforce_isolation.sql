/*
  # Remove Políticas Públicas e Forçar Isolamento por Usuário
  
  ## Problema
  Existem políticas públicas antigas que permitem acesso a todos os dados,
  conflitando com as políticas de isolamento por usuário.
  
  ## Solução
  - Remove TODAS as políticas públicas antigas (roles = public, qual = true)
  - Mantém apenas as políticas de isolamento por usuário (roles = authenticated)
  - Garante que cada usuário veja apenas seus próprios dados
  
  ## Tabelas Afetadas
  - anos_capas
  - capas
  - anos_oficios_circulares
  - oficios_circulares
  
  ## Segurança
  Após esta migration, todos os dados serão estritamente isolados por usuário.
*/

-- Remover políticas públicas de anos_capas
DROP POLICY IF EXISTS "Permitir leitura de anos de capas" ON anos_capas;
DROP POLICY IF EXISTS "Permitir inserção de anos de capas" ON anos_capas;
DROP POLICY IF EXISTS "Permitir atualização de anos de capas" ON anos_capas;
DROP POLICY IF EXISTS "Permitir exclusão de anos de capas" ON anos_capas;

-- Remover políticas públicas de capas
DROP POLICY IF EXISTS "Permitir leitura de capas" ON capas;
DROP POLICY IF EXISTS "Permitir inserção de capas" ON capas;
DROP POLICY IF EXISTS "Permitir atualização de capas" ON capas;
DROP POLICY IF EXISTS "Permitir exclusão de capas" ON capas;

-- Remover políticas públicas de anos_oficios_circulares
DROP POLICY IF EXISTS "Permitir leitura de anos de ofícios circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Permitir inserção de anos de ofícios circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Permitir atualização de anos de ofícios circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Permitir exclusão de anos de ofícios circulares" ON anos_oficios_circulares;

-- Remover políticas públicas de oficios_circulares
DROP POLICY IF EXISTS "Permitir leitura de ofícios circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Permitir inserção de ofícios circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Permitir atualização de ofícios circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Permitir exclusão de ofícios circulares" ON oficios_circulares;