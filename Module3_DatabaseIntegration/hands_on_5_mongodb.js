// ============================================================================
// COGNIZANT DIGITAL NURTURE 5.0 - MODULE 3: DATABASE INTEGRATION
// HANDS-ON 5: MONGODB DATABASE OPERATIONS, CRUD, AND AGGREGATIONS
// ============================================================================

// Instructions:
// Run these commands inside MongoDB Shell (mongosh) or copy-paste them into
// the MongoDB Compass Shell panel.

// ----------------------------------------------------------------------------
// 1. CREATE/SWITCH DATABASE
// ----------------------------------------------------------------------------
use college_db;

// Clean up existing collections to ensure script repeatability
db.enrollments.drop();
db.professors.drop();
db.courses.drop();
db.students.drop();
db.departments.drop();

// ----------------------------------------------------------------------------
// 2. INSERT SEED DOCUMENTS (10+ documents across collections)
// ----------------------------------------------------------------------------

// Insert Departments
db.departments.insertMany([
  { department_id: 1, dept_name: "Computer Science", head_of_dept: "Dr. Alan Turing", budget: 750000.00 },
  { department_id: 2, dept_name: "Mathematics", head_of_dept: "Dr. Ada Lovelace", budget: 500000.00 },
  { department_id: 3, dept_name: "Physics", head_of_dept: "Dr. Albert Einstein", budget: 600000.00 },
  { department_id: 4, dept_name: "Chemistry", head_of_dept: "Dr. Marie Curie", budget: 450000.00 },
  { department_id: 5, dept_name: "Biology", head_of_dept: "Dr. Charles Darwin", budget: 400000.00 }
]);

// Insert Students (10+ documents: 15 items)
db.students.insertMany([
  { student_id: 101, first_name: "Alice", last_name: "Smith", email: "alice.smith@university.edu", date_of_birth: ISODate("2003-04-12T00:00:00Z"), department_id: 1, enrollment_year: 2024 },
  { student_id: 102, first_name: "Bob", last_name: "Jones", email: "bob.jones@university.edu", date_of_birth: ISODate("2002-09-22T00:00:00Z"), department_id: 1, enrollment_year: 2024 },
  { student_id: 103, first_name: "Charlie", last_name: "Brown", email: "charlie.brown@university.edu", date_of_birth: ISODate("2004-01-15T00:00:00Z"), department_id: 2, enrollment_year: 2025 },
  { student_id: 104, first_name: "David", last_name: "Miller", email: "david.miller@university.edu", date_of_birth: ISODate("2003-11-30T00:00:00Z"), department_id: 2, enrollment_year: 2024 },
  { student_id: 105, first_name: "Emma", last_name: "Wilson", email: "emma.wilson@university.edu", date_of_birth: ISODate("2002-05-18T00:00:00Z"), department_id: 3, enrollment_year: 2023 },
  { student_id: 106, first_name: "Frank", last_name: "Davis", email: "frank.davis@university.edu", date_of_birth: ISODate("2004-07-04T00:00:00Z"), department_id: 3, enrollment_year: 2025 },
  { student_id: 107, first_name: "Grace", last_name: "Thomas", email: "grace.thomas@university.edu", date_of_birth: ISODate("2003-03-25T00:00:00Z"), department_id: 4, enrollment_year: 2024 },
  { student_id: 108, first_name: "Henry", last_name: "White", email: "henry.white@university.edu", date_of_birth: ISODate("2001-12-05T00:00:00Z"), department_id: 4, enrollment_year: 2023 },
  { student_id: 109, first_name: "Ivy", last_name: "Taylor", email: "ivy.taylor@university.edu", date_of_birth: ISODate("2004-08-14T00:00:00Z"), department_id: 5, enrollment_year: 2025 },
  { student_id: 110, first_name: "Jack", last_name: "Anderson", email: "jack.anderson@university.edu", date_of_birth: ISODate("2002-10-10T00:00:00Z"), department_id: 5, enrollment_year: 2024 },
  { student_id: 111, first_name: "Karen", last_name: "Harris", email: "karen.harris@university.edu", date_of_birth: ISODate("2003-06-20T00:00:00Z"), department_id: 1, enrollment_year: 2024 },
  { student_id: 112, first_name: "Leo", last_name: "Martin", email: "leo.martin@university.edu", date_of_birth: ISODate("2004-02-28T00:00:00Z"), department_id: 2, enrollment_year: 2025 },
  { student_id: 113, first_name: "Mia", last_name: "Clark", email: "mia.clark@university.edu", date_of_birth: ISODate("2003-09-17T00:00:00Z"), department_id: 3, enrollment_year: 2024 },
  { student_id: 114, first_name: "Noah", last_name: "Rodriguez", email: "noah.rodriguez@university.edu", date_of_birth: ISODate("2002-07-12T00:00:00Z"), department_id: 4, enrollment_year: 2023 },
  { student_id: 115, first_name: "Olivia", last_name: "Lewis", email: "olivia.lewis@university.edu", date_of_birth: ISODate("2004-11-01T00:00:00Z"), department_id: 5, enrollment_year: 2025 }
]);

// Insert Courses
db.courses.insertMany([
  { course_id: 201, course_name: "Introduction to Computer Science", course_code: "CS-101", credits: 4, department_id: 1, max_seats: 60 },
  { course_id: 202, course_name: "Data Structures and Algorithms", course_code: "CS-201", credits: 4, department_id: 1, max_seats: 45 },
  { course_id: 203, course_name: "Linear Algebra", course_code: "MATH-101", credits: 3, department_id: 2, max_seats: 50 },
  { course_id: 204, course_name: "Calculus II", course_code: "MATH-201", credits: 4, department_id: 2, max_seats: 40 },
  { course_id: 205, course_name: "Classical Mechanics", course_code: "PHYS-101", credits: 4, department_id: 3, max_seats: 30 },
  { course_id: 206, course_name: "Electromagnetism", course_code: "PHYS-201", credits: 4, department_id: 3, max_seats: 25 },
  { course_id: 207, course_name: "General Chemistry I", course_code: "CHEM-101", credits: 3, department_id: 4, max_seats: 40 },
  { course_id: 208, course_name: "Organic Chemistry", course_code: "CHEM-201", credits: 4, department_id: 4, max_seats: 30 },
  { course_id: 209, course_name: "General Biology", course_code: "BIO-101", credits: 3, department_id: 5, max_seats: 50 },
  { course_id: 210, course_name: "Genetics", course_code: "BIO-201", credits: 4, department_id: 5, max_seats: 30 }
]);

// Insert Professors
db.professors.insertMany([
  { professor_id: 301, prof_name: "Dr. Grace Hopper", email: "grace.hopper@university.edu", department_id: 1, salary: 95000 },
  { professor_id: 302, prof_name: "Dr. Richard Feynman", email: "richard.feynman@university.edu", department_id: 3, salary: 98000 },
  { professor_id: 303, prof_name: "Dr. Katherine Johnson", email: "katherine.johnson@university.edu", department_id: 2, salary: 92000 },
  { professor_id: 304, prof_name: "Dr. Linus Pauling", email: "linus.pauling@university.edu", department_id: 4, salary: 88000 },
  { professor_id: 305, prof_name: "Dr. Rosalind Franklin", email: "rosalind.franklin@university.edu", department_id: 5, salary: 89000 },
  { professor_id: 306, prof_name: "Dr. Barbara Liskov", email: "barbara.liskov@university.edu", department_id: 1, salary: 94000 },
  { professor_id: 307, prof_name: "Dr. Carl Friedrich Gauss", email: "carl.gauss@university.edu", department_id: 2, salary: 96000 },
  { professor_id: 308, prof_name: "Dr. Stephen Hawking", email: "stephen.hawking@university.edu", department_id: 3, salary: 99000 },
  { professor_id: 309, prof_name: "Dr. Dorothy Hodgkin", email: "dorothy.hodgkin@university.edu", department_id: 4, salary: 87000 },
  { professor_id: 310, prof_name: "Dr. Gregor Mendel", email: "gregor.mendel@university.edu", department_id: 5, salary: 85000 }
]);

// Insert Enrollments
db.enrollments.insertMany([
  { enrollment_id: 1, student_id: 101, course_id: 201, enrollment_date: ISODate("2024-09-01T00:00:00Z"), grade: "A" },
  { enrollment_id: 2, student_id: 101, course_id: 202, enrollment_date: ISODate("2024-09-01T00:00:00Z"), grade: "B" },
  { enrollment_id: 3, student_id: 102, course_id: 201, enrollment_date: ISODate("2024-09-01T00:00:00Z"), grade: "A" },
  { enrollment_id: 4, student_id: 103, course_id: 203, enrollment_date: ISODate("2025-01-10T00:00:00Z"), grade: "A" },
  { enrollment_id: 5, student_id: 104, course_id: 203, enrollment_date: ISODate("2024-09-01T00:00:00Z"), grade: "C" },
  { enrollment_id: 6, student_id: 105, course_id: 205, enrollment_date: ISODate("2023-09-01T00:00:00Z"), grade: "A" },
  { enrollment_id: 7, student_id: 106, course_id: 205, enrollment_date: ISODate("2025-01-10T00:00:00Z"), grade: "B" },
  { enrollment_id: 8, student_id: 107, course_id: 207, enrollment_date: ISODate("2024-09-01T00:00:00Z"), grade: "A" },
  { enrollment_id: 9, student_id: 108, course_id: 208, enrollment_date: ISODate("2023-09-01T00:00:00Z"), grade: "C" },
  { enrollment_id: 10, student_id: 109, course_id: 209, enrollment_date: ISODate("2025-01-10T00:00:00Z"), grade: "A" }
]);

// ----------------------------------------------------------------------------
// 3. CRUD OPERATIONS
// ----------------------------------------------------------------------------

// CREATE: Insert a new student document
print("1. Executing CREATE operation...");
db.students.insertOne({
  student_id: 119,
  first_name: "Grace",
  last_name: "Hopper",
  email: "grace.hopper.student@university.edu",
  date_of_birth: ISODate("2004-12-09T00:00:00Z"),
  department_id: 1,
  enrollment_year: 2026
});

// READ: Find all students who enrolled in 2024 in department 1
print("2. Executing READ operation...");
db.students.find({ enrollment_year: 2024, department_id: 1 }).pretty();

// UPDATE: Increment budget for "Computer Science" (ID 1) by $50,000 and change head
print("3. Executing UPDATE operation...");
db.departments.updateOne(
  { department_id: 1 },
  { 
    $inc: { budget: 50000.00 },
    $set: { head_of_dept: "Dr. Barbara Liskov" }
  }
);

// DELETE: Delete student 119
print("4. Executing DELETE operation...");
db.students.deleteOne({ student_id: 119 });

// ----------------------------------------------------------------------------
// 4. PROJECTION (Select specific fields, exclude _id)
// ----------------------------------------------------------------------------
print("5. Executing PROJECTION query...");
db.students.find(
  { department_id: 1 }, // query filter
  { first_name: 1, last_name: 1, email: 1, _id: 0 } // projection definition
);

// ----------------------------------------------------------------------------
// 5. AGGREGATION PIPELINE ($lookup, $group, $sort, $unwind)
// ----------------------------------------------------------------------------

// Pipeline A: Calculate Average Professor Salary per Department
// Relates professors to departments, groups by dept name, calculates avg, and sorts.
print("6. Executing AGGREGATION Pipeline A (Department Salaries)...");
db.departments.aggregate([
  {
    $lookup: {
      from: "professors",
      localField: "department_id",
      foreignField: "department_id",
      as: "professors_info"
    }
  },
  {
    $unwind: "$professors_info"
  },
  {
    $group: {
      _id: "$dept_name",
      average_salary: { $avg: "$professors_info.salary" },
      total_salary_budget: { $sum: "$professors_info.salary" },
      professor_count: { $sum: 1 }
    }
  },
  {
    $sort: { average_salary: -1 } // Sort descending
  }
]);

// Pipeline B: Fetch Students and Resolve their Enrollments & Courses
print("7. Executing AGGREGATION Pipeline B (Student Enrollments & Courses)...");
db.students.aggregate([
  {
    $lookup: {
      from: "enrollments",
      localField: "student_id",
      foreignField: "student_id",
      as: "enrollment_list"
    }
  },
  {
    $unwind: {
      path: "$enrollment_list",
      preserveNullAndEmptyArrays: false // Only include students with enrollments
    }
  },
  {
    $lookup: {
      from: "courses",
      localField: "enrollment_list.course_id",
      foreignField: "course_id",
      as: "course_info"
    }
  },
  {
    $unwind: "$course_info"
  },
  {
    $group: {
      _id: { student_id: "$student_id", name: { $concat: ["$first_name", " ", "$last_name"] } },
      courses_taken: {
        $push: {
          course_code: "$course_info.course_code",
          course_name: "$course_info.course_name",
          grade: "$enrollment_list.grade",
          enroll_date: "$enrollment_list.enrollment_date"
        }
      }
    }
  },
  {
    $project: {
      _id: 0,
      student_id: "$_id.student_id",
      student_name: "$_id.name",
      courses_taken: 1
    }
  },
  {
    $sort: { student_id: 1 }
  }
]);

// ----------------------------------------------------------------------------
// 6. INDEXES
// ----------------------------------------------------------------------------

// Single Field Index (Unique) on Student Email
db.students.createIndex({ email: 1 }, { unique: true });

// Compound Index on Students (department_id, enrollment_year)
db.students.createIndex({ department_id: 1, enrollment_year: -1 });

// Check existing indexes on Students collection
print("List of indexes on students collection:");
db.students.getIndexes();

// ----------------------------------------------------------------------------
// 7. EXPLAIN() - QUERY PLAN ANALYSIS
// ----------------------------------------------------------------------------
print("8. Running EXPLAIN plan on query using compound index...");

// Analyzes the query plan to verify the index is utilized (IXSCAN)
db.students.find({ department_id: 1, enrollment_year: 2024 }).explain("executionStats");
