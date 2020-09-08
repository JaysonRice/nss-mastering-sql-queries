-- Creating Carnival Reports
-- Team Project: Carnival Database

-- Who are the top 5 employees for generating sales income?

SELECT CONCAT(e.first_name, ' ', e.last_name) as employee_name, SUM (s.price) AS total_income
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
GROUP BY e.employee_id
ORDER BY total_income DESC
LIMIT 5;


-- Who are the top 5 dealership for generating sales income?

SELECT business_name, SUM (s.price) AS total_income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY d.dealership_id
ORDER BY total_income DESC
LIMIT 5;

-- Which vehicle model generated the most sales income?

SELECT mo.name as vehicle_model, SUM (s.price) as total_sales
FROM sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN vehicles v ON s.vehicle_id = v.vehicle_id
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY vehicle_model
ORDER BY total_sales DESC
LIMIT 1;

-- Which employees generate the most income per dealership?

SELECT CONCAT(e.first_name, ' ', e.last_name) as employee_name, d.business_name, sum (s.price) as total_income
FROM employees e
   JOIN dealershipemployees de ON de.employee_id = e.employee_id
   JOIN dealerships d ON de.dealership_id = d.dealership_id
   JOIN sales s ON s.employee_id = e.employee_id
GROUP BY employee_name, d.business_name
ORDER BY total_income DESC;

-- In our Vehicle inventory, show the count of each Model that is in stock.

SELECT mo.name, COUNT(v.vehicle_id) as models
FROM vehicles v
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY mo.vehicle_model_id
ORDER BY COUNT(v.vehicle_id) DESC;


-- In our Vehicle inventory, show the count of each Make that is in stock.

SELECT ma.name, COUNT(v.vehicle_id) as makes
FROM vehicles v
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclemakes ma ON vt.model_id = ma.vehicle_make_id
GROUP BY ma.vehicle_make_id
ORDER BY COUNT(v.vehicle_id) DESC;


-- In our Vehicle inventory, show the count of each BodyType that is in stock.

SELECT bt.name, COUNT(v.vehicle_id) as body_types
FROM vehicles v
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
GROUP BY bt.vehicle_body_type_id
ORDER BY COUNT(v.vehicle_id) DESC;


-- Which US state's customers have the highest average purchase price for a vehicle?

SELECT c.state, ROUND (AVG (s.price), 2) as average_purchase_price
FROM sales s
  JOIN customers c on s.customer_id = c.customer_id
GROUP BY c.state
ORDER BY average_purchase_price DESC;






