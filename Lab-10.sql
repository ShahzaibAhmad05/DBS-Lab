-- CS220 – Database Systems
-- Lab 10: Correlated Nested Queries in SQL
-- Environment: MySQL

-- =========================================================
-- SETUP
-- =========================================================

-- Use the database that contains Student/Faculty/Class/Enrolled
-- USE your_database_name_here;

-- If age column is not already present in Student, run this:
ALTER TABLE Student
  ADD COLUMN age INT;

-- Verify tables
SELECT * FROM Student;
SELECT * FROM Faculty;
SELECT * FROM Class;
SELECT * FROM Enrolled;

-- =========================================================
-- TASK 1
-- "Find the name of faculty members who do not teach any course."
-- =========================================================

SELECT f.fname
FROM Faculty AS f
WHERE f.fid NOT IN (
  SELECT c.fid
  FROM Class AS c
);

-- =========================================================
-- TASK 2
-- "Find the names of faculty members that have taught classes only in room R128."
-- =========================================================

SELECT f.fname
FROM Faculty AS f
WHERE f.fid IN (
  SELECT c.fid
  FROM Class AS c
  WHERE c.room = 'R128'
)
AND f.fid NOT IN (
  SELECT c.fid
  FROM Class AS c
  WHERE c.room <> 'R128'
);

-- =========================================================
-- TASK 3
-- "Retrieve the snum and sname of students who have taken classes
--  from both 'Ivana Teach' and 'Linda Davis'."
-- =========================================================

SELECT s.snum, s.sname
FROM Student AS s
WHERE s.snum IN (
  SELECT e.snum
  FROM Enrolled AS e
  JOIN Class   AS c ON e.cname = c.cname
  JOIN Faculty AS f ON c.fid   = f.fid
  WHERE f.fname = 'Ivana Teach'
)
AND s.snum IN (
  SELECT e.snum
  FROM Enrolled AS e
  JOIN Class   AS c ON e.cname = c.cname
  JOIN Faculty AS f ON c.fid   = f.fid
  WHERE f.fname = 'Linda Davis'
);

-- =========================================================
-- TASK 4
-- "Find the age of the oldest student(s) who is enrolled in a course
--  taught by Ivana Teach."
-- =========================================================

SELECT MAX(s.age) AS oldest_age
FROM Student AS s
JOIN Enrolled AS e ON s.snum  = e.snum
JOIN Class    AS c ON e.cname = c.cname
JOIN Faculty  AS f ON c.fid   = f.fid
WHERE f.fname = 'Ivana Teach';

-- =========================================================
-- TASK 5
-- "Find the name of faculty members that do not teach to class 'database systems'."
-- =========================================================

SELECT f.fname
FROM Faculty AS f
WHERE f.fid NOT IN (
  SELECT c.fid
  FROM Class AS c
  WHERE c.cname = 'database systems'
);

-- =========================================================
-- TASK 6
-- "Find the name of faculty member, department who has taught the
--  maximum number of distinct classes."
-- =========================================================

SELECT f.fname, f.deptid
FROM Faculty AS f
WHERE f.fid = (
  SELECT c.fid
  FROM Class AS c
  GROUP BY c.fid
  ORDER BY COUNT(DISTINCT c.cname) DESC
  LIMIT 1
);

-- =========================================================
-- TASK 7
-- "Find the names of all classes and their enrollment strength
--  that have enrollment greater than 5."
-- =========================================================

SELECT e.cname,
       COUNT(e.snum) AS enrollment_count
FROM Enrolled AS e
GROUP BY e.cname
HAVING COUNT(e.snum) > 5;

-- =========================================================
-- TASK 8
-- "Find the names of all students who are enrolled in two classes
--  that meet at the same time."
-- =========================================================

SELECT DISTINCT s.sname
FROM Student  AS s
JOIN Enrolled AS e1 ON s.snum = e1.snum
JOIN Enrolled AS e2 ON s.snum = e2.snum
                   AND e1.cname < e2.cname
JOIN Class    AS c1 ON e1.cname = c1.cname
JOIN Class    AS c2 ON e2.cname = c2.cname
WHERE c1.meets_at = c2.meets_at;
