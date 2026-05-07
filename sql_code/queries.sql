use company_db1

--To obtain the names of the employees who worked on the "SuperStore Analysis" project number 101
SELECT 
    e.first_name, 
    e.last_name, 
    ep.[hours]
FROM employee AS e
INNER JOIN employee_project AS ep 
ON e.id = ep.employee_id
WHERE ep.project_no = 101;

--Inquiry about employees with dependents
SELECT 
    e.first_name, 
    e.last_name, 
    d.[name] AS dependent_name, 
    d.relationship
FROM employee AS e
INNER JOIN dependent AS d 
ON e.id = d.emp_id;

--Linking employees to their departments
SELECT 
    e.first_name, 
    e.last_name, 
    d.[name] AS department_name,
    d.[location] AS department_location
FROM employee AS e
INNER JOIN department AS d 
ON e.department_no = d.department_number;

--Knowing each employee and their manager
SELECT 
    e.first_name AS Employee_First_Name,
    e.last_name AS Employee_Last_Name,
    m.first_name AS Manager_First_Name,
    m.last_name AS Manager_Last_Name
FROM employee AS e
LEFT JOIN employee AS m 
ON e.super_id = m.id;

--Retrieve department names and the full names of their managers
SELECT 
    d.[name] AS Department_Name, 
    e.first_name + ' ' + e.last_name AS Manager_Full_Name, 
    d.since AS Managed_Since
FROM department AS d
INNER JOIN employee AS e ON d.manager_id = e.id;


--Calculate the total working hours spent on each project
SELECT 
    p.[name] AS Project_Name, 
    SUM(ep.[hours]) AS Total_Hours_Spent
FROM project AS p
INNER JOIN employee_project AS ep ON p.project_number = ep.project_no
GROUP BY p.[name];


--Full Map: Display employee names, the projects they are assigned to, and their department names
SELECT 
    e.first_name + ' ' + e.last_name AS Employee_Name,
    p.[name] AS Project_Name,
    d.[name] AS Department_Name
FROM employee AS e
JOIN employee_project AS ep ON e.id = ep.employee_id
JOIN project AS p ON ep.project_no = p.project_number
JOIN department AS d ON e.department_no = d.department_number;