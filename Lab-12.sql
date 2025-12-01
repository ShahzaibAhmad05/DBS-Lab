-- DDL --

CREATE Database DHSK;
USE DHSK;

CREATE TABLE Customer (
    customerID INT PRIMARY KEY AUTO_INCREMENT,
    firstName  VARCHAR(50),
    lastName   VARCHAR(50),
    address    VARCHAR(255),
    contactNumber VARCHAR(20)
);

CREATE TABLE Pet (
    petID INT PRIMARY KEY AUTO_INCREMENT,
    name  VARCHAR(50),
    species VARCHAR(50),
    customerID INT,
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);

CREATE TABLE Bill (
    billID INT PRIMARY KEY AUTO_INCREMENT,
    cost   DECIMAL(10,2)
);

CREATE TABLE Medication (
    medicationID INT PRIMARY KEY AUTO_INCREMENT,
    name   VARCHAR(100),
    cost   DECIMAL(10,2),
    dosage VARCHAR(100)
);

CREATE TABLE Treatment (
    treatmentID INT PRIMARY KEY AUTO_INCREMENT,
    petID  INT,
    billID INT,
    name VARCHAR(100),
    timestamp DATETIME,
    FOREIGN KEY (petID) REFERENCES Pet(petID),
    FOREIGN KEY (billID) REFERENCES Bill(billID)
);

CREATE TABLE treatment_med (
    treatmentID  INT,
    medicationID INT,
    PRIMARY KEY (treatmentID, medicationID),
    FOREIGN KEY (treatmentID) REFERENCES Treatment(treatmentID),
    FOREIGN KEY (medicationID) REFERENCES Medication(medicationID)
);

-- DML --

INSERT INTO Customer (firstName, lastName, address, contactNumber) VALUES
('Boss', 'Sir', '12 Oak Street', '555-1111'),
('Bilal', 'Ali', '34 Pine Avenue', '555-2222'),
('Danyal', 'Khalid', '56 Maple Road', '555-3333');

INSERT INTO Pet (name, species, customerID) VALUES
('Bella', 'Dog', 1),
('Luna', 'Cat', 1),
('Max', 'Dog', 2),
('Coco', 'Rabbit', 3),
('Rio', 'Parrot', 3);

INSERT INTO Medication (name, cost, dosage) VALUES
('Amoxicillin', 25.00, '1 pill twice daily'),
('IbuprofenVet', 15.50, '1 pill daily'),
('RabiesVax', 40.00, 'Single dose'),
('DewormX', 18.75, 'Single dose'),
('FleaShield', 22.00, 'Topical monthly'),
('VitaBoost', 10.00, '5 ml daily'),
('ClearEyes', 12.25, '2 drops twice daily');

INSERT INTO Bill (cost) VALUES
(65.00),
(95.50),
(50.00);

INSERT INTO Treatment (petID, billID, name, timestamp)
VALUES 
(1, 1, 'General Checkup', '2022-03-10 10:00:00'),
(3, 2, 'Vaccination Visit', '2024-06-15 14:30:00'),
(2, 3, 'Eye Infection Treatment', '2025-02-20 09:15:00');

INSERT INTO treatment_med (treatmentID, medicationID) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(2, 5),
(3, 6),
(3, 7);

-- DRL --

SELECT 
    b.billID,
    b.cost,
    t.treatmentID,
    t.name      AS treatmentName,
    t.timestamp,
    p.petID,
    p.name      AS petName,
    c.customerID,
    c.firstName,
    c.lastName
FROM Bill b
JOIN Treatment t ON t.billID = b.billID
JOIN Pet p       ON t.petID  = p.petID
JOIN Customer c  ON p.customerID = c.customerID
WHERE t.timestamp = (SELECT MIN(timestamp) FROM Treatment);

SELECT 
    b.billID,
    b.cost,
    t.treatmentID,
    t.name      AS treatmentName,
    t.timestamp,
    p.petID,
    p.name      AS petName,
    c.customerID,
    c.firstName,
    c.lastName
FROM Bill b
JOIN Treatment t ON t.billID = b.billID
JOIN Pet p       ON t.petID  = p.petID
JOIN Customer c  ON p.customerID = c.customerID
WHERE t.timestamp = (SELECT MAX(timestamp) FROM Treatment);

SELECT 
    b.billID,
    b.cost,
    t.treatmentID,
    t.name      AS treatmentName,
    t.timestamp,
    p.petID,
    p.name      AS petName,
    c.customerID,
    c.firstName,
    c.lastName
FROM Bill b
JOIN Treatment t ON t.billID = b.billID
JOIN Pet p       ON t.petID  = p.petID
JOIN Customer c  ON p.customerID = c.customerID
WHERE b.cost = (SELECT MAX(cost) FROM Bill);

SELECT 
    p.petID,
    p.name AS petName,
    COUNT(DISTINCT t.treatmentID) AS numTreatments,
    GROUP_CONCAT(DISTINCT t.name ORDER BY t.timestamp) AS treatmentNames
FROM Pet p
JOIN Treatment t ON t.petID = p.petID
GROUP BY p.petID
ORDER BY numTreatments DESC
LIMIT 1;
