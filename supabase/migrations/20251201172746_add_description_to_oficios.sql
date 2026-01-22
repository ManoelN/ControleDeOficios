/*
  # Add description field to oficios table

  1. Changes
    - Add `descricao` column to `oficios` table
      - Type: text
      - Nullable: true (optional field)
      - Purpose: Store user-provided description like "Enviado para Controladoria"
  
  2. Notes
    - Field is optional to maintain backward compatibility
    - Existing records will have NULL description
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'oficios' AND column_name = 'descricao'
  ) THEN
    ALTER TABLE oficios ADD COLUMN descricao text;
  END IF;
END $$;
