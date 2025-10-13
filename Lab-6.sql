USE university;

INSERT INTO Faculty (fid, fname, deptid) VALUES
(142519864,'Ivana Teach',20),
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

INSERT INTO Class (cname, meets_at, room, fid) VALUES
('Data Structures','MWF 10','R128',489456522),
('Database Systems','MWF 12:30-1:45','1320 DCL',142519864),
('Operating System Design','TuTh 12-1:20','20 AVW',489456522),
('Archaeology of the Incas','MWF 3-4:15','R128',248965255),
('Aviation Accident Investigation','TuTh 1-2:50','Q3',011564812),
('Air Quality Engineering','TuTh 10:30-11:45','R15',011564812),
('Introductory Latin','MWF 3-4:15','R12',248965255),
('American Political Parties','TuTh 2-3:15','20 AVW',619023588),
('Social Cognition','Tu 6:30-8:40','R15',159542516),
('Perception','MTuWTh 3','Q3',489221823),
('Multivariate Analysis','TuTh 2-3:15','R15',090873519),
('Patent Law','F 1-2:50','R128',090873519),
('Urban Economics','MWF 11','20 AVW',489221823),
('Organic Chemistry','TuTh 12:30-1:45','R12',489221823),
('Marketing Research','MW 10-11:15','1320 DCL',489221823),
('Seminar in American Art','M 4','R15',489221823),
('Orbital Mechanics','MWF 8','1320 DCL',011564812),
('Dairy Herd Management','TuTh 12:30-1:45','R128',356187925),
('Communication Networks','MW 9:30-10:45','20 AVW',141582651),
('Optical Electronics','TuTh 12:30-1:45','R15',254099823),
('Intoduction to Math','TuTh 8-9:30','R128',489221823);

INSERT INTO Student (snum, sname, major, level) VALUES
(051135593,'Maria White','English','SR'),
(060839453,'Charles Harris','Architecture','SR'),
(099354543,'Susan Martin','Law','JR'),
(112348546,'Joseph Thompson','Computer Science','SO'),
(115987938,'Christopher Garcia','Computer Science','JR'),
(132977562,'Angela Martinez','History','SR'),
(269734834,'Thomas Robinson','Psychology','SO'),
(280158572,'Margaret Clark','Animal Science','FR'),
(301221823,'Juan Rodriguez','Psychology','JR'),
(318548912,'Dorthy Lewis','Finance','FR'),
(320874981,'Daniel Lee','Electrical Engineering','FR'),
(322654189,'Lisa Walker','Computer Science','SO'),
(348121549,'Paul Hall','Computer Science','JR'),
(351565322,'Nancy Allen','Accounting','JR'),
(451519864,'Mark Young','Finance','FR'),
(455798411,'Luis Hernandez','Electrical Engineering','FR'),
(462156489,'Donald King','Mechanical Engineering','SO'),
(550156548,'George Wright','Education','SR'),
(552455318,'Ana Lopez','Computer Engineering','SR'),
(556784565,'Kenneth Hill','Civil Engineering','SR'),
(567354612,'Karen Scott','Computer Engineering','FR'),
(573284895,'Steven Green','Kinesiology','SO'),
(574489456,'Betty Adams','Economics','JR'),
(578875478,'Edward Baker','Veterinary Medicine','SR');

INSERT INTO Enrolled (snum, cname) VALUES
(112348546,'Database Systems'),
(115987938,'Database Systems'),
(348121549,'Database Systems'),
(322654189,'Database Systems'),
(552455318,'Database Systems'),
(455798411,'Operating System Design'),
(552455318,'Operating System Design'),
(567354612,'Operating System Design'),
(112348546,'Operating System Design'),
(115987938,'Operating System Design'),
(322654189,'Operating System Design'),
(567354612,'Data Structures'),
(552455318,'Communication Networks'),
(455798411,'Optical Electronics'),
(301221823,'Perception'),
(301221823,'Social Cognition'),
(301221823,'American Political Parties'),
(556784565,'Air Quality Engineering'),
(099354543,'Patent Law'),
(574489456,'Urban Economics');

-- TASK 2

ALTER TABLE Enrolled DROP FOREIGN KEY fk_enrolled_snum;
ALTER TABLE Enrolled DROP FOREIGN KEY fk_enrolled_cname;

-- TASK 3

-- Drop current primary key (composite)
ALTER TABLE Enrolled DROP PRIMARY KEY;

-- Add surrogate PK and make columns nullable
ALTER TABLE Enrolled
  ADD COLUMN id INT NOT NULL AUTO_INCREMENT FIRST,
  ADD PRIMARY KEY (id),
  MODIFY COLUMN snum INT NULL,
  MODIFY COLUMN cname CHAR(40) NULL;

-- Recreate foreign keys with SET NULL / CASCADE
ALTER TABLE Enrolled
  ADD CONSTRAINT fk_enrolled_snum
    FOREIGN KEY (snum) REFERENCES Student(snum)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE Enrolled
  ADD CONSTRAINT fk_enrolled_cname
    FOREIGN KEY (cname) REFERENCES Class(cname)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- TASK 4

UPDATE Class
SET cname = 'Operating Systems'
WHERE cname = 'Operating System Design';

-- TASK 5


SELECT 
    ROW_NUMBER() OVER () AS row_num, id, snum, cname
FROM Enrolled
WHERE cname = 'Operating System Design';


SELECT * 
FROM Enrolled
WHERE cname = 'Operating System Design';

-- TASK 6

SELECT ROW_NUMBER() OVER () AS row_num, id, snum, cname
FROM Enrolled
WHERE cname = 'Enrolled';

SELECT *
FROM Enrolled
WHERE cname = 'Enrolled';


-- TASK 7

DELETE FROM Class
WHERE cname = 'Patent Law';

-- TASK 8

SELECT ROW_NUMBER () OVER () AS row_num, id, snum, cname
FROM Enrolled
WHERE cname = 'Patent Law';

SELECT * 
FROM Enrolled
WHERE cname = 'Patent Law';


-- TASK 9

SHOW CREATE TABLE Enrolled;

SELECT * FROM information_schema.table_constraints
WHERE TABLE_NAME = 'Enrolled';

ALTER TABLE Enrolled DROP FOREIGN KEY fk_enrolled_snum;

ALTER TABLE Enrolled
  ADD CONSTRAINT fk_enrolled_snum
    FOREIGN KEY (snum) REFERENCES Student(snum)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;


-- TASK 10

SELECT ROW_NUMBER () OVER () AS row_num, snum, sname, major, level
FROM Student
WHERE level = 'JR';

SELECT *
FROM Student
WHERE level = 'JR';


-- TASK 11

ALTER TABLE Enrolled DROP FOREIGN KEY fk_enrolled_snum;

ALTER TABLE Enrolled
  ADD CONSTRAINT fk_enrolled_snum
    FOREIGN KEY (snum) REFERENCES Student(snum)
    ON DELETE NO ACTION
    ON UPDATE CASCADE;
