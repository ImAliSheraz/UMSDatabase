--DataBase Creation
CREATE DATABASE ums_db;
USE ums_db;

--1 Staff Roles Table
CREATE TABLE staff_roles(
r_id int NOT NULL PRIMARY KEY,
r_name varchar(20) NOT NULL,
r_minqulification varchar(20) NOT NULL,
r_desc varchar(40) NOT NULL,
r_minage int NOT NULL DEFAULT 18,
r_maxage int NOT NULL DEFAULT 65,
r_maxcount int NOT NULL,
);

--2 Higher Mangement Table
CREATE TABLE Higher_Mag(
hr_id int NOT NULL PRIMARY KEY,
hr_name varchar(20) NOT NULL,
hr_fathername varchar(20) NOT NULL,
hr_cnic varchar(20) NOT NULL,
hr_contact varchar(20) NOT NULL,
hr_email CHAR (25) NOT NULL  CHECK (hr_email LIKE '%@superior.edu.pk' ),
hr_qulification varchar(20)  NOT NULL,
hr_designation int REFERENCES staff_roles(r_id) NOT NULL,
hr_status varchar(20) NOT NULL
);

--3 Campus Table
CREATE TABLE campus(
cam_id int NOT NULL PRIMARY KEY,
cam_name varchar(20) NOT NULL,
cam_location varchar(40) NOT NULL,
cam_head int REFERENCES Higher_Mag(hr_id) NOT NULL,
);

--4 Department Table
CREATE TABLE department(
dep_id int NOT NULL PRIMARY KEY,
dep_name varchar(20) NOT NULL,
dep_programs int NOT NULL,
dep_facultystrenth int NOT NULL,
dep_studentstrenth int NOT NULL,
dep_hod  int REFERENCES Higher_Mag(hr_id) NOT NULL,
dep_campusid int REFERENCES campus(cam_id) NOT NULL,
);

--5 Program Offering Table
CREATE TABLE program_offering(
pro_id int NOT NULL PRIMARY KEY,
pro_name varchar(20) NOT NULL,
pro_dept int REFERENCES department(dep_id) NOT NULL,
pro_semester int NOT NULL,
pro_duration Char(8) NOT NULL,
pro_advisor int REFERENCES Higher_Mag(hr_id) NOT NULL, 
pro_session char(6) NOT NULL,
);

 --6 Faculty Table
CREATE TABLE faculty(
f_id int NOT NULL PRIMARY KEY,
f_fname varchar(20) NOT NULL,
f_lname varchar(20) NOT NULL,
f_fathername varchar(20) NOT NULL,
f_cnic varchar(20) NOT NULL,
f_contact varchar(20) NOT NULL,
f_email   CHAR (25) NOT NULL  CHECK (f_email LIKE '%@superior.edu.pk' ),
f_qulification varchar(20)  NOT NULL,
f_designation int REFERENCES staff_roles(r_id) NOT NULL, 
f_depid int REFERENCES department(dep_id) NOT NULL,
f_status varchar(20) NOT NULL
);

--7 Students Table
CREATE TABLE student(
stu_id int NOT NULL PRIMARY KEY,
stu_fname varchar(20) NOT NULL,
stu_lname varchar(20) NOT NULL,
stu_fathername varchar(20) NOT NULL,
stu_cnic varchar(20) NOT NULL,
stu_contact varchar(20) NOT NULL,
stu_email CHAR (25) NOT NULL  CHECK (stu_email LIKE '%@superior.edu.pk' ),
stu_program int REFERENCES program_offering(pro_id) NOT NULL,
stu_status varchar(20) NOT NULL,
);

--8 Courses Table
CREATE TABLE courses(
cor_id int NOT NULL PRIMARY KEY,
cor_name varchar(20) NOT NULL,
cor_pre varchar(20) ,
cor_follow varchar(20),
cor_session char(6) NOT NULL,
cor_fee int NOT NULL,
cor_instructor int REFERENCES faculty(f_id) NOT NULL,
cor_department int REFERENCES department(dep_id) NOT NULL,
);

--9 Section Table
CREATE TABLE sections(
sec_id int NOT NULL PRIMARY KEY,
sec_name varchar(20) NOT NULL,
sec_session char(6) NOT NULL,
sec_pro int REFERENCES program_offering(pro_id) NOT NULL,
sec_shift char(10) NOT NULL,
sec_maxSru int NOT NULL,
sec_department int REFERENCES department(dep_id) NOT NULL,
);

--10 Lab Table
CREATE TABLE Labs(
lab_id int NOT NULL PRIMARY KEY,
lab_corid int REFERENCES courses(cor_id) NOT NULL,
lab_attendent int REFERENCES faculty(f_id) NOT NULL,
lab_section int REFERENCES sections(sec_id) NOT NULL,
lab_pcstrengh int NOt NULL,
lab_duration char (10) NOt NULL,
lab_day varchar(15) NOT NULL,
lab_location varchar(10) NOT NULL,
);

--11 Course Enrollment Table
CREATE TABLE coruse_enrollment(
enr_id int NOT NULL PRIMARY KEY,
enr_stuid int REFERENCES student(stu_id) NOT NULL,
enr_corid int REFERENCES courses(cor_id) NOT NULL,
enr_repeat char (10) NOt NULL,
enr_status varchar(20) NOT NULL,
enr_sec int REFERENCES sections(sec_id) NOT NULL,
enr_date timestamp NOT NULL,
);

--Diffrent Techniques for Data Retriving.
SELECT * FROM  Labs;
SELECT lab_id FROM  Labs WHERE lab_duration = '90 mint';
SELECT * FROM student ORDER BY stu_fname;
SELECT * FROM student WHERE stu_id > 5 AND stu_program = 2;
SELECT * FROM student WHERE stu_id > 15 OR stu_program = 2;
SELECT f_fname,f_fathername,f_contact,f_email FROM faculty WHERE f_email LIKE '%superior.edu.pk';
SELECT lab_day FROM Labs WHERE lab_corid=2 ;
SELECT stu_id,stu_fname,stu_fathername,stu_contact,stu_email,pro_name AS stu_program
FROM student INNER JOIN program_offering ON student.stu_program=program_offering.pro_id  WHERE stu_lname = 'Ali';
SELECT * FROM staff_roles WHERE r_maxcount > 30;
SELECT * FROM staff_roles ORDER BY r_name DESC;

-- JOIN (Inner,Cross,Outer,Left outer, Right outer)  
--INNER JOIN:
SELECT stu_id,stu_fname,stu_lname,stu_fathername,stu_cnic,stu_contact,stu_email,stu_status,pro_name AS stu_program
FROM student INNER JOIN program_offering ON student.stu_program=program_offering.pro_id  WHERE stu_lname = 'Ali';
--LEFT OUTER JOIN 
SELECT f_fname AS Faculty_FirstName,f_lname AS Faculty_LastName,f_status AS Faculty_Status, dep_name AS Department_Name
FROM faculty LEFT OUTER JOIN department ON faculty.f_depid = department.dep_id ORDER BY dep_name;
--Right OUTER JOIN
SELECT stu_fname AS Student_FirstName,pro_name,pro_dept,pro_semester,pro_duration,pro_advisor,pro_session 
FROM student RIGHT OUTER JOIN program_offering ON student.stu_program = program_offering.pro_id;
--OUTER JOIN
SELECT * FROM student FULL OUTER JOIN program_offering ON student.stu_program = program_offering.pro_id;
--CROSS JOIN
SELECT * FROM student CROSS JOIN program_offering;

--Store Procedures

-- Store Procedure To Get Student Informaation With Id.
CREATE PROCEDURE spGetStudentInfo
@id int
AS
BEGIN
SELECT stu_id,stu_fname,stu_lname,stu_fathername,stu_cnic,stu_contact,stu_email,stu_status,pro_name AS stu_program
FROM student INNER JOIN program_offering ON student.stu_program=program_offering.pro_id  WHERE stu_id = @id;
END
EXECUTE spGetStudentInfo  1;
-- Store Procedure To Get Faculty Informaation With Qulification.
CREATE PROCEDURE spGetFacultyInfo
@qulification nvarchar(20)
AS
BEGIN
SELECT f_id,f_fname,f_lname,f_fathername,f_cnic,f_contact,f_email,f_qulification,f_status,r_name AS f_Designation
FROM faculty INNER JOIN staff_roles ON faculty.f_depid= staff_roles.r_id  WHERE f_qulification = @qulification;
END
EXECUTE spGetFacultyInfo 'PHD';
-- Store Procedure To Get Total Program Offered.
CREATE PROCEDURE spGetProgramCount
AS
BEGIN
RETURN (SELECT COUNT(pro_id) AS Total_Program_Offered FROM program_offering) 
END
DECLARE @TotalProgram int;
EXECUTE @TotalProgram = spGetProgramCount;
PRINT @TotalProgram;

--Views 
-- VIEW for Get Complete Student Data
CREATE VIEW viewStudentTable
AS
SELECT stu_id,stu_fname,stu_lname,stu_fathername,stu_cnic,stu_contact,stu_email,stu_status,pro_name AS stu_program
FROM student INNER JOIN program_offering ON student.stu_program=program_offering.pro_id;
SELECT * FROM viewStudentTable;
-- VIEW for Get Complete Faculty Data
CREATE VIEW viewFacultyTable
AS
SELECT f_id,f_fname,f_lname,f_fathername,f_cnic,f_contact,f_email,f_qulification,f_status,r_name AS f_Designation
FROM faculty INNER JOIN staff_roles ON faculty.f_depid= staff_roles.r_id;
SELECT * FROM viewFacultyTable;
-- VIEW for Get Complete Section Info
CREATE VIEW viewSectionList
AS
SELECT sec_id,sec_name,sec_session,sec_shift,sec_maxSru,pro_name AS sec_program,dep_name AS sec_department From sections s INNER JOIN program_offering p
ON s.sec_pro = p.pro_id JOIN department d ON s.sec_department=d.dep_id;

--Aggregate & Scalar Functions
--Scalar Functions
SELECT UPPER(f_fname) AS Faculty_Name FROM faculty;
SELECT LOWER(f_fname) AS Faculty_Name FROM faculty;
--Aggregrate Functions
SELECT COUNT(pro_id) AS TOTAL_PROGRAMS_OFFERED FROM program_offering;
SELECT MAX(pro_id) AS MAX_ID FROM program_offering;
