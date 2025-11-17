-- CS220 – Database Systems
-- Lab 09: SQL Queries (Subqueries)
-- Environment: MySQL (Sakila)

-- =========================================================
-- SETUP
-- =========================================================
USE sakila;

-- =========================================================
-- TASK 1
-- Number of customers who never rented BREAKING HOME.
-- =========================================================

SELECT COUNT(*) AS never_rented_breaking_home
FROM customer c
WHERE c.customer_id NOT IN (
  SELECT r.customer_id
  FROM rental r
  WHERE r.inventory_id IN (
    SELECT i.inventory_id
    FROM inventory i
    WHERE i.film_id = (
      SELECT f.film_id
      FROM film f
      WHERE f.title = 'BREAKING HOME'
    )
  )
);

-- =========================================================
-- TASK 2
-- List accumulative replacement cost of the movies
-- that were never rented.
-- =========================================================

SELECT SUM(f.replacement_cost) AS total_replacement_cost_never_rented
FROM film f
WHERE f.film_id NOT IN (
  SELECT i.film_id
  FROM inventory i
  WHERE i.inventory_id IN (
    SELECT r.inventory_id
    FROM rental r
  )
);

-- =========================================================
-- TASK 3
-- Find customers who are associated to City 'Abu Dhabi' or 'Aden'.
-- =========================================================

SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
WHERE c.address_id IN (
  SELECT a.address_id
  FROM address a
  WHERE a.city_id IN (
    SELECT ci.city_id
    FROM city ci
    WHERE ci.city IN ('Abu Dhabi', 'Aden')
  )
);

-- =========================================================
-- TASK 4
-- What category does the movie 'COMA HEAD' belong to?
-- =========================================================

SELECT c.name AS category_name
FROM category c
WHERE c.category_id IN (
  SELECT fc.category_id
  FROM film_category fc
  WHERE fc.film_id = (
    SELECT f.film_id
    FROM film f
    WHERE f.title = 'COMA HEAD'
  )
);

-- =========================================================
-- TASK 5
-- Find the movies whose rental duration is less than
-- the rental duration of movie 'AFRICAN EGG'.
-- =========================================================

SELECT film_id, title, rental_duration
FROM film
WHERE rental_duration < (
  SELECT rental_duration
  FROM film
  WHERE title = 'AFRICAN EGG'
);

-- =========================================================
-- TASK 6
-- Find those films whose category id is greater than
-- every category id of available films.
-- ("Available films" = films present in INVENTORY.)
-- =========================================================

SELECT f.film_id, f.title
FROM film f
WHERE (
  SELECT fc.category_id
  FROM film_category fc
  WHERE fc.film_id = f.film_id
) > (
  SELECT MAX(fc2.category_id)
  FROM film_category fc2
  WHERE fc2.film_id IN (
    SELECT i.film_id
    FROM inventory i
  )
)
ORDER BY f.title;
