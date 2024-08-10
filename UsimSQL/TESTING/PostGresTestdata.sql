INSERT INTO usim_basedata DEFAULT VALUES;
INSERT INTO usim_bda_state (bda_id) VALUES(1);
INSERT INTO usim_planck_aeon (bda_id) VALUES(1);

-- approach for getting test scripts
-- simple approach
DROP TABLE IF EXISTS files;
CREATE TABLE files(filename text);
COPY files FROM PROGRAM 'find /usr/bin -maxdepth 1 -type f -printf "%f\n"';
SELECT * FROM files ORDER BY filename ASC;
-- function with superuser postgres
CREATE OR REPLACE FUNCTION files()
  RETURNS SETOF text AS
$BODY$
BEGIN
  SET client_min_messages TO WARNING;
  DROP TABLE IF EXISTS files;
  CREATE TEMP TABLE files(filename text);
  COPY files FROM PROGRAM 'find /usr/bin -maxdepth 1 -type f -printf "%f\n"';
  RETURN QUERY SELECT * FROM files ORDER BY filename ASC;
END;
$BODY$
  LANGUAGE plpgsql SECURITY DEFINER;
-- with program direct executes are also possible
-- need also a possibility to read the fetched filename
CREATE FUNCTION file.read(file text)
  RETURNS text AS $$
    DECLARE
      content text;
      tmp text;
    BEGIN
      file := quote_literal(file);
      tmp := quote_ident(uuid_generate_v4()::text);

      EXECUTE 'CREATE TEMP TABLE ' || tmp || ' (content text)';
      EXECUTE 'COPY ' || tmp || ' FROM ' || file;
      EXECUTE 'SELECT content FROM ' || tmp INTO content;
      EXECUTE 'DROP TABLE ' || tmp;

      RETURN content;
    END;
  $$ LANGUAGE plpgsql VOLATILE;
  SELECT file.read('/tmp/test.txt');
-- with EXECUTE we can run the code
EXECUTE read_file_content;
-- with postgres works well
 select * from pg_ls_dir('/usim_src/TESTING') WHERE pg_ls_dir LIKE '%.psql';