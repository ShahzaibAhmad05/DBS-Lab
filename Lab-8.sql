-- CS220 – Database Systems
-- Lab 08: Data Modeling Using the Entity-Relationship (ER) Model
-- Environment: MySQL

-- =========================================================
-- PART 1: L & M PET GROOMING – ERD IMPLEMENTATION (DDL)
-- (Optional physical schema for the ER model)
-- =========================================================

-- Create and select database for the grooming system
DROP DATABASE IF EXISTS lm_pet_grooming;
CREATE DATABASE lm_pet_grooming;
USE lm_pet_grooming;

-- -------------------------
-- OWNER
-- -------------------------
CREATE TABLE Owner (
  owner_id   INT PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  phone      VARCHAR(20)  NOT NULL
);

-- -------------------------
-- PET
-- Each pet belongs to exactly one owner.
-- Gender codes: M (male), F (female), N (neutered), S (spayed)
-- -------------------------
CREATE TABLE Pet (
  pet_id   INT PRIMARY KEY,
  name     VARCHAR(100) NOT NULL,
  gender   ENUM('M','F','N','S') NOT NULL,
  age      INT,
  owner_id INT NOT NULL,
  CONSTRAINT fk_pet_owner
    FOREIGN KEY (owner_id)
    REFERENCES Owner(owner_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- -------------------------
-- EMPLOYEE
-- -------------------------
CREATE TABLE Employee (
  employee_id INT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL
);

-- -------------------------
-- SERVICE
-- -------------------------
CREATE TABLE Service (
  service_id  INT PRIMARY KEY,
  description VARCHAR(255) NOT NULL,
  fee         DECIMAL(8,2) NOT NULL
);

-- -------------------------
-- APPOINTMENT
-- Each appointment ties together one Pet, one Service, one Employee,
-- plus time and duration.
-- -------------------------
CREATE TABLE Appointment (
  appointment_id   INT PRIMARY KEY,
  pet_id           INT NOT NULL,
  employee_id      INT NOT NULL,
  service_id       INT NOT NULL,
  start_timestamp  DATETIME NOT NULL,
  duration_minutes INT NOT NULL,
  CONSTRAINT fk_appt_pet
    FOREIGN KEY (pet_id)
    REFERENCES Pet(pet_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_appt_employee
    FOREIGN KEY (employee_id)
    REFERENCES Employee(employee_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_appt_service
    FOREIGN KEY (service_id)
    REFERENCES Service(service_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- (Optional) sample data for testing
-- INSERT INTO Owner VALUES (1,'Ali','0300-0000000'), (2,'Sara','0301-1111111');
-- INSERT INTO Pet   VALUES (1,'Tommy','M',3,1), (2,'Kitty','F',2,1), (3,'Bruno','N',4,2);
-- INSERT INTO Employee VALUES (1,'Ahmed'), (2,'Zainab');
-- INSERT INTO Service VALUES (1,'Shampoo',1500.00), (2,'Flea Treatment',2200.00), (3,'Haircut',1800.00);
-- INSERT INTO Appointment VALUES
--   (1,1,1,1,'2025-10-27 10:00:00',20),
--   (2,1,1,3,'2025-10-27 10:20:00',30),
--   (3,2,2,2,'2025-10-28 11:00:00',25);


-- =========================================================
-- PART 2: ADDITIONAL LAB TASK – STUDENT / SUBJECT / SEMESTER / MARKS
-- =========================================================

-- Create and select database for the marks schema
DROP DATABASE IF EXISTS lab08;
CREATE DATABASE lab08;
USE lab08;

-- -------------------------
-- STUDENT
-- -------------------------
CREATE TABLE student (
  id   INT PRIMARY KEY,
  name VARCHAR(100)
);

-- -------------------------
-- SUBJECT
-- -------------------------
CREATE TABLE subject (
  id    INT PRIMARY KEY,
  title VARCHAR(100)
);

-- -------------------------
-- SEMESTER
-- -------------------------
CREATE TABLE semester (
  id   INT PRIMARY KEY,
  name VARCHAR(50)
);

-- -------------------------
-- MARKS
-- Composite primary key: (student_id, subject_id, semester_id)
-- All three columns are foreign keys.
-- -------------------------
CREATE TABLE marks (
  student_id  INT,
  subject_id  INT,
  semester_id INT,
  marks       INT,
  PRIMARY KEY (student_id, subject_id, semester_id),
  CONSTRAINT fk_marks_student
    FOREIGN KEY (student_id) REFERENCES student(id),
  CONSTRAINT fk_marks_subject
    FOREIGN KEY (subject_id) REFERENCES subject(id),
  CONSTRAINT fk_marks_semester
    FOREIGN KEY (semester_id) REFERENCES semester(id)
);

-- =========================================================
-- INSERTING SAMPLE DATA (DML)
-- =========================================================

INSERT INTO student (id, name) VALUES
  (1, 'Ali'),
  (2, 'Boss'),
  (3, 'Bilal'),
  (4, 'Aryan'),
  (5, 'Shehroz');

INSERT INTO subject (id, title) VALUES
  (1, 'Math'),
  (2, 'Physics'),
  (3, 'Chemistry');

INSERT INTO semester (id, name) VALUES
  (1, 'S25'),
  (2, 'F25');

INSERT INTO marks (student_id, subject_id, semester_id, marks) VALUES
  (1, 1, 1, 85),
  (1, 2, 1, 78),
  (2, 1, 1, 90),
  (3, 3, 2, 66),
  (4, 2, 2, 73);

-- =========================================================
-- CONSTRAINT CHECKING (EXPECTED: ALL SHOULD FAIL)
-- =========================================================

-- 1) Non-existent student_id
-- INSERT INTO marks VALUES (9, 1, 1, 75);

-- 2) Non-existent subject_id
-- INSERT INTO marks VALUES (1, 9, 1, 88);

-- 3) Duplicate composite key
-- INSERT INTO marks VALUES (1, 1, 1, 90);

-- =========================================================
-- VIEW MARKS TABLE (AFTER VALID INSERTS ONLY)
-- =========================================================

SELECT * FROM marks;
