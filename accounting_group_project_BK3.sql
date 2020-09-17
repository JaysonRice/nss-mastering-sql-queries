-- Book 3, Carnival: Accounting & HR

-- Provide a way for the accounting team to track all financial transactions by creating
-- a new table called Accounts Receivable. The table should have the following columns: 
-- credit_amount, debit_amount, date_received as well as a PK and a FK to associate a sale
-- with each transaction.

CREATE TABLE accounts_receivable (
	accounts_receivable_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    credit_amount money,
    debit_amount money,
	date_received date,
	sale_id int,
	FOREIGN KEY (sale_id) REFERENCES sales(sale_id)
); 

-- Set up a trigger on the Sales table. When a new row is added, add a new record to the Accounts
-- Receivable table with the deposit as credit_amount, the timestamp as date_received and
-- the appropriate sale_id.

CREATE OR replace FUNCTION new_accounts_receivable()
	RETURNS trigger
	LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO accounts_receivable (credit_amount, debit_amount, date_received, sale_id) 
	VALUES (NEW.deposit, NULL, CURRENT_DATE, NEW.sale_id);
	RETURN NULL;
END;
$$

CREATE TRIGGER new_sale 
AFTER INSERT
ON sales
FOR EACH ROW EXECUTE PROCEDURE new_accounts_receivable();

INSERT INTO sales (sales_type_id, vehicle_id, employee_id, customer_id,
				   dealership_id, price, deposit, purchase_date, 
				   pickup_date, invoice_number, payment_method)
VALUES(2, 3, 3, 3, 3,  99999.11, 9001, CURRENT_DATE, '09-18-2020', '1111021171', 'jcb')

select * from sales order by sale_id desc
select * from accounts_receivable

-- Set up a trigger on the Sales table for when the sale_returned flag is updated. 
-- Add a new row to the Accounts Receivable table with the deposit as debit_amount, 
-- the timestamp as date_received, etc.

CREATE OR replace FUNCTION accounts_receivable_deposit()
	RETURNS trigger
	LANGUAGE plpgsql
AS $$
BEGIN
IF NEW.returned = true THEN
	INSERT INTO accounts_receivable (debit_amount, credit_amount, date_received, sale_id) 
	VALUES (NEW.deposit, NULL, CURRENT_DATE, NEW.sale_id);
	RETURN NULL;
	END IF;
END;
$$

CREATE TRIGGER vehicle_returned 
AFTER UPDATE
ON sales
FOR EACH ROW
WHEN (pg_trigger_depth() < 1)
EXECUTE PROCEDURE accounts_receivable_deposit();

select * from vehicles
where vehicle_id = 10

select * from accounts_receivable

CALL sell_vehicle (10);
CALL return_sold_vehicle(10);



