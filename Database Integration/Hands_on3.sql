USE college_db;

-- ==========================================
-- Hands-On 3 : Advanced SQL
-- ==========================================


-- ==========================================
-- Task 1 : Subqueries
-- ==========================================

-- 35. Find students who have enrolled in more
-- courses than the average student

SELECT student_id,
       COUNT(course_id) AS total_courses
FROM enrollments
GROUP BY student_id
HAVING COUNT(course_id) >
(
    SELECT AVG(course_count)
    FROM
    (
        SELECT COUNT(*) AS course_count
        FROM enrollments
        GROUP BY student_id
    ) AS avg_table
);


-- ------------------------------------------

-- 36. Display courses where every enrolled
-- student has received Grade A

SELECT c.course_name
FROM courses c
WHERE NOT EXISTS
(
    SELECT 1
    FROM enrollments e
    WHERE e.course_id = c.course_id
      AND e.grade <> 'A'
);


-- ------------------------------------------

-- 37. Find the highest paid professor in
-- each department

SELECT *
FROM professors p
WHERE salary =
(
    SELECT MAX(salary)
    FROM professors
    WHERE department_id = p.department_id
);


-- ------------------------------------------

-- 38. Departments having an average salary
-- greater than 85000

SELECT *
FROM
(
    SELECT department_id,
           AVG(salary) AS avg_salary
    FROM professors
    GROUP BY department_id
) AS dept_salary
WHERE avg_salary > 85000;


-- ==========================================
-- Task 2 : Views
-- ==========================================

-- 39. Create a view showing student details,
-- number of enrolled courses and GPA

CREATE VIEW vw_student_enrollment_summary AS

SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    d.dept_name,
    COUNT(e.course_id) AS total_courses,

    ROUND(
        AVG(
            CASE
                WHEN e.grade = 'A' THEN 4
                WHEN e.grade = 'B' THEN 3
                WHEN e.grade = 'C' THEN 2
                WHEN e.grade = 'D' THEN 1
                ELSE 0
            END
        ),
        2
    ) AS GPA

FROM students s

LEFT JOIN departments d
       ON s.department_id = d.department_id

LEFT JOIN enrollments e
       ON s.student_id = e.student_id

GROUP BY
    s.student_id,
    student_name,
    d.dept_name;


-- ------------------------------------------

-- 40. View containing course statistics

CREATE VIEW vw_course_stats AS

SELECT
    c.course_name,
    c.course_code,
    COUNT(e.student_id) AS total_enrollments,

    ROUND(
        AVG(
            CASE
                WHEN e.grade = 'A' THEN 4
                WHEN e.grade = 'B' THEN 3
                WHEN e.grade = 'C' THEN 2
                WHEN e.grade = 'D' THEN 1
                ELSE 0
            END
        ),
        2
    ) AS avg_gpa

FROM courses c

LEFT JOIN enrollments e
       ON c.course_id = e.course_id

GROUP BY
    c.course_id,
    c.course_name,
    c.course_code;


-- ------------------------------------------

-- 41. Display students whose GPA is above 3

SELECT *
FROM vw_student_enrollment_summary
WHERE GPA > 3;


-- ------------------------------------------

-- 42. Why can't this view be updated?

-- Since this view combines multiple tables
-- using joins and aggregate functions,
-- MySQL generally doesn't allow direct updates.

-- Example

UPDATE vw_student_enrollment_summary
SET student_name = 'Demo'
WHERE student_id = 1;


-- ------------------------------------------

-- 43. Drop existing views

DROP VIEW IF EXISTS vw_student_enrollment_summary;
DROP VIEW IF EXISTS vw_course_stats;


-- Create a simple updatable view

CREATE VIEW vw_student_enrollment_summary AS

SELECT *
FROM students
WHERE enrollment_year >= 2022
WITH CHECK OPTION;


SELECT *
FROM vw_student_enrollment_summary;


-- ==========================================
-- Task 3 : Stored Procedures & Transactions
-- ==========================================


-- Create a log table to record department
-- transfers

CREATE TABLE department_transfer_log
(
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    old_department INT,
    new_department INT,
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ------------------------------------------
-- 44. Procedure to enroll a student
-- ------------------------------------------

DELIMITER $$

CREATE PROCEDURE sp_enroll_student
(
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_date DATE
)

BEGIN

    IF EXISTS
    (
        SELECT 1
        FROM enrollments
        WHERE student_id = p_student_id
          AND course_id = p_course_id
    )

    THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student already enrolled';

    ELSE

        INSERT INTO enrollments
        (
            student_id,
            course_id,
            enrollment_date
        )

        VALUES
        (
            p_student_id,
            p_course_id,
            p_date
        );

    END IF;

END$$

DELIMITER ;


-- Test

CALL sp_enroll_student(3, 2, '2024-07-01');


-- ------------------------------------------
-- 45. Procedure to transfer a student
-- ------------------------------------------

DELIMITER $$

CREATE PROCEDURE sp_transfer_student
(
    IN p_student INT,
    IN p_new_department INT
)

BEGIN

    DECLARE old_dept INT;

    START TRANSACTION;

    SELECT department_id
    INTO old_dept
    FROM students
    WHERE student_id = p_student;

    UPDATE students
    SET department_id = p_new_department
    WHERE student_id = p_student;

    INSERT INTO department_transfer_log
    (
        student_id,
        old_department,
        new_department
    )

    VALUES
    (
        p_student,
        old_dept,
        p_new_department
    );

    COMMIT;

END$$

DELIMITER ;


-- Test

CALL sp_transfer_student(2, 3);


-- ------------------------------------------
-- 46. Rollback Example
-- ------------------------------------------

START TRANSACTION;

UPDATE students
SET department_id = 2
WHERE student_id = 1;

-- Intentional error

INSERT INTO department_transfer_log
(
    student_id,
    old_department,
    new_department
)

VALUES
(
    NULL,
    NULL,
    NULL
);

ROLLBACK;


-- Check whether rollback worked

SELECT *
FROM students
WHERE student_id = 1;


-- ------------------------------------------
-- 47. Savepoint Example
-- ------------------------------------------

START TRANSACTION;

INSERT INTO enrollments
(
    student_id,
    course_id,
    enrollment_date,
    grade
)

VALUES
(
    2,
    5,
    CURDATE(),
    'A'
);

SAVEPOINT first_insert;


-- Invalid student ID to generate an error

INSERT INTO enrollments
(
    student_id,
    course_id,
    enrollment_date,
    grade
)

VALUES
(
    999,
    2,
    CURDATE(),
    'A'
);

ROLLBACK TO first_insert;

COMMIT;


-- Verify the inserted record

SELECT *
FROM enrollments
WHERE student_id = 2;