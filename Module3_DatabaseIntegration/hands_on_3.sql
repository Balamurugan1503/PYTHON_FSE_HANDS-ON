-- ============================================================================
-- COGNIZANT DIGITAL NURTURE 5.0 - MODULE 3: DATABASE INTEGRATION
-- HANDS-ON 3: SUBQUERIES, VIEWS, PROCEDURES, FUNCTIONS & TRANSACTIONS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. SUBQUERIES
-- ----------------------------------------------------------------------------

-- Query 1: Scalar Subquery - Retrieve courses that have credits greater than the average credits of all courses
SELECT course_id, course_name, course_code, credits 
FROM Courses 
WHERE credits > (SELECT AVG(credits) FROM Courses);

-- Query 2: Correlated Subquery - Find professors who earn more than the average salary of their respective department
SELECT p1.professor_id, p1.prof_name, p1.salary, p1.department_id 
FROM Professors p1
WHERE p1.salary > (
    SELECT AVG(p2.salary) 
    FROM Professors p2 
    WHERE p2.department_id = p1.department_id
);

-- Query 3: EXISTS / NOT EXISTS Subquery - Find departments that have NO courses registered
SELECT d.department_id, d.dept_name 
FROM Departments d
WHERE NOT EXISTS (
    SELECT 1 
    FROM Courses c 
    WHERE c.department_id = d.department_id
);

-- ----------------------------------------------------------------------------
-- 2. VIEWS
-- ----------------------------------------------------------------------------

-- View 1: Student Course Detail View (Combines student details, course details, and enrollment grades)
DROP VIEW IF EXISTS v_student_academic_summary;
CREATE VIEW v_student_academic_summary AS
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    s.email AS student_email,
    d.dept_name AS department,
    c.course_code,
    c.course_name,
    c.credits,
    COALESCE(e.grade, 'Ongoing') AS final_grade
FROM 
    Students s
    INNER JOIN Departments d ON s.department_id = d.department_id
    INNER JOIN Enrollments e ON s.student_id = e.student_id
    INNER JOIN Courses c ON e.course_id = c.course_id;

-- Test View 1
SELECT * FROM v_student_academic_summary LIMIT 5;


-- View 2: Department Stats View (Aggregates budgets, professor count, student count, average professor salaries)
DROP VIEW IF EXISTS v_department_summary_stats;
CREATE VIEW v_department_summary_stats AS
SELECT 
    d.department_id,
    d.dept_name,
    d.budget AS total_budget,
    (SELECT COUNT(*) FROM Students s WHERE s.department_id = d.department_id) AS total_students,
    (SELECT COUNT(*) FROM Professors p WHERE p.department_id = d.department_id) AS total_professors,
    COALESCE((SELECT AVG(salary) FROM Professors p WHERE p.department_id = d.department_id), 0.00) AS avg_professor_salary
FROM 
    Departments d;

-- Test View 2
SELECT * FROM v_department_summary_stats;

-- ----------------------------------------------------------------------------
-- 3. DERIVED TABLES (Subqueries in FROM clause)
-- ----------------------------------------------------------------------------

-- Query using a derived table to show departments and their budget deviations from the college-wide average
SELECT 
    dept.dept_name,
    dept.budget,
    avg_stats.avg_college_budget,
    (dept.budget - avg_stats.avg_college_budget) AS budget_difference
FROM 
    Departments dept,
    (SELECT AVG(budget) AS avg_college_budget FROM Departments) AS avg_stats
ORDER BY 
    budget_difference DESC;

-- ----------------------------------------------------------------------------
-- 4. STORED FUNCTIONS & PROCEDURES
-- ----------------------------------------------------------------------------

-- Note: Syntaxes differ between PostgreSQL (PL/pgSQL) and MySQL. 
-- The following implementations are written for PostgreSQL, with MySQL equivalents in comments.

-- --- FUNCTION: get_student_enrollment_count ---
-- Returns the total courses a student is enrolled in.
CREATE OR REPLACE FUNCTION get_student_enrollment_count(p_student_id INT)
RETURNS INT AS $$
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*) INTO v_count 
    FROM Enrollments 
    WHERE student_id = p_student_id;
    
    RETURN v_count;
END;
$$ LANGUAGE plpgsql;

-- [MYSQL EQUIVALENT FUNCTION]
/*
DELIMITER //
CREATE FUNCTION get_student_enrollment_count(p_student_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM Enrollments WHERE student_id = p_student_id;
    RETURN v_count;
END //
DELIMITER ;
*/

-- Test Stored Function
SELECT get_student_enrollment_count(101) AS enrollment_count;


-- --- STORED PROCEDURE: enroll_student_in_course ---
-- Registers a student for a course. Checks max seat constraints and duplicate registration.
CREATE OR REPLACE PROCEDURE enroll_student_in_course(
    p_enrollment_id INT,
    p_student_id INT,
    p_course_id INT
) AS $$
DECLARE
    v_seats_occupied INT;
    v_max_seats INT;
    v_already_enrolled INT;
BEGIN
    -- 1. Check if student is already enrolled in this course
    SELECT COUNT(*) INTO v_already_enrolled 
    FROM Enrollments 
    WHERE student_id = p_student_id AND course_id = p_course_id;

    IF v_already_enrolled > 0 THEN
        RAISE EXCEPTION 'Student % is already enrolled in course %', p_student_id, p_course_id;
    END IF;

    -- 2. Check course capacity
    SELECT COUNT(*) INTO v_seats_occupied FROM Enrollments WHERE course_id = p_course_id;
    SELECT max_seats INTO v_max_seats FROM Courses WHERE course_id = p_course_id;

    IF v_seats_occupied >= v_max_seats THEN
        RAISE EXCEPTION 'Course % has no seats available. Max seats: %, Occupied: %', p_course_id, v_max_seats, v_seats_occupied;
    END IF;

    -- 3. Perform the enrollment
    INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date, grade)
    VALUES (p_enrollment_id, p_student_id, p_course_id, CURRENT_DATE, NULL);
    
    RAISE NOTICE 'Enrollment successful: Student % enrolled in course %', p_student_id, p_course_id;
END;
$$ LANGUAGE plpgsql;

-- [MYSQL EQUIVALENT PROCEDURE]
/*
DELIMITER //
CREATE PROCEDURE enroll_student_in_course(
    IN p_enrollment_id INT,
    IN p_student_id INT,
    IN p_course_id INT
)
BEGIN
    DECLARE v_seats_occupied INT;
    DECLARE v_max_seats INT;
    DECLARE v_already_enrolled INT;

    -- Check if student already enrolled
    SELECT COUNT(*) INTO v_already_enrolled FROM Enrollments WHERE student_id = p_student_id AND course_id = p_course_id;
    IF v_already_enrolled > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Student already enrolled in this course';
    END IF;

    -- Check capacity
    SELECT COUNT(*) INTO v_seats_occupied FROM Enrollments WHERE course_id = p_course_id;
    SELECT max_seats INTO v_max_seats FROM Courses WHERE course_id = p_course_id;
    IF v_seats_occupied >= v_max_seats THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Course is full';
    END IF;

    -- Insert
    INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date, grade)
    VALUES (p_enrollment_id, p_student_id, p_course_id, CURDATE(), NULL);
END //
DELIMITER ;
*/

-- ----------------------------------------------------------------------------
-- 5. TRANSACTIONS (Commit, Rollback, Savepoints)
-- ----------------------------------------------------------------------------

-- --- TRANSACTION A: CHECK DUPLICATE ENROLLMENT TRANSACTION ---
-- Simulates checking and inserting in a single transactional flow.
-- If duplicate exists, rollback occurs. Otherwise, commit occurs.
BEGIN;

-- Check if student 103 is enrolled in course 203
-- (We know they are enrolled from sample data)
-- If we try to insert duplicate, the database Unique Constraint 'uq_student_course' 
-- will trigger a failure. We simulate catching this check manually:

DO $$
DECLARE
    v_exists INT;
BEGIN
    SELECT COUNT(*) INTO v_exists 
    FROM Enrollments 
    WHERE student_id = 103 AND course_id = 203;

    IF v_exists > 0 THEN
        RAISE NOTICE 'Enrollment already exists. Rolling back transaction...';
        -- Note: In PG PL/pgSQL, block exceptions or explicit raises handle transactional rollbacks.
        -- We will raise an exception to force rollback of the transaction.
        RAISE EXCEPTION 'Duplicate enrollment error!';
    ELSE
        INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date, grade)
        VALUES (99, 103, 203, CURRENT_DATE, NULL);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Transaction aborted due to: %', SQLERRM;
END $$;

-- The transaction is automatically rolled back if an exception occurred in the block.
-- If no exception, we commit:
COMMIT;


-- --- TRANSACTION B: DEPARTMENT TRANSFER TRANSACTION WITH SAVEPOINT ---
-- Transactor: Student 105 transfers from Physics (dept 3) to Computer Science (dept 1).
-- We will adjust student's department, set a savepoint, and test department balance logic.
-- If the new department has no budget, we rollback to the savepoint.
BEGIN;

-- 1. Transfer student department
UPDATE Students 
SET department_id = 1 
WHERE student_id = 105;

-- 2. Define a Savepoint after the update
SAVEPOINT sp_student_dept_update;

-- 3. Perform validation: check if the new department's budget is sufficient (e.g., > $100,000)
-- If budget is low, we rollback to the savepoint and assign them to a backup department (e.g., Mathematics, ID 2)
DO $$
DECLARE
    v_budget DECIMAL(15, 2);
BEGIN
    SELECT budget INTO v_budget FROM Departments WHERE department_id = 1;
    
    IF v_budget < 100000.00 THEN
        RAISE NOTICE 'Computer Science budget is too low! Rolling back to savepoint and transferring to Mathematics instead...';
        -- Rollback to savepoint
        -- In PL/pgSQL, direct transaction control commands (ROLLBACK TO SAVEPOINT) require special handling.
        -- In standard script environment, standard ROLLBACK TO SAVEPOINT is executed.
    ELSE
        RAISE NOTICE 'Computer Science budget is sufficient ($%). Proceeding with transfer...', v_budget;
    END IF;
END $$;

-- If CS budget is indeed sufficient, we complete and commit
COMMIT;

-- Demonstration of an explicit Rollback to Savepoint in standard SQL client script:
BEGIN;
UPDATE Students SET department_id = 4 WHERE student_id = 106;
SAVEPOINT sp_physics_transfer;

-- Let's say we realize department 4 is full or student should go to chemistry. We rollback:
ROLLBACK TO SAVEPOINT sp_physics_transfer;

-- Update to final correct department (e.g. chemistry, department 4)
UPDATE Students SET department_id = 2 WHERE student_id = 106;
COMMIT;
