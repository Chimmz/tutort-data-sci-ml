use company_db;

-- Select all rows and columns
select * from employee;

select fname, lname, ssn, sex
from employee;

select dname, mgr_ssn
from department;

select fname as first_name, lname as last_name, ssn as employee_id, sex as gender
from employee;

SELECT *
FROM employee
WHERE dno!=5 AND sex='F';

SELECT *
FROM employee
WHERE salary>=30000
LIMIT 4;

SELECT *
FROM employee
WHERE sex='M' AND salary < 40000;

-- Select employees whose first names start with 'a' or 'A'
SELECT *
FROM employee
WHERE fname LIKE 'a%'; -- Starts with 'a'

-- Select employees whose first names contain 'a' or 'A' in the middle
SELECT *
FROM employee
WHERE fname LIKE '%a%';

-- Select employees whose first names contain 'a' and 'e'
SELECT *
FROM employee
WHERE fname LIKE '%a%' AND fname LIKE '%e%';

-- Select employees whose first names contain 'a' and sequentially contains 'e'
SELECT *
FROM employee
WHERE fname LIKE '%a%e%';

-- Select employees whose fname either contains 'a' OR (they're males from department with deptno 5)
SELECT *
FROM employee
WHERE (fname NOT LIKE '%a%') OR (sex='M' AND dno=5);

-- Select employees who're not in deptno 5
SELECT *
FROM employee
-- WHERE dno!=5
-- WHERE dno<>5
WHERE NOT dno=5;

-- Select employees non-female employees having salaries less than 45k
SELECT *
FROM employee
WHERE (NOT sex='F') AND salary < 45000;

-- Select employees whose salaries are at least 30k and at most 40k
SELECT *
FROM employee
WHERE salary BETWEEN 30000 AND 40000;

-- Employees who are in departments 1 or 4
SELECT *
FROM employee
WHERE dno in (1, 4);

-- Employees who are not in departments 1 and 4
SELECT *
FROM employee
WHERE NOT (dno IN (1, 4));

-- Employees whose salaries are greater than 30k and are in departments 1 or 5
select * from employee where salary > 30000 and dno in (1, 5);

-- Employees with odd 'ssn'
select * from employee where ssn % 2 = 1;

-- Selecting rows having a field as NULL
SELECT * from employee where super_ssn is NULL;
SELECT * from employee where super_ssn is not NULL;

-- Sorting by salary
select * from employee order by salary asc;

Select *
From employee
Where salary >= 30000 OR dno in (4, 5)
Order by salary desc;

-- ###### Aggregate Functions ########

select count(*) as total_employees from employee; -- Total employees
select avg(salary) as average_salary FROM employee; -- Average salary
select min(salary) as min_salary FROM employee; -- Min salary
select distinct dno as all_deps from employee; -- Distinct departments
select count(distinct dno) as total_deps from employee; -- Distinct departments

-- Get min, max, avg, total salaries of all male employees
select 
	MIN(salary) as min_salary_male,
  MAX(salary) as max_salary_male, 
  AVG(salary) as avg_salary_male,
  SUM(salary) as total_salary_male
from employee
where sex='M';

-- # Select birth day, month, year from employees
select 
	day(bdate) as birth_day,
	month(bdate) as birth_month,
	year(bdate) as birth_yr
from employee;

-- # Current date, time, timestamp
select current_date(), current_time(), current_timestamp();

-- # Select age of employees in days
select ssn, bdate, datediff(current_date(), bdate) as age_in_days
from employee;

-- # Select age of employees in years
select ssn, bdate, round(datediff(current_date(), bdate) / 365) as age_in_yrs
from employee;

-- # Select age of employees in years (II)
select ssn, bdate, year(current_date()) - year(bdate) as age_in_yrs
from employee;

-- # Add 6 months to birth date
select ssn, bdate, date_add(bdate, interval 6 month) as new_date
from employee;

-- # Add 7 days to birth date
select ssn, bdate, date_add(bdate, interval 7 day) as new_date
from employee;

-- ########### String Manipulation ###############
-- Concat
select concat(fname, ' ', lname) as full_name
from employee;

-- # Substring
select substr(fname, 2, 4) as my_substr -- Starting from index 2, get 4 chars
from employee;

-- Get last 3 letters
select right(fname, 3) as last_3_chars from employee;
-- # OR
select substr(fname, -3, 3) as last_3_chars from employee;

-- Max no of hours an employee worked?
select max(hours) from works_on;

-- What's salary range?
select max(salary) - min(salary) as salary_range
from employee;

-- Group by
select dno, avg(salary) from employee group by dno;

-- Average salary for each gender
select sex, avg(salary) from employee group by sex;

-- Min, max, total salaries by gender
SELECT
	sex,
    count(*) as total,
    min(salary) as min_salary,
    max(salary) as max_salary,
    sum(salary) as total_salary
FROM employee
GROUP BY sex;

-- Number of dependents for each employee
SELECT essn, count(*) as total_dependents
FROM dependent
GROUP BY essn;

-- Total hours spent on each project
SELECT pno, sum(hours) as total_hours
FROM works_on
GROUP BY pno;

-- Avg and max salary for male employees in each dept in decreasing order of dept number
SELECT
	dno,
    avg(salary) as avg_salary,
    min(salary) as min_salary
FROM employee
GROUP BY dno
ORDER BY dno desc;

-- ############# The HAVING Clause ################
-- List of employees who have at least 2 dependents
SELECT essn, count(*) as total_dependents
FROM dependent
GROUP BY essn
HAVING total_dependents > 2; -- 'HAVING' is same as 'WHERE' except that it accepts variables generated. Eg. total_dependents

--  List of departments where avg salary is more than 30000
SELECT dno, avg(salary) as avg_salary
FROM employee
GROUP BY dno
HAVING avg_salary > 35000;

-- ############# The CASE WHEN clause ###############
-- It is used to create a new column in the existing tables
-- # Create a new column 'salary_bucket' which records '>=35k' if salary is more than 35,000 else '<35k'
SELECT
	ssn,
    salary,
	CASE
		WHEN salary >= 35000 THEN ">=35k"
		WHEN salary <= 35000 THEN ">=35k"
    END as salary_bucket
FROM employee;

SELECT
	ssn,
	sex,
	CASE
		WHEN sex='M' THEN floor(salary) ELSE 0
	END AS male_salary,		-- Notice the ',' separator
	CASE
		WHEN sex='F' THEN floor(salary) ELSE 0
	END AS female_salary
FROM employee;
    
-- Select avg salary for each gender
SELECT sex, avg(salary) as avg_salary
FROM employee
GROUP BY sex;

--- OR ---

SELECT
	avg(CASE when sex='M' then salary END) as avg_male_salary,
	avg(CASE when sex='F' then salary  END) as avg_female_salary
FROM employee;

-- Count the no of sons, daughter, spouse of each employee
SELECT
	essn, 
    count(CASE when relationship='Daughter' then 1 END) as daughters_count,
    count(CASE when relationship='Son' then 1 END) as sons_count,
    count(CASE when relationship='Spouse' then 1 END) as spouse_count
FROM dependent
GROUP BY essn;

-- # 2. What is the salary range in the company? (salary range is difference between minimum and maximum salary)

-- # 3. How many distinct department locations are there?
SELECT distinct dlocation, dnumber
FROM dept_locations;

-- # 4. how many distinct employees have daughters as dependent
SELECT count(distinct essn) as total_employees_with_daughters
FROM dependent
WHERE relationship = 'Daughter';

-- # 5. how many projects are there under department 5?
SELECT count(*)
FROM department
WHERE dnumber = 5;

-- # 6. What is the avg salary of employees who are from department 5 and are male?
SELECT avg(salary)
FROM employee
WHERE dno = 5 and sex='M';

-- # 7. Create a column "manager_null_flag" which has 1 when the manager id is null else it is 0 (in employee table)
SELECT
	super_ssn,
	CASE
		when super_ssn is NULL then 1 else 0
	END AS 'manager_null_flag'
FROM employee



