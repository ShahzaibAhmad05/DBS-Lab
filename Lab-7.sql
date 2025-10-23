-- CS220 – Database Systems
-- Lab 07: SQL JOINS
-- Environment: MySQL (Sakila)

-- =========================================================
-- SETUP
-- =========================================================
USE sakila;

-- Clean up practice tables if they already exist
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Course;

-- =========================================================
-- TASK 1: PRACTICE TABLES (Users, Course) + PK/FK
-- =========================================================
CREATE TABLE Course (
  course_id INT PRIMARY KEY,
  name VARCHAR(50) NULL
);

CREATE TABLE Users (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  course_id INT NULL,
  CONSTRAINT fk_users_course
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

-- Seed data (as given in the lab handout)
INSERT INTO Course (course_id, name) VALUES
(1,'HTML5'),
(2,NULL),
(3,'JavaScript'),
(4,'PHP'),
(5,'MySQL');

INSERT INTO Users (id, name, course_id) VALUES
(1,'Alice',1),
(2,'Bob',1),
(3,'Caroline',2),
(4,'David',5),
(5,'Emma',NULL);

-- =========================================================
-- TASK 2: CROSS JOIN (all combinations)
-- =========================================================
SELECT
  u.id AS user_id, u.name AS user_name, u.course_id AS user_course_id,
  c.course_id AS course_id, c.name AS course_name
FROM Users u
CROSS JOIN Course c;

-- =========================================================
-- TASK 3: INNER JOIN
-- “Produce a set of all users who are enrolled in a course.”
-- =========================================================
SELECT
  u.id, u.name AS user_name, u.course_id, c.name AS course_name
FROM Users u
INNER JOIN Course c USING (course_id);

-- =========================================================
-- TASK 4: LEFT OUTER JOIN
-- “List all students and their courses even if they’re not enrolled.”
-- =========================================================
SELECT
  u.id, u.name AS user_name, u.course_id, c.name AS course_name
FROM Users u
LEFT JOIN Course c USING (course_id)
ORDER BY u.id;

-- =========================================================
-- TASK 5: RIGHT OUTER JOIN
-- “All courses with their users (include courses with no users).”
-- =========================================================
SELECT
  c.course_id, c.name AS course_name,
  u.id AS user_id, u.name AS user_name
FROM Users u
RIGHT JOIN Course c USING (course_id)
ORDER BY c.course_id, user_id;

-- =========================================================
-- TASK 6: FULL OUTER JOIN (emulation in MySQL)
-- “All records in both tables regardless of any match.”
-- NOTE: MySQL has no FULL OUTER JOIN; emulate via UNION of LEFT and RIGHT.
-- =========================================================
SELECT
  u.id AS user_id, u.name AS user_name, u.course_id,
  c.name AS course_name
FROM Users u
LEFT JOIN Course c USING (course_id)
UNION
SELECT
  u.id AS user_id, u.name AS user_name, u.course_id,
  c.name AS course_name
FROM Users u
RIGHT JOIN Course c USING (course_id)
ORDER BY user_name IS NULL, user_name, course_name;

-- =========================================================
-- TASK 7: NATURAL JOIN (safe demo via derived table)
-- NATURAL JOIN would match ALL same-named columns, which is risky.
-- We constrain it to only course_id by renaming the course name in a subquery.
-- =========================================================
SELECT
  u.id, u.name AS user_name, u.course_id, d.course_name
FROM Users u
NATURAL JOIN (
  SELECT course_id, name AS course_name
  FROM Course
) AS d
ORDER BY u.id;

-- =========================================================
-- TASK 8: SAKILA – Sample JOINs from the brief
-- =========================================================

-- 8.1 List rental and return date for the movie BREAKING HOME (13 entries expected)
SELECT r.rental_date, r.return_date
FROM rental r
JOIN inventory i USING (inventory_id)
JOIN film f ON f.film_id = i.film_id
WHERE f.title = 'BREAKING HOME';

-- 8.2 List of movie titles that were never rented (expected ~43)
-- (Two LEFT JOINs; movies may be absent from inventory OR never rented)
SELECT f.title
FROM film f
LEFT JOIN inventory i USING (film_id)
LEFT JOIN rental r USING (inventory_id)
WHERE i.inventory_id IS NULL OR r.rental_id IS NULL;

-- =========================================================
-- LAB TASK QUERIES (from the Lab 07 handout)
-- =========================================================

-- TASK 9: What category does the movie CHOCOLATE DUCK belong to?
SELECT c.name AS category
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE f.title = 'CHOCOLATE DUCK';

-- TASK 10: Track the location (city & country) of staff member JON.
SELECT s.first_name, ci.city, co.country
FROM staff s
JOIN address a ON a.address_id = s.address_id
JOIN city ci ON ci.city_id = a.city_id
JOIN country co ON co.country_id = ci.country_id
WHERE s.first_name = 'JON';

-- TASK 11: Retrieve first and last name of actors who played in ALONE TRIP.
SELECT a.first_name, a.last_name, f.title
FROM film f
JOIN film_actor fa ON fa.film_id = f.film_id
JOIN actor a ON a.actor_id = fa.actor_id
WHERE f.title = 'ALONE TRIP';

-- TASK 12: Movies in Games category having rental rate > $4 (sorted by title).
SELECT f.title, f.rental_rate
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c.name = 'Games'
  AND f.rental_rate > 4
ORDER BY f.title;

-- TASK 13: Emails of customers who rented a movie BUT didn’t pay anything (include movie title).
SELECT c.email, f.title
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN payment p ON p.rental_id = r.rental_id
WHERE p.amount = 0;

-- TASK 14: List of unpaid rentals (film title, rental id, rental date, days_rented).
-- Sorted on film title then rental date.
SELECT
  f.title,
  r.rental_id,
  r.rental_date,
  r.return_date,
  DATEDIFF(CURRENT_DATE, r.rental_date) AS days_rented
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN payment p ON p.rental_id = r.rental_id
WHERE p.amount = 0
ORDER BY f.title, r.rental_date;

-- TASK 15: How many films involve the word “Crocodile” and “Shark”?
SELECT
  (SELECT COUNT(*) FROM film WHERE title LIKE '%Crocodile%' OR description LIKE '%Crocodile%') AS crocodile_count,
  (SELECT COUNT(*) FROM film WHERE title LIKE '%Shark%' OR description LIKE '%Shark%') AS shark_count;

-- TASK 16: Retrieve language ids of ENGLISH and FRENCH.
SELECT language_id, name
FROM language
WHERE name IN ('English','French');
