-- Get a list of the sales that was made for each sales type.

SELECT s.* , st.name
FROM sales s
INNER JOIN salestypes st ON st.sales_type_id = s.sales_type_id;

-- Get a list of sales with the VIN of the vehicle, the first name and last name of the customer, first name
-- and last name of the employee who made the sale and the name, city and state of the dealership.

SELECT v.vin,
	c.first_name as customer_first_name,
	c.last_name as customer_last_name,
	e.first_name as employee_first_name,
	e.last_name as employee_last_name,
	d.business_name,
	d.city,
	d.state
FROM sales s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN customers c ON s.customer_id = c.customer_id
JOIN employees e ON s.employee_id = e.employee_id
JOIN dealerships d ON s.dealership_id = d.dealership_id;

-- Get a list of all the dealerships and the employees, if any, working at each one.

SELECT d.business_name, CONCAT (e.first_name, '', e.last_name) as employee_name
FROM dealerships d
LEFT JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
LEFT JOIN employees e ON e.employee_id = de.employee_id;

-- Get a list of vehicles with the names of the body type, make, model and color.

SELECT
  v.vin,
  bt.name,
  ma.name,
  mo.name
FROM
  vehicles v
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
  JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id;

-- Produce a report that lists every dealership, the number of purchases 
-- done by each, and the number of leases done by each.

SELECT d.business_name, st.name as sales_type, COUNT (s.sale_id) as number_of_sales
FROM dealerships d
JOIN sales s ON s.dealership_id = d.dealership_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_id = 2
GROUP BY d.dealership_id, st.sales_type_id
ORDER BY d.dealership_id;


-- Produce a report that determines the most popular vehicle model that is leased.

SELECT mo.name, COUNT(s.sale_id) AS lease_count
FROM sales s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY mo.vehicle_model_id
ORDER BY COUNT (s.sale_id) DESC;

-- What is the most popular vehicle make in terms of number of sales?

SELECT ma.name, COUNT(s.sale_id) AS lease_count
FROM sales s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
GROUP BY ma.vehicle_make_id
ORDER BY COUNT (s.sale_id) DESC;

-- Which employee type sold the most of that make?

SELECT et.name, COUNT(s.employee_id)
FROM sales s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
JOIN employees e ON s.employee_id = e.employee_id
JOIN employeetypes et ON et.employee_type_id = e.employee_type_id
WHERE ma.vehicle_make_id =
	(
		SELECT ma.vehicle_make_id
		FROM sales s
		JOIN vehicles v ON s.vehicle_id = v.vehicle_id
		JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
		JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
		JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
		GROUP BY ma.vehicle_make_id
		ORDER BY COUNT (s.sale_id) DESC
		LIMIT 1
	)
GROUP BY et.employee_type_id
ORDER BY COUNT (s.employee_id) DESC;
