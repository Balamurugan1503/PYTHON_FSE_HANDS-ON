

-- Table 1: departments
CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    hod_name VARCHAR(100) NOT NULL
);

-- Table 2: professors
CREATE TABLE professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    dept_id INT NOT NULL,
    CONSTRAINT fk_professors_departments FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE
);

-- Table 3: students
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    dept_id INT NOT NULL,
    CONSTRAINT fk_students_departments FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE
);

-- Table 4: courses
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL UNIQUE,
    credits INT NOT NULL,
    dept_id INT NOT NULL,
    CONSTRAINT fk_courses_departments FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE
);

-- Table 5: enrollments
--  This table uses a composite primary key consisting of (student_id, course_id)
CREATE TABLE enrollments (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    grade CHAR(1) DEFAULT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_enrollments_students FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollments_courses FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);


-- 10. Add a column phone_number VARCHAR(15) to the students table
ALTER TABLE students ADD COLUMN phone_number VARCHAR(15);

-- 11. Add a column max_seats INT DEFAULT 60 to the courses table
ALTER TABLE courses ADD COLUMN max_seats INT DEFAULT 60;

-- 12. Add a CHECK constraint to enrollments ensuring grade is one of ('A','B','C','D','F') or NULL
-- Note: MySQL 8+ and PostgreSQL support CHECK constraints.
ALTER TABLE enrollments ADD CONSTRAINT chk_enrollments_grade CHECK (grade IN ('A', 'B', 'C', 'D', 'F') OR grade IS NULL);

-- 13. Rename the hod_name column in departments to head_of_dept
ALTER TABLE departments RENAME COLUMN hod_name TO head_of_dept;
-- MySQL Alternative Syntax (uncomment to use in MySQL if RENAME COLUMN is not supported):
-- ALTER TABLE departments CHANGE COLUMN hod_name head_of_dept VARCHAR(100) NOT NULL;

-- 14. Drop the phone_number column added in step 10 (simulate a schema rollback)
ALTER TABLE students DROP COLUMN phone_number;
