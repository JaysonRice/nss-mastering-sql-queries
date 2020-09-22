-- Book 4, Carnival: Indexes

-- Let's take a look at how some of our queries perform. Take notes of how each query performs.
-- Then create indexes for each query below. Rerun your queries to see if they improve. 
-- If they do not improve, why?


CREATE INDEX employee_type_sales_idx ON Employees
(
    employee_type_id
);

EXPLAIN ANALYZE SELECT * from Employees WHERE employee_type_id = 1
-- Exexution time before index: 0.139 ms
-- Exexution time after index: 0.082 ms
	
	
CREATE INDEX sales_dealership_idx ON Sales
(
    dealership_id
);

EXPLAIN ANALYZE SELECT * from Sales WHERE dealership_id = 500;
-- Exexution time before index: 0.159 ms
-- Exexution time after index: 0.068 ms
	
CREATE INDEX customers_state_idx ON customers
(
    state
);

EXPLAIN ANALYZE SELECT * from customers WHERE state = 'CA';
-- Exexution time before index: 7.739 ms
-- Exexution time after index: 0.175 ms

CREATE INDEX vehicles_year_idx ON vehicles
(
    year_of_car
);

EXPLAIN ANALYZE SELECT * from vehicles where year_of_car BETWEEN 2018 AND 2020;
-- Exexution time before index: 0.930 ms
-- Exexution time after index: 0.250 ms

CREATE INDEX vehicles_floor_price_idx ON vehicles
(
    floor_price
);

EXPLAIN ANALYZE SELECT * from vehicles where floor_price < 30000;
-- Exexution time before index: 0.188 ms
-- Exexution time after index: 0.245 ms
-- Using < will use sequential scan instead of bitmap
