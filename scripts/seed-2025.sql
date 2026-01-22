-- Script para popular o ano 2025 com ofícios 001-901 já utilizados
-- Total de 1500 ofícios por ano

-- 1. Criar o ano 2025 se não existir
INSERT INTO anos (ano, ativo, created_at)
VALUES (2025, true, now())
ON CONFLICT (ano) DO NOTHING;

-- 2. Obter o ID do ano 2025
DO $$
DECLARE
  ano_2025_id uuid;
  i integer;
BEGIN
  SELECT id INTO ano_2025_id FROM anos WHERE ano = 2025;

  -- 3. Criar todos os ofícios de 1 a 1500
  FOR i IN 1..1500 LOOP
    INSERT INTO oficios (ano_id, numero, status, marcado_em, usuario, created_at, updated_at)
    VALUES (
      ano_2025_id,
      i,
      CASE
        WHEN i <= 901 THEN 'utilizado'
        ELSE 'disponivel'
      END,
      CASE
        WHEN i <= 901 THEN now()
        ELSE NULL
      END,
      CASE
        WHEN i <= 901 THEN 'Sistema (Pré-cadastrado)'
        ELSE NULL
      END,
      now(),
      now()
    )
    ON CONFLICT (ano_id, numero) DO NOTHING;
  END LOOP;

  RAISE NOTICE 'Ano 2025 criado com sucesso! Total: 1500 ofícios (001-901 utilizados, 902-1500 disponíveis).';
END $$;
