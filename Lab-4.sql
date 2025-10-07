-- Reference for Database creation:
-- https://justinsomnia.org/2009/04/the-emp-and-dept-tables-for-mysql/

-- Task: Highest, lowest, sum, and average salary across all employees
SELECT
  MAX(sal) AS Maximum,
  MIN(sal) AS Minimum,
  SUM(sal) AS Sum,
  AVG(sal) AS Average
FROM emp;

-- Task: Highest, lowest, sum, and average salary per job
SELECT
  job,
  MAX(sal) AS Maximum,
  MIN(sal) AS Minimum,
  SUM(sal) AS Sum,
  AVG(sal) AS Average
FROM emp
GROUP BY job;

-- Task: Number of employees in each job, sorted from most to fewest
SELECT
  job,
  COUNT(*) AS num_employees
FROM emp
GROUP BY job
ORDER BY num_employees DESC;

-- Task: Count of distinct departments referenced by employees
SELECT COUNT(DISTINCT deptno) AS distinct_departments
FROM emp;

-- Task: Number of distinct managers (excluding NULL manager entries)
SELECT COUNT(DISTINCT mgr) AS number_of_managers
FROM emp
WHERE mgr IS NOT NULL;

-- Task: Difference between the highest and lowest salaries
SELECT MAX(sal) - MIN(sal) AS salary_difference
FROM emp;

-- Task: For each manager, lowest-paid employee’s salary; exclude groups with min <= 4000; sort high→low
SELECT
  mgr,
  MIN(sal) AS lowest_salary
FROM emp
GROUP BY mgr
HAVING MIN(sal) > 4000
ORDER BY lowest_salary DESC;

-- Task: List department names with their locations
SELECT dname, loc
FROM dept;

-- Task: Total number of employees in the company
SELECT COUNT(*) AS total_employees
FROM emp;
