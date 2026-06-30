-- ============================================================================
-- COGNIZANT DIGITAL NURTURE 5.0 - MODULE 3: DATABASE INTEGRATION
-- HANDS-ON 2: DATA INSERTION, UPDATES, DELETES AND SELECT QUERIES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. INSERT SAMPLE DATA (DML)
-- ----------------------------------------------------------------------------

-- Insert into Departments (department_id, dept_name, head_of_dept, budget)
INSERT INTO Departments (department_id, dept_name, head_of_dept, budget) VALUES
(1, 'Computer Science', 'Dr. Alan Turing', 750000.00),
(2, 'Mathematics', 'Dr. Ada Lovelace', 500000.00),
(3, 'Physics', 'Dr. Albert Einstein', 600000.00),
(4, 'Chemistry', 'Dr. Marie Curie', 450000.00),
(5, 'Biology', 'Dr. Charles Darwin', 400000.00);

-- Insert into Students (student_id, first_name, last_name, email, date_of_birth, department_id, enrollment_year)
INSERT INTO Students (student_id, first_name, last_name, email, date_of_birth, department_id, enrollment_year) VALUES
(101, 'Alice', 'Smith', 'alice.smith@university.edu', '2003-04-12', 1, 2024),
(102, 'Bob', 'Jones', 'bob.jones@university.edu', '2002-09-22', 1, 2024),
(103, 'Charlie', 'Brown', 'charlie.brown@university.edu', '2004-01-15', 2, 2025),
(104, 'David', 'Miller', 'david.miller@university.edu', '2003-11-30', 2, 2024),
(105, 'Emma', 'Wilson', 'emma.wilson@university.edu', '2002-05-18', 3, 2023),
(106, 'Frank', 'Davis', 'frank.davis@university.edu', '2004-07-04', 3, 2025),
(107, 'Grace', 'Thomas', 'grace.thomas@university.edu', '2003-03-25', 4, 2024),
(108, 'Henry', 'White', 'henry.white@university.edu', '2001-12-05', 4, 2023),
(109, 'Ivy', 'Taylor', 'ivy.taylor@university.edu', '2004-08-14', 5, 2025),
(110, 'Jack', 'Anderson', 'jack.anderson@university.edu', '2002-10-10', 5, 2024),
(111, 'Karen', 'Harris', 'karen.harris@university.edu', '2003-06-20', 1, 2024),
(112, 'Leo', 'Martin', 'leo.martin@university.edu', '2004-02-28', 2, 2025),
(113, 'Mia', 'Clark', 'mia.clark@university.edu', '2003-09-17', 3, 2024),
(114, 'Noah', 'Rodriguez', 'noah.rodriguez@university.edu', '2002-07-12', 4, 2023),
(115, 'Olivia', 'Lewis', 'olivia.lewis@university.edu', '2004-11-01', 5, 2025);

-- Insert Extra Students (requirement: insert extra students)
INSERT INTO Students (student_id, first_name, last_name, email, date_of_birth, department_id, enrollment_year) VALUES
(116, 'Sophia', 'Walker', 'sophia.walker@university.edu', '2003-05-14', 1, 2025),
(117, 'Liam', 'Hall', 'liam.hall@university.edu', '2004-10-09', 2, 2025),
(118, 'Zoe', 'Allen', 'zoe.allen@university.edu', '2002-01-20', 1, 2024);

-- Insert into Courses (course_id, course_name, course_code, credits, department_id, max_seats)
INSERT INTO Courses (course_id, course_name, course_code, credits, department_id, max_seats) VALUES
(201, 'Introduction to Computer Science', 'CS-101', 4, 1, 60),
(202, 'Data Structures and Algorithms', 'CS-201', 4, 1, 45),
(203, 'Linear Algebra', 'MATH-101', 3, 2, 50),
(204, 'Calculus II', 'MATH-201', 4, 2, 40),
(205, 'Classical Mechanics', 'PHYS-101', 4, 3, 30),
(206, 'Electromagnetism', 'PHYS-201', 4, 3, 25),
(207, 'General Chemistry I', 'CHEM-101', 3, 4, 40),
(208, 'Organic Chemistry', 'CHEM-201', 4, 4, 30),
(209, 'General Biology', 'BIO-101', 3, 5, 50),
(210, 'Genetics', 'BIO-201', 4, 5, 30);

-- Insert into Professors (professor_id, prof_name, email, department_id, salary)
INSERT INTO Professors (professor_id, prof_name, email, department_id, salary) VALUES
(301, 'Dr. Grace Hopper', 'grace.hopper@university.edu', 1, 95000.00),
(302, 'Dr. Richard Feynman', 'richard.feynman@university.edu', 3, 98000.00),
(303, 'Dr. Katherine Johnson', 'katherine.johnson@university.edu', 2, 92000.00),
(304, 'Dr. Linus Pauling', 'linus.pauling@university.edu', 4, 88000.00),
(305, 'Dr. Rosalind Franklin', 'rosalind.franklin@university.edu', 5, 89000.00),
(306, 'Dr. Barbara Liskov', 'barbara.liskov@university.edu', 1, 94000.00),
(307, 'Dr. Carl Friedrich Gauss', 'carl.gauss@university.edu', 2, 96000.00),
(308, 'Dr. Stephen Hawking', 'stephen.hawking@university.edu', 3, 99000.00),
(309, 'Dr. Dorothy Hodgkin', 'dorothy.hodgkin@university.edu', 4, 87000.00),
(310, 'Dr. Gregor Mendel', 'gregor.mendel@university.edu', 5, 85000.00);

-- Insert into Enrollments (enrollment_id, student_id, course_id, enrollment_date, grade)
INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date, grade) VALUES
(1, 101, 201, '2024-09-01', 'A'),
(2, 101, 202, '2024-09-01', 'B+'),
(3, 102, 201, '2024-09-01', 'A+'),
(4, 102, 202, '2024-09-01', 'B'),
(5, 103, 203, '2025-01-10', 'A'),
(6, 104, 203, '2024-09-01', 'C+'),
(7, 104, 204, '2024-09-01', 'B'),
(8, 105, 205, '2023-09-01', 'A'),
(9, 106, 205, '2025-01-10', 'B+'),
(10, 107, 207, '2024-09-01', 'A'),
(11, 108, 207, '2023-09-01', 'B'),
(12, 108, 208, '2023-09-01', 'C+'),
(13, 109, 209, '2025-01-10', 'A'),
(14, 110, 209, '2024-09-01', 'B'),
(15, 110, 210, '2024-09-01', 'F'),
(16, 111, 201, '2024-09-01', 'A'),
(17, 112, 204, '2025-01-10', 'B+'),
(18, 113, 206, '2024-09-01', 'A'),
(19, 114, 208, '2023-09-01', 'B'),
(20, 115, 210, '2025-01-10', 'A'),
(21, 116, 201, '2025-01-10', NULL),  -- Ongoing enrollment (no grade yet)
(22, 117, 203, '2025-01-10', NULL),  -- Ongoing enrollment (no grade yet)
(23, 118, 202, '2024-09-01', 'A+');

-- ----------------------------------------------------------------------------
-- 2. UPDATE RECORDS
-- ----------------------------------------------------------------------------

-- Update 1: Increase Computer Science department budget by 10%
UPDATE Departments 
SET budget = budget * 1.10 
WHERE dept_name = 'Computer Science';

-- Update 2: Update student's email address by student_id
UPDATE Students 
SET email = 'alice.newemail@university.edu' 
WHERE student_id = 101;

-- Update 3: Increase salaries of Professors earning less than $90,000 by 5%
UPDATE Professors 
SET salary = salary * 1.05 
WHERE salary < 90000.00;

-- ----------------------------------------------------------------------------
-- 3. DELETE RECORDS
-- ----------------------------------------------------------------------------

-- Delete 1: Delete a specific enrollment record (e.g., student 110 failing genetics, re-enrolling)
DELETE FROM Enrollments 
WHERE student_id = 110 AND course_id = 210;

-- Delete 2: Delete a student record that has no active enrollments (e.g., student 118)
-- Note: We delete enrollment first if exists, then the student. 
-- Since ON DELETE CASCADE is set on fk_enrollment_student, we can directly delete from Students.
DELETE FROM Students 
WHERE student_id = 118;

-- ----------------------------------------------------------------------------
-- 4. SELECT QUERIES
-- ----------------------------------------------------------------------------

-- Query 1: WHERE clause - Retrieve students enrolled in the year 2024 or later
SELECT student_id, first_name, last_name, email, enrollment_year 
FROM Students 
WHERE enrollment_year >= 2024;

-- Query 2: LIKE operator - Find students whose emails end with '@university.edu' and first name starts with 'A' or 'E'
SELECT student_id, first_name, last_name, email 
FROM Students 
WHERE email LIKE '%@university.edu' 
  AND (first_name LIKE 'A%' OR first_name LIKE 'E%');

-- Query 3: BETWEEN operator - Retrieve professors with salary between $90,000 and $97,000
SELECT professor_id, prof_name, salary 
FROM Professors 
WHERE salary BETWEEN 90000.00 AND 97000.00;

-- Query 4: ORDER BY clause - Retrieve courses ordered by credits descending, then by course_name ascending
SELECT course_id, course_name, course_code, credits 
FROM Courses 
ORDER BY credits DESC, course_name ASC;

-- Query 5: GROUP BY and HAVING - Find departments with their student count, showing only departments with > 2 students
SELECT department_id, COUNT(student_id) AS total_students 
FROM Students 
GROUP BY department_id 
HAVING COUNT(student_id) > 2;

-- Query 6: COUNT, AVG, SUM, MAX Aggregations on Professors salaries per department
SELECT 
    department_id,
    COUNT(professor_id) AS number_of_professors,
    AVG(salary) AS average_salary,
    SUM(salary) AS total_salary_payout,
    MAX(salary) AS highest_salary
FROM 
    Professors 
GROUP BY 
    department_id;

-- Query 7: INNER JOIN - Retrieve student names, course names, and grades for all graded enrollments
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    c.course_code,
    c.course_name,
    e.grade
FROM 
    Enrollments e
    INNER JOIN Students s ON e.student_id = s.student_id
    INNER JOIN Courses c ON e.course_id = c.course_id
WHERE 
    e.grade IS NOT NULL
ORDER BY 
    s.last_name, 
    c.course_code;

-- Query 8: LEFT JOIN - Show all departments and the names of their heads alongside their professors (if any)
-- (Helps identify departments without many professors or verify mapping)
SELECT 
    d.dept_name,
    d.head_of_dept,
    p.prof_name,
    p.email AS prof_email
FROM 
    Departments d
    LEFT JOIN Professors p ON d.department_id = p.department_id
ORDER BY 
    d.dept_name, 
    p.prof_name;

-- Query 9: Advanced JOIN - Multi-table join showing details of Students, their Departments, and their Course Enrollments
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_full_name,
    d.dept_name AS student_department,
    c.course_code,
    c.course_name,
    e.enrollment_date,
    COALESCE(e.grade, 'Ongoing') AS grade_status
FROM 
    Students s
    INNER JOIN Departments d ON s.department_id = d.department_id
    INNER JOIN Enrollments e ON s.student_id = e.student_id
    INNER JOIN Courses c ON e.course_id = c.course_id
ORDER BY 
    student_department, 
    student_full_name;
