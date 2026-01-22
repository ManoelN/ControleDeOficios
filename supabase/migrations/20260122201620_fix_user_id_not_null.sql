/*
  # Corrigir colunas user_id para NOT NULL com DEFAULT
  
  ## Descrição
  Corrige todas as colunas user_id para serem NOT NULL com DEFAULT auth.uid()
  
  ## Alterações
  - Altera todas as tabelas para ter user_id NOT NULL DEFAULT auth.uid()
  - Isso garante que todo registro seja automaticamente associado ao usuário logado
*/

-- Alterar anos
ALTER TABLE anos 
ALTER COLUMN user_id SET DEFAULT auth.uid(),
ALTER COLUMN user_id SET NOT NULL;

-- Alterar oficios
ALTER TABLE oficios 
ALTER COLUMN user_id SET DEFAULT auth.uid(),
ALTER COLUMN user_id SET NOT NULL;

-- Alterar anos_capas
ALTER TABLE anos_capas 
ALTER COLUMN user_id SET DEFAULT auth.uid(),
ALTER COLUMN user_id SET NOT NULL;

-- Alterar capas
ALTER TABLE capas 
ALTER COLUMN user_id SET DEFAULT auth.uid(),
ALTER COLUMN user_id SET NOT NULL;

-- Alterar anos_oficios_circulares
ALTER TABLE anos_oficios_circulares 
ALTER COLUMN user_id SET DEFAULT auth.uid(),
ALTER COLUMN user_id SET NOT NULL;

-- Alterar oficios_circulares
ALTER TABLE oficios_circulares 
ALTER COLUMN user_id SET DEFAULT auth.uid(),
ALTER COLUMN user_id SET NOT NULL;