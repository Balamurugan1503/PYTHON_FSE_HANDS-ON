USE college_db;

-- ----------------------------
-- Task 1: Insert Sample Data
-- ----------------------------

INSERT INTO departments (dept_name, head_of_dept, budget)
VALUES
('Computer Science','Dr. Ramesh Kumar',850000),
('Electronics','Dr. Priya Nair',620000),
('Mechanical','Dr. Suresh Iyer',540000),
('Civil','Dr. Ananya Sharma',430000);

INSERT INTO students
(first_name,last_name,email,date_of_birth,department_id,enrollment_year)
VALUES
('Arjun','Mehta','arjun.mehta@college.edu','2003-04-12',1,2022),
('Priya','Suresh','priya.suresh@college.edu','2003-07-25',1,2022),
('Rohan','Verma','rohan.verma@college.edu','2002-11-08',2,2021),
('Sneha','Patel','sneha.patel@college.edu','2004-01-30',3,2023),
('Vikram','Das','vikram.das@college.edu','2003-09-14',1,2022),
('Kavya','Menon','kavya.menon@college.edu','2002-05-17',2,2021),
('Aditya','Singh','aditya.singh@college.edu','2004-03-22',4,2023),
('Deepika','Rao','deepika.rao@college.edu','2003-08-09',1,2022);

INSERT INTO courses
(course_name,course_code,credits,department_id)
VALUES
('Data Structures & Algorithms','CS101',4,1),
('Database Management Systems','CS102',3,1),
('Object Oriented Programming','CS103',4,1),
('Circuit Theory','EC101',3,2),
('Thermodynamics','ME101',3,3);

INSERT INTO enrollments
(student_id,course_id,enrollment_date,grade)
VALUES
(1,1,'2022-07-01','A'),
(1,2,'2022-07-01','B'),
(2,1,'2022-07-01','B'),
(2,3,'2022-07-01','A'),
(3,4,'2021-07-01','A'),
(4,5,'2023-07-01',NULL),
(5,1,'2022-07-01','C'),
(5,2,'2022-07-01','A'),
(6,4,'2021-07-01','B'),
(7,5,'2023-07-01',NULL),
(8,1,'2022-07-01','A'),
(8,3,'2022-07-01','B');

INSERT INTO professors
(prof_name,email,department_id,salary)
VALUES
('Dr. Anand Krishnan','anand.k@college.edu',1,95000),
('Dr. Meena Pillai','meena.p@college.edu',1,88000),
('Dr. Sunil Rajan','sunil.r@college.edu',2,82000),
('Dr. Latha Gopal','latha.g@college.edu',3,79000),
('Dr. Kartik Bose','kartik.b@college.edu',4,76000);

-- Add two new students

INSERT INTO students
(first_name,last_name,email,date_of_birth,department_id,enrollment_year)
VALUES
('Balamurugan','Gnanasekaran','bala.g@college.edu','2003-05-15',1,2022),
('Rahul','Kumar','rahul.k@college.edu','2004-08-10',2,2023);

-- Check number of students

SELECT COUNT(*) AS total_students
FROM students;

-- Update grade

UPDATE enrollments
SET grade='B'
WHERE student_id=5
AND course_id=1;

-- View rows with NULL grade before deleting

SELECT *
FROM enrollments
WHERE grade IS NULL;

-- Delete NULL grades

DELETE
FROM enrollments
WHERE grade IS NULL;

-- Count enrollments

SELECT COUNT(*) AS total_enrollments
FROM enrollments;

-- ----------------------------
-- Task 2
-- ----------------------------

SELECT *
FROM students
WHERE enrollment_year=2022
ORDER BY last_name;

SELECT *
FROM courses
WHERE credits>3
ORDER BY credits DESC;

SELECT *
FROM professors
WHERE salary BETWEEN 80000 AND 95000;

SELECT *
FROM students
WHERE email LIKE '%@college.edu';

SELECT enrollment_year,
COUNT(*) AS total_students
FROM students
GROUP BY enrollment_year;

-- ----------------------------
-- Task 3
-- ----------------------------

SELECT
CONCAT(first_name,' ',last_name) AS student_name,
dept_name
FROM students s
JOIN departments d
ON s.department_id=d.department_id;

SELECT
CONCAT(first_name,' ',last_name) AS student_name,
course_name,
grade
FROM enrollments e
JOIN students s
ON e.student_id=s.student_id
JOIN courses c
ON e.course_id=c.course_id;

SELECT
CONCAT(first_name,' ',last_name) AS student_name
FROM students s
LEFT JOIN enrollments e
ON s.student_id=e.student_id
WHERE e.student_id IS NULL;

SELECT
course_name,
COUNT(student_id) AS total_students
FROM courses c
LEFT JOIN enrollments e
ON c.course_id=e.course_id
GROUP BY course_name;

SELECT
dept_name,
prof_name,
salary
FROM departments d
LEFT JOIN professors p
ON d.department_id=p.department_id;

-- ----------------------------
-- Task 4
-- ----------------------------

SELECT
course_name,
COUNT(student_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e
ON c.course_id=e.course_id
GROUP BY course_name;

SELECT
dept_name,
ROUND(AVG(salary),2) AS average_salary
FROM departments d
LEFT JOIN professors p
ON d.department_id=p.department_id
GROUP BY dept_name;

SELECT *
FROM departments
WHERE budget>600000;

SELECT
grade,
COUNT(*) AS total
FROM enrollments e
JOIN courses c
ON e.course_id=c.course_id
WHERE course_code='CS101'
GROUP BY grade;

SELECT
dept_name,
COUNT(e.student_id) AS total_students
FROM departments d
JOIN courses c
ON d.department_id=c.department_id
JOIN enrollments e
ON c.course_id=e.course_id
GROUP BY dept_name
HAVING COUNT(e.student_id)>2;