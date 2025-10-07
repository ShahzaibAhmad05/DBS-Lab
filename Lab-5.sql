CREATE DATABASE University;
USE University;

CREATE TABLE Student (
    snum INT,
    sname CHAR(30) NOT NULL,
    major CHAR(25),
    level CHAR(2),
    CONSTRAINT pk_student_snum PRIMARY KEY (snum)
);

CREATE TABLE Faculty (
    fid INT,
    fname CHAR(30),
    deptid INT,
    CONSTRAINT pk_faculty_fid PRIMARY KEY (fid),
    CONSTRAINT uq_faculty_deptid UNIQUE (deptid)
);

CREATE TABLE Class (
    cname CHAR(40),
    meets_at CHAR(20),
    room CHAR(10),
    fid INT,
    CONSTRAINT pk_class_cname PRIMARY KEY (cname),
    CONSTRAINT fk_class_fid FOREIGN KEY (fid) REFERENCES Faculty(fid)
);

CREATE TABLE Enrolled (
    snum INT,
    cname CHAR(40),
    CONSTRAINT pk_enrolled_snum_cname PRIMARY KEY (snum, cname),
    CONSTRAINT fk_enrolled_snum FOREIGN KEY (snum) REFERENCES Student(snum),
    CONSTRAINT fk_enrolled_cname FOREIGN KEY (cname) REFERENCES Class(cname)
);

DESCRIBE Student;
DESCRIBE Faculty;
DESCRIBE Class;
DESCRIBE Enrolled;
