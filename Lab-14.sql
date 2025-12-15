-- DDL for Schema

CREATE DATABASE simple;

USE simple;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    action_type VARCHAR(20),
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks VARCHAR(200)
);

-- TASK 1

DELIMITER //

CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 30000 THEN
        SET NEW.salary = 30000;
    END IF;
END //

DELIMITER ;

INSERT INTO employees (emp_name, salary)
VALUES ('Ali', 20000);

SELECT * from employees;

-- TASK 2

DELIMITER //

CREATE TRIGGER after_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (action_type, emp_id, new_salary, remarks)
    VALUES ('INSERT', NEW.emp_id, NEW.salary, 'New employee added');
END //

DELIMITER ;

INSERT INTO employees (emp_name, salary)
VALUES ('Sara', 45000);

SELECT * FROM audit_log;

-- TASK 3

DELIMITER //

CREATE TRIGGER before_employee_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < OLD.salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be decreased!';
    END IF;
END //

DELIMITER ;

UPDATE employees 
SET salary = 25000
WHERE emp_id = 1;

-- TASK 4

DELIMITER //

CREATE TRIGGER after_employee_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (action_type, emp_id, old_salary, new_salary, remarks)
    VALUES ('UPDATE', NEW.emp_id, OLD.salary, NEW.salary, 'Salary updated');
END //

DELIMITER ;

UPDATE employees 
SET salary = 60000
WHERE emp_id = 2;

SELECT * FROM audit_log;
SELECT * FROM employees;

-- TASK 5

DELIMITER //

CREATE TRIGGER before_employee_delete
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary > 100000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'High-salary employees cannot be deleted!';
    END IF;
END //

DELIMITER ;

DELETE FROM employees WHERE emp_id = 5;

-- TASK 6

DELIMITER //

CREATE TRIGGER after_employee_delete
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (action_type, emp_id, old_salary, remarks)
    VALUES ('DELETE', OLD.emp_id, OLD.salary, 'Employee record deleted');
END //

DELIMITER ;

DELETE FROM employees WHERE emp_id = 2;
SELECT * FROM audit_log;

-- TASK 7

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50),
    amount DECIMAL(10,2)
);


CREATE TABLE order_audit (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    old_amount DECIMAL(10,2),
    new_amount DECIMAL(10,2),
    difference DECIMAL(10,2),
    remark VARCHAR(100),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //

CREATE TRIGGER trg_update_order
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    -- Declaring variables
    DECLARE v_old_amount DECIMAL(10,2);
    DECLARE v_new_amount DECIMAL(10,2);
    DECLARE v_diff DECIMAL(10,2);

    -- Assigning values to variables
    SET v_old_amount = OLD.amount;
    SET v_new_amount = NEW.amount;

    -- Calculate the change difference
    SET v_diff = v_new_amount - v_old_amount;

    -- Insert into audit table using variables
    INSERT INTO order_audit (order_id, old_amount, new_amount, difference, remark)
    VALUES (NEW.order_id, v_old_amount, v_new_amount, v_diff, 'Order amount updated');
END //

DELIMITER ;

INSERT INTO orders (customer_name, amount)
VALUES ('Bilal', 5000);

UPDATE orders
SET amount = 6500
WHERE order_id = 1;

SELECT * FROM order_audit;
SELECT * FROM orders;

