--to create db
CREATE DATABASE company_db1;

--to transfer usage to the current db
USE company_db1;

/*
The tables were created without foreign key
to avoid the circular dependency problem 
==(each fk dependent on pk must his table created before)
*/

--create table employee and the columns in table
CREATE TABLE employee(
	id INT PRIMARY KEY,
	gender CHAR(1) CHECK (gender = 'M' OR gender = 'F') NOT NULL,
	[address] VARCHAR(50),
	date_of_birth DATE,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	department_no INT,
	date_of_join DATE, -- date of join on our company
	super_id INT
);

--create table dependent 
-- dependent mean people dependent on the employee
CREATE TABLE [dependent](
	emp_id INT NOT NULL,
	[name] VARCHAR(50)NOT NULL,
	relationship VARCHAR(50),
	gender VARCHAR(1),
	PRIMARY KEY(emp_id,[name])
);

--create table department and the columns in table
CREATE TABLE department(
	department_number INT PRIMARY KEY,
	[name] VARCHAR(40) NOT NULL,
	[location] VARCHAR(50),
	manager_id INT, --manager is essentially an employee whose data is in the table employee
	since DATE -- since = the time when the employee caught the department manager
);

--create table project 
-- project table mean --> storing project data in terms of each employee working on it and in which department
CREATE TABLE project(
	project_number INT PRIMARY KEY,
	[name] VARCHAR(50) NOT NULL,
	[location] VARCHAR(50),
	department_no INT
);

--create table employee_project
CREATE TABLE employee_project(
	project_no INT,
	employee_id INT,
	[hours] DECIMAL(5,2) --hours mean the total hour working in project
	PRIMARY KEY (project_no,employee_id) -- because relation is many to many
);

/*
to add relation between tables 
because it is refrential integrity
*/
ALTER TABLE employee
ADD CONSTRAINT FK_employee_department FOREIGN KEY (department_no) REFERENCES department(department_number),
    CONSTRAINT FK_employee_supervision FOREIGN KEY (super_id) REFERENCES employee(id);

ALTER TABLE employee
ADD CONSTRAINT CHK_JoinDate_After_Birth CHECK (date_of_join > date_of_birth);

ALTER TABLE department
ADD CONSTRAINT FK_department_employee FOREIGN KEY (manager_id) REFERENCES employee(id);

ALTER TABLE employee_project
ADD CONSTRAINT FK_employee_project FOREIGN KEY (employee_id) REFERENCES employee(id),
    CONSTRAINT FK_ep_project FOREIGN KEY (project_no) REFERENCES project(project_number);

ALTER TABLE project 
ADD CONSTRAINT FK_project_department FOREIGN KEY (department_no) REFERENCES department(department_number);

ALTER TABLE dependent
ADD CONSTRAINT FK_dependent_employee FOREIGN KEY (emp_id) REFERENCES employee(id);

ALTER TABLE employee_project
ADD CONSTRAINT CHK_Hours_Positive CHECK ([hours] >= 0);





/*
to insert data into tables
*/
-----start begin department
INSERT INTO department (department_number, [name], [location])
VALUES 
(1, 'AI & Data Science', 'Kafrelsheikh'),
(2, 'Software Development', 'Mansoura'),
(3, 'Cyber Security', 'Alexandria'),
(4, 'Business Intelligence', 'Cairo'),
(5, 'Human Resources', 'Main Building');
----data into employee
INSERT INTO employee (id, first_name, last_name, gender, [address], date_of_birth, department_no, date_of_join, super_id)
VALUES

(1000, 'Yossef', 'Haytham', 'M', 'Cairo', '1980-05-14', 5, '2015-01-01', NULL),


(1, 'Ahmed', 'Kamal', 'M', 'Kafrelsheikh', '2003-01-01', 1, '2023-10-01', 1000),
(2, 'Mona', 'Ali', 'F', 'Mansoura', '1995-03-12', 2, '2018-05-20', 1000),
(3, 'Omar', 'Tarek', 'M', 'Alexandria', '1992-11-25', 3, '2017-08-15', 1000),
(4, 'Salma', 'Nabil', 'F', 'Cairo', '1996-07-08', 4, '2020-02-10', 1000),


(5, 'Hassan', 'Fathy', 'M', 'Tanta', '1999-09-30', 1, '2025-01-05', 1), 
(6, 'Nada', 'Sameh', 'F', 'Mansoura', '2000-04-18', 2, '2024-11-01', 2),
(7, 'Kareem', 'Shawky', 'M', 'Alexandria', '1998-12-05', 3, '2023-03-22', 3),
(8, 'Yara', 'Hisham', 'F', 'Giza', '2001-02-14', 4, '2025-06-01', 4),
(9, 'Tarek', 'Mounir', 'M', 'Kafrelsheikh', '2002-08-20', 1, '2026-01-15', 1); 

----update data in department manager for each department from employee
UPDATE department SET manager_id = 1, since = '2023-10-01' WHERE department_number = 1;
UPDATE department SET manager_id = 2, since = '2018-05-20' WHERE department_number = 2;
UPDATE department SET manager_id = 3, since = '2017-08-15' WHERE department_number = 3;
UPDATE department SET manager_id = 4, since = '2020-02-10' WHERE department_number = 4;
UPDATE department SET manager_id = 1000, since = '2015-01-01' WHERE department_number = 5;

INSERT INTO project (project_number, [name], [location], department_no)
VALUES
(101, 'SuperStore Analysis', 'Smart Village', 4),
(102, 'Population Health AI', 'Kafrelsheikh', 1), 
(103, 'System Upgrade', 'Tech Hub', 2);


INSERT INTO employee_project (project_no, employee_id, [hours])
VALUES
(101, 1, 40.5), --superstore analysis
(101, 5, 20.0), --superstore analysis
(102, 4, 35.0),--population health ai
(102, 8, 30.0), --population health ai
(103, 2, 45.0);--system upgrade

INSERT INTO dependent (emp_id, [name], gender, relationship)
VALUES
(1000, 'Ziad Ahmed', 'M', 'Son'),
(2, 'Laila Ali', 'F', 'Daughter'),
(1, 'Omar Haytham', 'M', 'Brother'); 

