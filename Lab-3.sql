USE sakila;

-- Task 1: Select the names of actors whose IDs are between 50 and 150,
-- or whose last name starts with the letter 'A'.
SELECT first_name, last_name 
FROM actor 
WHERE actor_id BETWEEN 50 AND 150 
   OR last_name LIKE 'A%';

-- Task 2: Display the names of customers in the format "LastName, F"
-- where F is the first initial of the first name.
SELECT CONCAT(last_name, ', ', SUBSTRING(first_name, 1, 1)) 
FROM customer;

-- Task 3: Show details of all films released so far,
-- formatted as "Film <title> was released in the year <year>".
SELECT CONCAT('Film ', title, ' was released in the year ', release_year) 
FROM film;

-- Task 4: Display the usernames (email prefix before '@')
-- and their corresponding address IDs from the customer table.
SELECT SUBSTRING_INDEX(email, '@', 1) AS username, address_id 
FROM customer;

-- Task 5: Use of the SUBSTRING function in two examples:
-- (a) Show the first 5 characters of each film title.
-- (b) Show only the first letter of each customer's last name.
SELECT SUBSTRING(title, 1, 5) 
FROM film;

SELECT SUBSTRING(last_name, 1, 1) 
FROM customer;
