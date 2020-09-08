-- Write a query that returns the business name, city, state, and website for each dealership.

SELECT
    d.business_name,
    d.city,
    d.state,
	d.website
FROM Dealerships d

-- Write a query that returns the first name, last name, and email address of every customer.

SELECT
    c.first_name,
    c.last_name,
    c.email
FROM Customers c


-- Get a list of sales records where the sale was a lease.

SELECT *
FROM Sales s
WHERE sales_type_id = 2;

-- Get a list of sales where the purchase date is within the last two years.

SELECT *
FROM Sales s
WHERE purchase_date >= CURRENT_DATE - '2years':: interval
ORDER BY purchase_date

-- Get a list of sales where the deposit was above 5000 or the customer payed with American Express.

SELECT *
FROM Sales s
WHERE deposit >= 5000 OR payment_method = 'americanexpress'
ORDER BY deposit

-- Get a list of employees whose first names start with "M" or ends with "E".

SELECT *
FROM Employees e
WHERE first_name LIKE '%e' OR first_name LIKE 'M%';

-- Get a list of employees whose phone numbers have the 600 area code.

SELECT *
FROM Employees e
WHERE phone LIKE '600%'
