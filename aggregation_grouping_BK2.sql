CH 8

-- Write a query that shows the total purchase sales income per dealership.

SELECT d.business_name, SUM (s.price) AS sales_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE s.sales_type_id = 1
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

-- Write a query that shows the purchase sales income per dealership for the current month.

SELECT d.business_name, SUM (s.price) AS sales_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE s.sales_type_id = 1 
	AND EXTRACT (MONTH FROM s.purchase_date) = EXTRACT(MONTH FROM CURRENT_DATE) 
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

-- Write a query that shows the purchase sales income per dealership for the current year.

SELECT d.business_name, SUM (s.price) AS sales_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE s.sales_type_id = 1 
	AND EXTRACT (YEAR FROM s.purchase_date) = EXTRACT(YEAR FROM CURRENT_DATE) 
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

-- Write a query that shows the total lease income per dealership.

SELECT d.business_name, SUM (s.price) AS lease_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE s.sales_type_id = 2
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

-- Write a query that shows the lease income per dealership for the current month.

SELECT d.business_name, SUM (s.price) AS sales_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE s.sales_type_id = 2 
	AND EXTRACT (MONTH FROM s.purchase_date) = EXTRACT(MONTH FROM CURRENT_DATE) 
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

-- Write a query that shows the lease income per dealership for the current year.

SELECT d.business_name, SUM (s.price) AS sales_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE s.sales_type_id = 2 
	AND EXTRACT (YEAR FROM s.purchase_date) = EXTRACT(YEAR FROM CURRENT_DATE) 
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

-- Write a query that shows the total income (purchase and lease) per employee.

SELECT CONCAT(e.first_name, ' ', e.last_name) as employee_name, SUM (s.price) AS total_income
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
GROUP BY e.employee_id
ORDER BY total_income DESC;

-- CH 9

-- Across all dealerships, which model of vehicle has the lowest current inventory?

SELECT  vm.name, COUNT (v.vehicle_id) as total_vehicles
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemodels vm ON vt.model_id = vm.vehicle_model_id
GROUP BY vm.name
ORDER BY total_vehicles ASC
LIMIT 1;

-- Across all dealerships, which model of vehicle has the highest current inventory? 

SELECT  vm.name, COUNT (v.vehicle_id) as total_vehicles
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemodels vm ON vt.model_id = vm.vehicle_model_id
GROUP BY vm.name
ORDER BY total_vehicles DESC
LIMIT 1;

-- Which dealerships are currently selling the least number of vehicle models? 
-- This will let dealerships market vehicle models more effectively per region.
SELECT
  d.business_name,
  COUNT(mo.vehicle_model_id)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN vehicles v ON s.vehicle_id = v.vehicle_id
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY
  d.dealership_id
ORDER BY
  COUNT(mo.vehicle_model_id);

-- Which dealerships are currently selling the highest number of vehicle models? 
-- This will let dealerships know which regions have either a high population, or less brand loyalty.
SELECT
  d.business_name,
  COUNT(mo.vehicle_model_id)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN vehicles v ON s.vehicle_id = v.vehicle_id
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY
  d.dealership_id
ORDER BY
  COUNT(mo.vehicle_model_id) DESC;