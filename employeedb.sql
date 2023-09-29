-- Get the current timestamp as a string
SELECT TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDDHH24MISS') INTO table_name;

-- Create a dynamic SQL statement to create the table
EXECUTE 'CREATE TABLE employees_' || table_name || ' (
     employee_id   NUMERIC       NOT NULL,
     first_name    VARCHAR(1000) NOT NULL,
     last_name     VARCHAR(1000) NOT NULL,
     date_of_birth DATE                   ,
     phone_number  VARCHAR(1000) NOT NULL,
     junk          CHAR(1000)             ,
     last_modified TIMESTAMP              , -- Add a last_modified column
     CONSTRAINT employees_pk_' || table_name || ' PRIMARY KEY (employee_id)
  );';

CREATE FUNCTION random_string(minlen NUMERIC, maxlen NUMERIC)
RETURNS VARCHAR(1000)
AS
$$
DECLARE
  rv VARCHAR(20) := '';
  i  INTEGER := 0;
  len INTEGER := 0;
BEGIN
  IF maxlen < 1 OR minlen < 1 OR maxlen < minlen THEN
    RETURN rv;
  END IF;

  len := floor(random()*(maxlen-minlen)) + minlen;

  FOR i IN 1..floor(len) LOOP
    rv := rv || chr(97+CAST(random() * 25 AS INTEGER));
  END LOOP;
  RETURN rv;
END;
$$ LANGUAGE plpgsql;

-- Create a dynamic SQL statement to insert data into the table
EXECUTE 'INSERT INTO employees_' || table_name || ' (employee_id,  first_name,
                       last_name,    date_of_birth, 
                       phone_number, junk, last_modified)
SELECT GENERATE_SERIES
     , initcap(lower(random_string(2, 8)))
     , initcap(lower(random_string(2, 8)))
     , CURRENT_DATE - CAST(floor(random() * 365 * 10 + 40 * 365) AS NUMERIC) * INTERVAL ''1 DAY''
     , CAST(floor(random() * 9000 + 1000) AS NUMERIC)
     , ''junk''
     , CURRENT_TIMESTAMP -- Set the last_modified column to the current timestamp
  FROM GENERATE_SERIES(1, 30);';

-- Create a dynamic SQL statement to update data in the table
EXECUTE 'UPDATE employees_' || table_name || '
   SET first_name=''MARKUS'', 
       last_name=''WINAND'',
       last_modified = CURRENT_TIMESTAMP -- Update the last_modified column when changing other columns
 WHERE employee_id=123;';

-- Create a dynamic SQL statement to vacuum analyze the table
EXECUTE 'VACUUM ANALYZE employees_' || table_name || ';';
