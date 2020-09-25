-- Book 4, Final Group Project

-- Indexes

-- Often need to see sales data from particular dealerships, employees, or customers
CREATE INDEX sales_employee_idx ON sales
(
    employee_id
);

EXPLAIN ANALYZE SELECT * FROM sales
WHERE employee_id = 2;

-- Find sales by customer_id
CREATE INDEX sales_customer_idx ON sales
(
    customer_id
);

EXPLAIN ANALYZE SELECT * FROM sales

WHERE customer_id = 2;

-- Find employees who make the largest sales
CREATE INDEX sales_price_idx ON sales
(
   price
);

EXPLAIN ANALYZE SELECT e.first_name, e.last_name, s.price FROM sales s
JOIN employees e ON e.employee_id = s.employee_id
WHERE price > 70000 and price < 85000;


-- Look up customers
CREATE INDEX customer_name_idx ON customers
(
    last_name, first_name
);

EXPLAIN ANALYZE SELECT * FROM customers
WHERE last_name = 'Gresswell';


-- Look up employees
CREATE INDEX employee_idx ON employees
(
    last_name, first_name
);

EXPLAIN ANALYZE SELECT * FROM employees
WHERE last_name = 'Graalmans';

-- Look up dealerships
CREATE INDEX dealership_idx ON dealerships
(
    business_name
);

EXPLAIN ANALYZE SELECT * FROM dealerships
WHERE business_name = 'Geard Autos of New Jersey';

-- Transactions

-- Update stored procedure for returning a vehicle to 
-- rollback if returned or is_sold doesn't update correctly.

CREATE OR REPLACE PROCEDURE return_sold_vehicle(in vehicleId int)
LANGUAGE plpgsql
AS $$
BEGIN

	UPDATE sales
	SET returned = true
	WHERE vehicle_id = vehicleId;
		
	UPDATE vehicles
	SET is_sold = false
	WHERE vehicle_id = vehicleId;
	
	EXCEPTION WHEN others THEN 
  ROLLBACK;
  
END
$$;

-- Views
-- Track employee sales metrics
CREATE OR REPLACE VIEW employee_sales_metrics AS
  SELECT 
    CONCAT (e.first_name, ' ', e.last_name) AS full_name,
    SUM (s.price) AS sum_of_sales,
	ROUND (AVG (s.price),2) AS average_sale_price,
	COUNT (s.sale_id) AS number_of_sales
	FROM employees e
  INNER JOIN sales s ON s.employee_id = e.employee_id
  GROUP BY full_name
  ORDER BY sum_of_sales DESC;

SELECT * from employee_sales_metrics

-- Track dealership sales metrics
CREATE OR REPLACE VIEW dealership_sales_metrics AS
  SELECT 
    d.business_name,
    SUM (s.price) AS sum_of_sales,
	ROUND (AVG (s.price),2) AS average_sale_price,
	COUNT (s.sale_id) AS number_of_sales
	FROM dealerships d
  INNER JOIN sales s ON s.dealership_id = d.dealership_id
  GROUP BY d.business_name
  ORDER BY number_of_sales DESC;

SELECT * from dealership_sales_metrics

-- Track most popular vehicles
CREATE OR REPLACE VIEW vehicle_type_sold_metrics AS
  SELECT
  CONCAT (vmk.name , ' ', vmd.name , ' ', vbt.name) AS vehicle_name, COUNT(vt.vehicle_type_id) AS number_sold
	FROM vehicles v
  INNER JOIN sales s ON s.vehicle_id = v.vehicle_id
  INNER JOIN VehicleTypes vt ON vt.vehicle_type_id = v.vehicle_type_id
  INNER JOIN vehiclemakes vmk ON vt.make_id = vmk.vehicle_make_id
  INNER JOIN vehiclemodels vmd ON vt.model_id = vmd.vehicle_model_id
  INNER JOIN vehiclebodytypes vbt ON vt.body_type_id = vbt.vehicle_body_type_id
  GROUP BY vt.vehicle_type_id, vmk.name, vmd.name, vbt.name
  ORDER BY number_sold DESC;

EXPLAIN ANALYZE SELECT * from vehicle_type_sold_metrics



