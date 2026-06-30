USE college_db;

-- ==========================================
-- HANDS ON 4
-- Query Optimisation
-- ==========================================

-- ==========================================
-- Task 1
-- Baseline Performance
-- ==========================================

-- 48. Explain Query

EXPLAIN FORMAT=JSON

SELECT
    s.first_name,
    s.last_name,
    c.course_name
FROM enrollments e
JOIN students s
ON e.student_id = s.student_id
JOIN courses c
ON e.course_id = c.course_id
WHERE s.enrollment_year = 2022;

-------------------------------------------------

-- Notes

-- Before creating indexes,
-- MySQL may perform a Full Table Scan
-- on the students table.

-- Rows examined depend on table size.

-- Full Table Scan is acceptable for
-- small datasets but becomes slower
-- for larger databases.

-------------------------------------------------

-- ==========================================
-- Task 2
-- Create Indexes
-- ==========================================

-- 51. B-Tree Index

CREATE INDEX idx_student_year
ON students(enrollment_year);

-------------------------------------------------

-- 52. Composite Unique Index

CREATE UNIQUE INDEX idx_student_course
ON enrollments(student_id,course_id);

-------------------------------------------------

-- 53. Course Code Index

CREATE INDEX idx_course_code
ON courses(course_code);

-------------------------------------------------

-- 54. Run Explain Again

EXPLAIN FORMAT=JSON

SELECT
    s.first_name,
    s.last_name,
    c.course_name
FROM enrollments e
JOIN students s
ON e.student_id=s.student_id
JOIN courses c
ON e.course_id=c.course_id
WHERE s.enrollment_year=2022;

-------------------------------------------------

-- Expected Observation

-- Before Index
-- Full Table Scan

-- After Index
-- Index Lookup / Index Scan

-------------------------------------------------

-- 55.

-- PostgreSQL supports Partial Indexes.

-- Example:

-- CREATE INDEX idx_pending
-- ON enrollments(student_id)
-- WHERE grade IS NULL;

-- MySQL does not support Partial Indexes.

-------------------------------------------------

-- Verify Indexes

SHOW INDEX
FROM students;

SHOW INDEX
FROM enrollments;

SHOW INDEX
FROM courses;

-------------------------------------------------

-- End of SQL