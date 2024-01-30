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

------ Aggregate Functions ------

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

--- Select birth day, month, year from employees
select 
	day(bdate) as birth_day,
	month(bdate) as birth_month,
	year(bdate) as birth_yr
from employee;

--- Current date, time, timestamp
select current_date(), current_time(), current_timestamp();

--- Select age of employees in days
select ssn, bdate, datediff(current_date(), bdate) as age_in_days
from employee;

--- Select age of employees in years
select ssn, bdate, round(datediff(current_date(), bdate) / 365) as age_in_yrs
from employee;

--- Select age of employees in years (II)
select ssn, bdate, year(current_date()) - year(bdate) as age_in_yrs
from employee;

--- Add 6 months to birth date
select ssn, bdate, date_add(bdate, interval 6 month) as new_date
from employee;

--- Add 7 days to birth date
select ssn, bdate, date_add(bdate, interval 7 day) as new_date
from employee;

------ String Manipulation ------
-- Concat
select concat(fname, ' ', lname) as full_name
from employee;

--- Substring
select substr(fname, 2, 4) as my_substr -- Starting from index 2, get 4 chars
from employee;

-- Get last 3 letters
select right(fname, 3) as last_3_chars from employee;
--- OR
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
WHERE sex = 'M'
GROUP BY dno
ORDER BY dno desc;

------ The HAVING Clause ------
-- List of employees who have at least 2 dependents
select essn, count(*) as dependents
from dependent
group by essn
having dependents >= 2; -- 'HAVING' is same as 'WHERE' except that it accepts variables generated. Eg. total_dependents

--  List of departments where avg salary is more than 35000
SELECT dno, avg(salary) as avg_salary
FROM employee
GROUP BY dno
HAVING avg_salary > 30000;

-- Another Approach
select
	dno,
	case
		when avg(salary) > 35000 then 'Yes' else 'No'
    end as salary_exceeds_35000
from employee
group by dno;

------ The CASE WHEN clause ------
-- It is used to create a new column in the existing tables
--- Create a new column 'salary_bucket' which records '>=35k' if salary is more than 35,000 else '<35k'
SELECT
	ssn, salary,
	CASE
		WHEN salary >= 35000 THEN ">=35k"
		WHEN salary <= 35000 THEN ">=35k"
    END as salary_bucket
FROM employee;

-- Select male, female salary
SELECT
	ssn, sex,
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

-- Count the no of sons, daughters, spouse of each employee
select
	essn,
	count(case when lower(relationship) = 'daughter' then 1 end) as daughters,
	count(case when lower(relationship) = 'son' then 1 end) as sons,
	count(case when lower(relationship) = 'spouse' then 1 end) as spouses
from dependent
group by essn;

-- 2. What is the salary range in the company? (salary range is difference between minimum and maximum salary)
select * from employee;

-- 3. How many distinct department locations are there?
SELECT distinct dlocation, dnumber
FROM dept_locations;

-- 4. how many distinct employees have daughters as dependent
SELECT count(distinct essn) as total_employees_with_daughters
FROM dependent
WHERE relationship = 'Daughter';

-- 5. how many projects are there under department 5?
SELECT count(*)
FROM department
WHERE dnumber = 5;

-- 6. What is the avg salary of employees who are from department 5 and are male?
SELECT avg(salary)
FROM employee
WHERE dno = 5 and sex='M';

-- 7. Create a column "manager_null_flag" which has 1 when the manager id is null else it is 0 (in employee table)
SELECT
	super_ssn,
	CASE
		when super_ssn is NULL then 1 else 0
	END AS 'manager_null_flag'
FROM employee;

---- JOINS -----
-- Select employees and their respective departments each belong to
-- select e.*, d.dname as department
SELECT
	e.ssn,
	concat(e.fname, ' ', e.lname) as fullname,
    d.dname as department_name
FROM
	employee as e
    LEFT JOIN department as d
    ON e.dno = d.dnumber;
    
-- Bring first & last name to the works_on table
select distinct w.essn as emp_id, w.pno, w.hours, e.fname, e.lname
from
	works_on as w
	left join employee as e
    on w.essn = e.ssn;

-- Bring department manager id to the project table
select * from department;
select * from project;

select p.*, d.mgr_ssn as manager_id
from department as d
	left join project as p
    on d.dnumber = p.dnum;

-- Find the total work hours for each employee. Attach their corresponding first and lastnames
select essn, sum(w.hours), e.fname, e.lname
from
	works_on as w
	left join employee as e
    on w.essn = e.ssn
group by w.essn, e.fname, e.lname;

	
---------------- WINDOW FUNCTIONS ---------------

-- Update Statement
update employee
set salary = 40000
where fname = "Ramesh";
-- select * from employee;

select
	ssn, fname, lname, salary,
    LAG(salary) over (order by salary desc) as  previous_salary,
    LAG(salary, 2) over (order by salary desc) as last_2_salaries,
    LEAD(salary) over (order by salary desc) as next_salary,
    ROW_NUMBER() over (order by salary desc) as row_num,
    RANK() over (order by salary desc) as rank_1,
    DENSE_RANK() over (order by salary desc) as rank_2
from employee
order by salary desc;

select
	ssn, fname, lname, dno, salary,
    LAG(salary) OVER (partition by dno order by salary desc) as prev_salary
from employee
order by dno, salary desc;

-- Get the rank of male and female employees separately
select
	ssn, fname, lname, dno, sex, salary,
    rank() over (partition by sex order by salary desc) as rank_1,
    dense_rank() over (partition by sex order by salary desc) as rank_2
from employee
order by sex, salary desc;

--------- ADD NEW COLUMN TO TABLE
ALTER TABLE employee
ADD COLUMN bonus int;
-- select * from employee;

--------- DROP COLUMN FROM EXISTING TABLE
ALTER TABLE employee
DROP COLUMN bonus;
-- select * from employee;

-------- UPDATE
UPDATE employee
set bonus = 0.15 * salary;
select * from employee;



