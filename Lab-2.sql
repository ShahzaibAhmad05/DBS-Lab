USE sakila;

-- Task 1: Select the actor_id from the 'actor' table
-- where the actor_id equals 58.
SELECT actor_id 
FROM actor 
WHERE actor_id = 58;

-- Task 2: Retrieve titles of movies that start with the letter 'P'.
SELECT title 
FROM film 
WHERE title LIKE 'P%';

-- Task 3: Retrieve all movies released in the year 2006.
SELECT * 
FROM film 
WHERE release_year = 2006;

-- Task 4: Find the password assigned to the user 'MIKE'.
SELECT password 
FROM staff 
WHERE username = 'MIKE';

-- Task 5: Retrieve all actors whose first names do NOT end with 'T'.
SELECT * 
FROM actor 
WHERE first_name NOT LIKE '%T';

-- Task 6: Find all payments made in August 2005 and sort them in descending order.
SELECT * 
FROM payment 
WHERE payment_date LIKE '2005-08%' 
ORDER BY payment_date DESC;

-- Task 7: Display actor first names that start with 'A' and end with 'A'.
SELECT first_name 
FROM actor 
WHERE first_name LIKE 'A%A';

-- Task 8: Display languages that are neither English nor French.
SELECT * 
FROM language 
WHERE name NOT LIKE 'English' 
  AND name NOT LIKE 'French';
