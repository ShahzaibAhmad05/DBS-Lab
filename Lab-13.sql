-- DDL For Schema

CREATE SCHEMA IF NOT EXISTS University;
USE University;
CREATE TABLE  IF NOT EXISTS Student
(	snum integer,  sname char(30), major char(25),level char(2), age integer,
PRIMARY KEY (snum)
);
CREATE TABLE  IF NOT EXISTS Faculty
(	fid integer, fname char(30), dept_id integer,
 PRIMARY KEY (fid)
);
CREATE TABLE  IF NOT EXISTS Class
(cname char(40) PRIMARY KEY,
meets_at char(20),room char(10), fid integer,
FOREIGN KEY (fid) REFERENCES Faculty(fid)
);
CREATE TABLE  IF NOT EXISTS Enrolled
(
snum integer,
cname char(40),
FOREIGN KEY (snum) REFERENCES Student(snum), 
FOREIGN KEY (cname) REFERENCES Class(cname)
 );

-- DML for Data Insertion

INSERT INTO STUDENT values (051135593,'Maria White','English','SR',21),
(060839453,'Charles Harris','Architecture','SR',22),(099354543,'Susan Martin','Law','JR',20),
(112348546,'Joseph Thompson','Computer Science','SO',19),(115987938,'Christopher Garcia','Computer Science','JR',20),
(132977562,'Angela Martinez','History','SR',20),
(269734834,'Thomas Robinson','Psychology','SO',18),
(280158572,'Margaret Clark','Animal Science','FR',18),
(301221823,'Juan Rodriguez','Psychology','JR',20),
(318548912,'Dorthy Lewis','Finance','FR',18),
(320874981,'Daniel Lee','Electrical Engineering','FR',17),
(322654189,'Lisa Walker','Computer Science','SO',17),
(348121549,'Paul Hall','Computer Science','JR',18),
(351565322,'Nancy Allen','Accounting','JR',19),
(451519864,'Mark Young','Finance','FR',18),
(455798411,'Luis Hernandez','Electrical Engineering','FR',17),
(462156489,'Donald King','Mechanical Engineering','SO',19),
(550156548,'George Wright','Education','SR',21),
(552455318,'Ana Lopez','Computer Engineering','SR',19),
(556784565,'Kenneth Hill','Civil Engineering','SR',21),
(567354612,'Karen Scott','Computer Engineering','FR',18),
(573284895,'Steven Green','Kinesiology','SO',19),
(574489456,'Betty Adams','Economics','JR',20),
(578875478,'Edward Baker','Veterinary Medicine','SR',21);

INSERT INTO Faculty values(142519864,'Ivana Teach',20),
(242518965,'James Smith',68),
(141582651,'Mary Johnson',20),
(011564812,'John Williams',68),
(254099823,'Patricia Jones',68),
(356187925,'Robert Brown',12),
(489456522,'Linda Davis',20),
(287321212,'Michael Miller',12),
(248965255,'Barbara Wilson',12),
(159542516,'William Moore',33),
(090873519,'Elizabeth Taylor',11),
(486512566,'David Anderson',20),
(619023588,'Jennifer Thomas',11),
(489221823,'Richard Jackson',33),
(548977562,'Ulysses Teach',20);

INSERT INTO Class VALUES('Data Structures','MWF 10','R128',489456522),
('Database Systems','MWF 12:30-1:45','1320 DCL',142519864),
('Operating System Design','TuTh 12-1:20','20 AVW',489456522), 
('Archaeology of the Incas','MWF 3-4:15','R128',248965255);

INSERT INTO Enrolled VALUES (112348546,'Database Systems'),
(115987938,'Database Systems'),
(348121549,'Database Systems'),
(322654189,'Database Systems'),
(552455318,'Database Systems'),
(455798411,'Operating System Design');

-- View v1

CREATE VIEW v1 AS
SELECT f.fname
FROM Faculty AS f
LEFT JOIN Class AS c
       ON f.fid = c.fid
WHERE c.fid IS NULL;

-- View v2

CREATE VIEW v2 AS
SELECT DISTINCT s.sname
FROM Student  AS s
JOIN Enrolled AS e ON s.snum = e.snum
JOIN Class    AS c ON e.cname = c.cname
JOIN Faculty  AS f ON c.fid   = f.fid
WHERE f.fname = 'Ivana Teach';

-- View stdVu

CREATE VIEW stdVu AS
SELECT *
FROM Student;

-- Add course col

ALTER TABLE Student
ADD COLUMN course CHAR(40);

-- ALTER v2

ALTER VIEW v2 AS
SELECT DISTINCT s.sname
FROM Student  AS s
JOIN Enrolled AS e ON s.snum = e.snum
JOIN Class    AS c ON e.cname = c.cname
JOIN Faculty  AS f ON c.fid   = f.fid
WHERE f.fname = 'Ivana Teach'
  AND s.level = 'JR';

-- ADDITIONAL VIEWS

CREATE VIEW cs_students AS
SELECT sname
FROM Student
WHERE major = 'Computer Science';

CREATE VIEW john_68_classes AS
SELECT c.cname
FROM Class   AS c
JOIN Faculty AS f ON c.fid = f.fid
WHERE f.fname   = 'John Williams'
  AND f.dept_id = 68;

CREATE VIEW db_ages AS
SELECT DISTINCT s.age
FROM Student  AS s
JOIN Enrolled AS e ON s.snum = e.snum
WHERE e.cname = 'Database Systems'
ORDER BY s.age DESC;

CREATE VIEW garcia_teachers AS
SELECT DISTINCT f.fname
FROM Faculty AS f
JOIN Class   AS c ON f.fid   = c.fid
JOIN Enrolled AS e ON c.cname = e.cname
JOIN Student  AS s ON e.snum  = s.snum
WHERE s.sname = 'Christopher Garcia';

-- DROPPING YOUR EFFORT INTO THE SEA

DROP VIEW IF EXISTS v1, v2;