--                       HOMEWORK
-- 1. EXTRA CREDIT: Create a procedure that adds a late fee to any 
-- customer who returned their rental after 7 days.
-- Use the payment and rental tables. Create a stored function 
-- that you call inside your procedure. 
-- The function will calculate the late fee amount based on 
-- how many days late they returned their rental. 
-- (Hint* You can subtract  two dates from each other and use Intervals 
--  to compare those dates, linked below).

-- 2. Add a new column in the customer table for Platinum Member. 
-- This can be a boolean.
-- Platinum Members are any customers who have spent over $200. 
-- Create a procedure that updates the Platinum Member column to 
-- True for any customer who has spent over $200 and False for any 
-- customer who has spent less than $200.
-- Use the payment and customer table.



-- 2. 
SELECT *
FROM customer

SELECT *
FROM payment

ALTER TABLE customer
ADD COLUMN platinum_member BOOLEAN;

CREATE OR REPLACE PROCEDURE platinum_member()
LANGUAGE plpgsql
AS $$
	BEGIN
		UPDATE customer
		SET platinum_member = TRUE
		WHERE customer_id IN (
			SELECT customer_id
			FROM payment
			GROUP BY customer_id
			HAVING SUM(amount) > 200
		);

		UPDATE customer
		SET platinum_member = FALSE
		WHERE customer_id IN (
			SELECT customer_id
			FROM payment
			GROUP BY customer_id
			HAVING SUM(amount) <= 200
		);
	
	END;
$$;

CALL platinum_member();

SELECT *
FROM customer


-- 1.

SELECT *
FROM payment

SELECT *
FROM rental

ALTER TABLE payment
ADD COLUMN late_fee VARCHAR(50);

CREATE OR REPLACE PROCEDURE late_fee()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE payment
	SET late_fee = 'yes'
	WHERE customer_id IN (
	SELECT customer_id
	FROM rental
	WHERE return_date - rental_date > INTERVAL '7 Days'

);
	COMMIT;
END;
$$;

CALL late_fee()

SELECT *
FROM payment
WHERE customer_id = 408;



	







