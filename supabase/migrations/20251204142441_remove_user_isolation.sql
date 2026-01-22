/*
  # Remove User Isolation

  1. Changes
    - Remove all user isolation policies
    - Create public access policies for all tables
    - Allow anyone to read, insert, update, and delete data
  
  2. Security
    - All data becomes publicly accessible
    - No authentication required
*/

-- Drop all existing user isolation policies
DROP POLICY IF EXISTS "Users can read own anos" ON anos;
DROP POLICY IF EXISTS "Users can create own anos" ON anos;
DROP POLICY IF EXISTS "Users can update own anos" ON anos;
DROP POLICY IF EXISTS "Users can delete own anos" ON anos;

DROP POLICY IF EXISTS "Users can read own oficios" ON oficios;
DROP POLICY IF EXISTS "Users can create own oficios" ON oficios;
DROP POLICY IF EXISTS "Users can update own oficios" ON oficios;
DROP POLICY IF EXISTS "Users can delete own oficios" ON oficios;

DROP POLICY IF EXISTS "Users can read own capas" ON capas;
DROP POLICY IF EXISTS "Users can create own capas" ON capas;
DROP POLICY IF EXISTS "Users can update own capas" ON capas;
DROP POLICY IF EXISTS "Users can delete own capas" ON capas;

DROP POLICY IF EXISTS "Users can read own anos_capas" ON anos_capas;
DROP POLICY IF EXISTS "Users can create own anos_capas" ON anos_capas;
DROP POLICY IF EXISTS "Users can update own anos_capas" ON anos_capas;
DROP POLICY IF EXISTS "Users can delete own anos_capas" ON anos_capas;

DROP POLICY IF EXISTS "Users can read own oficios_circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Users can create own oficios_circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Users can update own oficios_circulares" ON oficios_circulares;
DROP POLICY IF EXISTS "Users can delete own oficios_circulares" ON oficios_circulares;

DROP POLICY IF EXISTS "Users can read own anos_oficios_circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Users can create own anos_oficios_circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Users can update own anos_oficios_circulares" ON anos_oficios_circulares;
DROP POLICY IF EXISTS "Users can delete own anos_oficios_circulares" ON anos_oficios_circulares;

-- Create public access policies for anos
CREATE POLICY "Allow public read access to anos"
  ON anos FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Allow public insert access to anos"
  ON anos FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Allow public update access to anos"
  ON anos FOR UPDATE
  TO public
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow public delete access to anos"
  ON anos FOR DELETE
  TO public
  USING (true);

-- Create public access policies for oficios
CREATE POLICY "Allow public read access to oficios"
  ON oficios FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Allow public insert access to oficios"
  ON oficios FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Allow public update access to oficios"
  ON oficios FOR UPDATE
  TO public
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow public delete access to oficios"
  ON oficios FOR DELETE
  TO public
  USING (true);

-- Create public access policies for capas
CREATE POLICY "Allow public read access to capas"
  ON capas FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Allow public insert access to capas"
  ON capas FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Allow public update access to capas"
  ON capas FOR UPDATE
  TO public
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow public delete access to capas"
  ON capas FOR DELETE
  TO public
  USING (true);

-- Create public access policies for anos_capas
CREATE POLICY "Allow public read access to anos_capas"
  ON anos_capas FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Allow public insert access to anos_capas"
  ON anos_capas FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Allow public update access to anos_capas"
  ON anos_capas FOR UPDATE
  TO public
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow public delete access to anos_capas"
  ON anos_capas FOR DELETE
  TO public
  USING (true);

-- Create public access policies for oficios_circulares
CREATE POLICY "Allow public read access to oficios_circulares"
  ON oficios_circulares FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Allow public insert access to oficios_circulares"
  ON oficios_circulares FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Allow public update access to oficios_circulares"
  ON oficios_circulares FOR UPDATE
  TO public
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow public delete access to oficios_circulares"
  ON oficios_circulares FOR DELETE
  TO public
  USING (true);

-- Create public access policies for anos_oficios_circulares
CREATE POLICY "Allow public read access to anos_oficios_circulares"
  ON anos_oficios_circulares FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Allow public insert access to anos_oficios_circulares"
  ON anos_oficios_circulares FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Allow public update access to anos_oficios_circulares"
  ON anos_oficios_circulares FOR UPDATE
  TO public
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow public delete access to anos_oficios_circulares"
  ON anos_oficios_circulares FOR DELETE
  TO public
  USING (true);
