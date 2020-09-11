-- Book 3, CH 5: Triggers

-- Create a trigger for when a new Sales record is added, 
-- set the purchase date to 3 days from the current date.

CREATE OR REPLACE FUNCTION set_purchase_date() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
  -- trigger function logic
  UPDATE sales
  SET purchase_date = CURRENT_DATE + integer '3'
  WHERE sales.sale_id = NEW.sale_id;
  
  RETURN NULL;
END;
$$
-- Trigger whenever a new sale is added
CREATE TRIGGER new_sale_made
  AFTER INSERT
  ON sales
  FOR EACH ROW
  EXECUTE PROCEDURE set_purchase_date();
  
-- Purchase date will now be 3 days from the current date
INSERT INTO sales (sales_type_id, vehicle_id, employee_id, customer_id,
				   dealership_id, price, deposit, purchase_date, 
				   pickup_date, invoice_number, payment_method)
VALUES(1, 1, 1, 1, 1,  11111.11, 9001, CURRENT_DATE, '09-18-2020', '1111021111', 'jcb')

-- Checking
SELECT * FROM sales 
WHERE vehicle_id = 1 AND employee_id = 1

-- Create a trigger for updates to the Sales table.
-- If the pickup date is on or before the purchase date, set the pickup date to 7 days after the purchase date.
-- If the pickup date is after the purchase date but less than 7 days out from the purchase date, 
-- add 4 additional days to the pickup date.

-- MY SOLUTION
CREATE OR REPLACE FUNCTION set_pickup_date() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
  -- trigger function logic
  UPDATE sales
  SET pickup_date =
  CASE 
  WHEN purchase_date >= pickup_date THEN 
  purchase_date + integer '7'
	
  WHEN pickup_date > purchase_date AND pickup_date < purchase_date + integer '7' THEN
  pickup_date + integer '4'
	
  ELSE pickup_date
  
END
  WHERE sales.sale_id = OLD.sale_id;
  RETURN NULL;
END;
$$

-- Trigger whenever a sale is updated
CREATE TRIGGER update_sale
  AFTER UPDATE
  ON sales
  FOR EACH ROW
  WHEN (pg_trigger_depth() < 1)
  EXECUTE PROCEDURE set_pickup_date();
  
-- WHEN (pg_trigger_depth() < 1) keeps track of how many times a trigger has caused another trigger,
-- preventing an infinite loop

UPDATE sales
SET purchase_date = '09-15-2020'
WHERE employee_id = 122

SELECT * FROM sales 
WHERE employee_id = 122

-- JISIE's CODE

CREATE OR REPLACE FUNCTION conditionally_set_pickup_date() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
	IF NEW.pickup_date > NEW.purchase_date AND NEW.pickup_date <= NEW.purchase_date  + integer '7' THEN
	  NEW.pickup_date := NEW.pickup_date + integer '4';
	ELSIF NEW.pickup_date <= NEW.purchase_date THEN
	  NEW.pickup_date := NEW.purchase_date + integer '7';
	END IF;
  
  RETURN NEW;
END;
$$
-- The before update is important for changing the data to the new pickup date before updating.
CREATE TRIGGER update_sale_made_pickup_date
  BEFORE UPDATE
  ON sales
  FOR EACH ROW
  EXECUTE PROCEDURE conditionally_set_pickup_date();
  

-- Book 3, CH 6: More Triggers

-- Because Carnival is a single company, we want to ensure that there is consistency in the data
-- provided to the user. Each dealership has it's own website but we want to make sure the website
-- URL are consistent and easy to remember. Therefore, any time a new dealership is added or an existing
-- dealership is updated, we want to ensure that the website URL has the following format:
-- http://www.carnivalcars.com/{name of the dealership with underscores separating words}.

