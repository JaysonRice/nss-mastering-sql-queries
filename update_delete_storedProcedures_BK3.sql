-- Book 3, CH 1: Updates

-- Rheta Raymen an employee of Carnival has asked to be transferred to a different dealership location.
-- She is currently at dealership 751.
-- She would like to work at dealership 20. Update her record to reflect her transfer.


UPDATE dealershipemployees de
SET dealership_id = 20
FROM employees e
WHERE de.employee_id = e.employee_id 
	AND e.first_name = 'Rheta' 
	AND e.last_name = 'Raymen' 
	AND de.dealership_id = 751;

-- Rheta works at multiple dealerships so make sure to specify only updating the 751 dealership.

-- To check and see if it worked
SELECT e.first_name, e.last_name, de.dealership_id
FROM dealershipemployees de
JOIN employees e ON de.employee_id = e.employee_id
WHERE e.first_name = 'Rheta' AND e.last_name = 'Raymen';

-- A Sales associate needs to update a sales record because her customer wants to pay with Mastercard instead of American Express. 
-- Update Customer, Layla Igglesden's Sales record which has an invoice number of 2781047589.

UPDATE sales s
SET payment_method = 'mastercard'
WHERE s.invoice_number = '2781047589';

-- Checking if it worked
SELECT *
FROM sales s
WHERE s.invoice_number = '2781047589';


-- Book 3, CH 2: Deletes

-- A sales employee at carnival creates a new sales record for a sale they are trying to close.
-- The customer, last minute decided not to purchase the vehicle. 
-- Help delete the Sales record with an invoice number of '7628231837'.

DELETE FROM sales
WHERE invoice_number = '7628231837';

-- An employee was recently fired so we must delete them from our database.
-- Delete the employee with employee_id of 35.
-- What problems might you run into when deleting? How would you recommend fixing it?

DELETE FROM employees
WHERE employee_id = 35;

-- Implement a soft delete in employees with an IsActive boolean column defaulting to true.

ALTER TABLE employees
ADD COLUMN is_active boolean
DEFAULT true;


-- Then when an employee needs to be deleted, update IsActive to false.

UPDATE employees e
SET is_active = false
WHERE e.employee_id = 35;

SELECT *
FROM employees
WHERE employee_id = 35;

-- Book 3, CH 4: Stored Procedures

-- They plan to do this by flagging the vehicle as is_sold which is a field on the Vehicles table.
-- When set to True this flag will indicate that the vehicle is no longer available in the inventory.

-- Add the is_sold column.
ALTER TABLE vehicles 
ADD COLUMN is_sold boolean
DEFAULT false;

-- Create a procedure for selling a vehicle.
CREATE PROCEDURE sell_vehicle(IN sold_vehicle_id integer)
LANGUAGE plpgsql
AS $$
BEGIN

UPDATE vehicles v
SET is_sold = true
WHERE v.vehicle_id = sold_vehicle_id;

END;
$$
-- Call the procedure to sell the 1st vehicle.
CALL sell_vehicle (1);

SELECT * FROM vehicles
WHERE is_sold = true



