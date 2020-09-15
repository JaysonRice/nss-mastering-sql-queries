-- Book 3, CH 7: Transactions

-- Write a transaction to:
-- Add a new role for employees called Automotive Mechanic
-- Add five new mechanics, their data is up to you
-- Each new mechanic will be working at all three of these dealerships: 
-- Sollowaye Autos of New York, Hrishchenko Autos of New York and Cadreman Autos of New York

BEGIN;

SELECT * FROM employeetypes

INSERT INTO employeetypes(name)
	VALUES ('Automotive Mechanic')
	
INSERT INTO employees
	(first_name, last_name, email_address, phone, employee_type_id)
	VALUES
	('Jayson', 'Rice', 'jrice@gmail.com', '423-423-5554', 9),
	('Austin', 'Taylor', 'ataylor@gmail.com', '982-444-5554', 9),
	('Tyler', 'Smith', 'tsmith@gmail.com', '423-445-5654', 9),
	('Gabe', 'Ide', 'gide@gmail.com', '125-999-5554', 9),
	('Lindsey', 'King', 'lkinge@gmail.com', '887-422-3354', 9)

SELECT * FROM employees ORDER BY employee_id DESC;

SELECT * FROM dealerships
WHERE business_name LIKE 'Sollowaye%' OR business_name LIKE 'Hrishchenko%' OR business_name LIKE 'Cadreman%';

INSERT INTO dealershipemployees(dealership_id, employee_id)
VALUES
(50,1001),
(128, 1001),
(322, 1001),
(50,1002),
(128, 1002),
(322, 1002),
(50,1003),
(128, 1003),
(322, 1003),
(50,1004),
(128, 1004),
(322, 1004),
(50,1005),
(128, 1005),
(322, 1005)

COMMIT;

-- Creating a new dealership in Washington, D.C. called Felphun Automotive
-- Hire 3 new employees for the new dealership: Sales Manager, General Manager and Customer Service.
-- All employees that currently work at 
-- Scrogges Autos of District of Columbia will now start working at Felphun Automotive instead.

BEGIN;

INSERT INTO dealerships 
	(business_name, phone, city, state, website, tax_id)
	VALUES ('Felphun Automotive', '555-555-5565', 'Washington, D.C.', 'Virginia', 
		   'http://www.carnivalcars.com/felphun_automotive', 'er-924-35-yr4t')

SELECT * FROM dealerships ORDER BY dealership_id DESC

SELECT * FROM employees e
JOIN employeetypes et ON et.employee_type_id =  e.employee_type_id
WHERE et.name = 'Sales Manager' OR et.name = 'General Manager' OR et.name = 'Customer Service'

INSERT INTO dealershipemployees(dealership_id, employee_id)
VALUES
(1001, 1),
(1001, 3),
(1001, 19)

SELECT * FROM employees e
JOIN dealershipemployees de ON de.employee_id =  e.employee_id
JOIN dealerships d ON d.dealership_id =  de.dealership_id
WHERE d.business_name LIKE 'Scrogges%'

UPDATE dealershipemployees
SET dealership_id = 1001
WHERE dealership_id = 129;

COMMIT;

-- Book 3, CH 8: Transactions Cont.

-- Adding 5 brand new 2021 Honda CR-Vs to the inventory. 
-- They have I4 engines and are classified as a Crossover SUV or CUV. 
-- All of them have beige interiors but the exterior colors are 
-- Lilac, Dark Red, Lime, Navy and Sand. The floor price is $21,755 and the MSR price is $18,999.

BEGIN;

SELECT bt.name, ma.name, mo.name 
FROM vehicletypes vt
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
  JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id;

SELECT * FROM vehiclemakes
SELECT * FROM vehiclemodels
SELECT * FROM vehiclebodytypes

INSERT INTO vehiclemodels
(name)
VALUES('CR-V')

INSERT INTO vehiclemakes
(name)
VALUES('Honda')

INSERT INTO vehiclebodytypes
(name)
VALUES ('CUV')

INSERT INTO vehicletypes
(body_type_id, make_id, model_id)
VALUES (5, 6, 17)

INSERT INTO vehicles
(vin, engine_type, vehicle_type_id, exterior_color, interior_color, floor_price, msr_price,
 miles_count, year_of_car, is_sold)
VALUES
('VBQUC3S51DF812812', 'I4', 31, 'Lilac', 'Beige', 21755, 18999, 0, 2021, false),
('VDFUC9S51DM812776', 'I4', 31, 'Dark Red', 'Beige', 21755, 18999, 0, 2021, false),
('VRNUC2S31DB812911', 'I4', 31, 'Lime', 'Beige', 21755, 18999, 0, 2021, false),
('VCMUC9S51DR812139', 'I4', 31, 'Navy', 'Beige', 21755, 18999, 0, 2021, false),
('VELUC4S81DW812219', 'I4', 31, 'Sand', 'Beige', 21755, 18999, 0, 2021, false)

select * from vehicles ORDER BY vehicle_id DESC;

COMMIT;

-- For the CX-5s and CX-9s in the inventory that have not been sold, change the 
-- year of the car to 2021 since we will be updating our stock of Mazdas. 
-- For all other unsold Mazdas, update the year to 2020. 
-- The newer Mazdas all have red and black interiors.

