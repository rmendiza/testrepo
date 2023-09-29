-- Create a table for products
CREATE TABLE products (
   product_id   SERIAL       NOT NULL, -- Use SERIAL for primary key
   product_name VARCHAR(50)  NOT NULL, -- Use smaller size for VARCHAR
   price        NUMERIC(10,2)NOT NULL, -- Use NUMERIC with precision and scale for money
   category     VARCHAR(20)  NOT NULL,
   description  VARCHAR(1000)         , -- Use VARCHAR instead of CHAR
   CONSTRAINT products_pk PRIMARY KEY (product_id)
);

-- Create a function to generate random numbers
CREATE FUNCTION random_number(min NUMERIC, max NUMERIC)
RETURNS NUMERIC
AS
$$
DECLARE
  rv NUMERIC := 0;
BEGIN
  IF max < min THEN
    RETURN rv;
  END IF;

  rv := floor(random()*(max-min+1)) + min; -- Use floor and +1 to get integers in range

  RETURN rv;
END;
$$ LANGUAGE plpgsql;

-- Insert some data into the products table
INSERT INTO products (product_id,  product_name,
                      price,       category, 
                      description)
SELECT GENERATE_SERIES AS product_id -- Use alias for clarity
     , initcap(lower(random_string(5, 10))) AS product_name -- Use random_string function from previous script
     , random_number(10, 1000) AS price -- Use random_number function to generate prices
     , CASE WHEN random() < 0.5 THEN 'Books' ELSE 'Games' END AS category -- Use CASE to generate categories randomly
     , 'This is a product description' AS description -- Use a fixed value for description
  FROM GENERATE_SERIES(1, 50); -- Generate 50 rows of data

-- Update some data in the products table
UPDATE products 
   SET price = price * 1.1, -- Increase the price by 10%
       description = 'This is an updated product description' -- Change the description
 WHERE category = 'Books'; -- Only update the books category

-- Analyze the products table (optional)
ANALYZE products; -- Use ANALYZE instead of VACUUM ANALYZE to update statistics only
