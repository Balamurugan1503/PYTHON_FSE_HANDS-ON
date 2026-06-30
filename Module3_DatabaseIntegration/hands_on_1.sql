-- ============================================================================
-- COGNIZANT DIGITAL NURTURE 5.0 - MODULE 3: DATABASE INTEGRATION
-- HANDS-ON 1: SCHEMA DESIGN, CONSTRAINTS & DDL OPERATIONS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- NORMALIZATION ANALYSIS & COMMENTS
-- ----------------------------------------------------------------------------
/*
DATABASE NORMALIZATION ANALYSIS (college_db):

1. FIRST NORMAL FORM (1NF):
   - Definition: A table is in 1NF if all attributes contain only atomic (indivisible) 
     values, and there are no repeating groups.
   - Application in our schema:
     * All columns contain single atomic values (e.g., 'first_name' and 'last_name' 
       are separated, rather than a single 'full_name' field).
     * There are no multi-valued attributes (e.g., we do not store multiple emails 
       or phone numbers in a single field separated by commas).
     * Every table has a primary key that uniquely identifies each row.

2. SECOND NORMAL FORM (2NF):
   - Definition: A table is in 2NF if it is in 1NF and all non-key attributes are 
     fully functionally dependent on the entire primary key (no partial dependency).
   - Application in our schema:
     * For tables with simple single-column primary keys (Departments, Students, Courses, 
       Professors, Enrollments), 2NF is automatically satisfied because any partial 
       dependency is impossible.
     * In the 'Enrollments' table, even though student_id and course_id could form a composite key,
       we use a surrogate primary key 'enrollment_id'. All non-key attributes ('enrollment_date', 'grade')
       depend entirely on the single 'enrollment_id' primary key, satisfying 2NF.

3. THIRD NORMAL FORM (3NF):
   - Definition: A table is in 3NF if it is in 2NF and has no transitive dependencies 
     (i.e., non-key attributes must not depend on other non-key attributes).
   - Application in our schema:
     * In 'Students', attributes like first_name, last_name, email, date_of_birth, and enrollment_year 
       depend directly on the 'student_id'. There are no dependencies among these non-key attributes.
     * The department details (dept_name, head_of_dept, budget) are stored in the 'Departments' 
       table. In 'Students', we only store 'department_id' as a foreign key. If we stored 
       'dept_name' in the 'Students' table, it would depend on 'department_id' which in turn 
       depends on 'student_id' (a transitive dependency: student_id -> department_id -> dept_name).
       Separating this into 'Departments' removes the transitive dependency, achieving 3NF.
*/

-- ----------------------------------------------------------------------------
-- DATABASE CREATION (Conceptual / Setup Instruction)
-- ----------------------------------------------------------------------------
-- Note: In PostgreSQL/MySQL, database creation commands must be executed outside 
-- transaction blocks. The following command is commented out but provided for completeness.
-- CREATE DATABASE college_db;
-- \c college_db; -- (PostgreSQL switch database command)
-- USE college_db; -- (MySQL switch database command)

-- ----------------------------------------------------------------------------
-- DROP TABLES (Clean slate initialization - drop in reverse order of dependencies)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Professors;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Departments;

-- ----------------------------------------------------------------------------
-- TABLE CREATION & CONSTRAINT DEFINITION (DDL)
-- ----------------------------------------------------------------------------

-- 1. Departments Table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    head_of_dept VARCHAR(100),
    budget DECIMAL(15, 2) NOT NULL,
    -- Check Constraint: Budget must be positive
    CONSTRAINT chk_dept_budget CHECK (budget >= 0.00)
);

-- 2. Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_of_birth DATE,
    department_id INT,
    enrollment_year INT NOT NULL,
    -- Foreign Key Constraint linking to Departments
    CONSTRAINT fk_student_department FOREIGN KEY (department_id) 
        REFERENCES Departments(department_id) ON DELETE SET NULL,
    -- Check Constraint: Enrollment year must be a realistic value
    CONSTRAINT chk_enrollment_year CHECK (enrollment_year >= 2000),
    -- Check Constraint: Birth date must be at least 15 years in the past (basic validation)
    CONSTRAINT chk_dob CHECK (date_of_birth < CURRENT_DATE - INTERVAL '15 years' OR date_of_birth IS NULL)
);

-- 3. Courses Table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(15) NOT NULL UNIQUE,
    credits INT NOT NULL,
    department_id INT NOT NULL,
    max_seats INT NOT NULL,
    -- Foreign Key Constraint linking to Departments
    CONSTRAINT fk_course_department FOREIGN KEY (department_id) 
        REFERENCES Departments(department_id) ON DELETE CASCADE,
    -- Check Constraints: credits and seats must be positive integers
    CONSTRAINT chk_course_credits CHECK (credits > 0 AND credits <= 6),
    CONSTRAINT chk_course_max_seats CHECK (max_seats > 0)
);

-- 4. Enrollments Table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    grade VARCHAR(2),
    -- Foreign Key Constraints
    CONSTRAINT fk_enrollment_student FOREIGN KEY (student_id) 
        REFERENCES Students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollment_course FOREIGN KEY (course_id) 
        REFERENCES Courses(course_id) ON DELETE CASCADE,
    -- Check Constraint: Grades must belong to standard GPA scale (A, B, C, D, F) or be NULL (ongoing course)
    CONSTRAINT chk_enrollment_grade CHECK (grade IN ('A+', 'A', 'B+', 'B', 'C+', 'C', 'D', 'F') OR grade IS NULL),
    -- Unique Constraint: Prevent a student from enrolling in the same course twice
    CONSTRAINT uq_student_course UNIQUE (student_id, course_id)
);

-- 5. Professors Table
CREATE TABLE Professors (
    professor_id INT PRIMARY KEY,
    prof_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    department_id INT NOT NULL,
    salary DECIMAL(12, 2) NOT NULL,
    -- Foreign Key Constraint
    CONSTRAINT fk_professor_department FOREIGN KEY (department_id) 
        REFERENCES Departments(department_id) ON DELETE CASCADE,
    -- Check Constraint: Salary must be positive
    CONSTRAINT chk_professor_salary CHECK (salary > 0.00)
);

-- ----------------------------------------------------------------------------
-- DDL ALTER TABLE DEMONSTRATIONS
-- ----------------------------------------------------------------------------

-- Add a column: adding an optional notes column to Departments
ALTER TABLE Departments ADD COLUMN temp_notes VARCHAR(255);

-- Rename a column: renaming the notes column
ALTER TABLE Departments RENAME COLUMN temp_notes TO dept_notes;

-- Drop a column: removing the column from the table structure
ALTER TABLE Departments DROP COLUMN dept_notes;

-- ----------------------------------------------------------------------------
-- VERIFICATION QUERIES
-- ----------------------------------------------------------------------------

-- Verify that all tables are created and are empty
SELECT 'Departments' AS table_name, COUNT(*) AS row_count FROM Departments
UNION ALL
SELECT 'Students' AS table_name, COUNT(*) FROM Students
UNION ALL
SELECT 'Courses' AS table_name, COUNT(*) FROM Courses
UNION ALL
SELECT 'Enrollments' AS table_name, COUNT(*) FROM Enrollments
UNION ALL
SELECT 'Professors' AS table_name, COUNT(*) FROM Professors;

-- ----------------------------------------------------------------------------
-- INFORMATION SCHEMA QUERIES
-- ----------------------------------------------------------------------------

-- Query 1: Retrieve details of all columns in the college database tables
SELECT 
    table_name, 
    column_name, 
    data_type, 
    is_nullable, 
    character_maximum_length 
FROM 
    information_schema.columns 
WHERE 
    table_schema = 'public' 
    AND table_name IN ('departments', 'students', 'courses', 'enrollments', 'professors')
ORDER BY 
    table_name, 
    ordinal_position;

-- Query 2: Retrieve all primary and foreign key constraints on the tables
SELECT 
    tc.table_name, 
    tc.constraint_name, 
    tc.constraint_type,
    kcu.column_name
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
WHERE 
    tc.table_schema = 'public'
    AND tc.table_name IN ('departments', 'students', 'courses', 'enrollments', 'professors')
ORDER BY 
    tc.table_name, 
    tc.constraint_type;
