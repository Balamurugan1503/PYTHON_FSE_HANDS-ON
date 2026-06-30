from datetime import date

from sqlalchemy.orm import joinedload

from database import SessionLocal
from models import Department
from models import Student
from models import Course
from models import Enrollment

session = SessionLocal()

# Insert Departments

cs = Department(
    dept_name="Computer Science",
    head_of_dept="Dr. Ramesh",
    budget=850000
)

ec = Department(
    dept_name="Electronics",
    head_of_dept="Dr. Priya",
    budget=620000
)

me = Department(
    dept_name="Mechanical",
    head_of_dept="Dr. Suresh",
    budget=540000
)

session.add_all([cs, ec, me])
session.commit()

# Insert Students

students = [

Student(
first_name="Arjun",
last_name="Mehta",
email="arjun@gmail.com",
date_of_birth=date(2003,4,12),
department=cs,
enrollment_year=2022
),

Student(
first_name="Priya",
last_name="Suresh",
email="priya@gmail.com",
date_of_birth=date(2003,7,25),
department=cs,
enrollment_year=2022
),

Student(
first_name="Rohan",
last_name="Verma",
email="rohan@gmail.com",
date_of_birth=date(2002,11,8),
department=ec,
enrollment_year=2021
),

Student(
first_name="Sneha",
last_name="Patel",
email="sneha@gmail.com",
date_of_birth=date(2004,1,30),
department=me,
enrollment_year=2023
),

Student(
first_name="Balamurugan",
last_name="Gnanasekaran",
email="bala@gmail.com",
date_of_birth=date(2003,5,15),
department=cs,
enrollment_year=2022
)

]

session.add_all(students)
session.commit()

# Insert Courses

courses = [

Course(
course_name="Data Structures",
course_code="CS101",
credits=4,
department=cs
),

Course(
course_name="DBMS",
course_code="CS102",
credits=3,
department=cs
),

Course(
course_name="Circuit Theory",
course_code="EC101",
credits=3,
department=ec
)

]

session.add_all(courses)
session.commit()

# Insert Enrollments

records = [

Enrollment(
student=students[0],
course=courses[0],
enrollment_date=date.today(),
grade="A"
),

Enrollment(
student=students[1],
course=courses[0],
enrollment_date=date.today(),
grade="B"
),

Enrollment(
student=students[2],
course=courses[2],
enrollment_date=date.today(),
grade="A"
),

Enrollment(
student=students[4],
course=courses[1],
enrollment_date=date.today(),
grade="A"
)

]

session.add_all(records)
session.commit()

# Read Students from Computer Science

print("\nComputer Science Students\n")

result = (
session.query(Student)
.join(Department)
.filter(Department.dept_name == "Computer Science")
.all()
)

for student in result:
    print(student.first_name, student.last_name)

# N+1 Version

print("\nWithout joinedload\n")

records = session.query(Enrollment).all()

for record in records:
    print(
        record.student.first_name,
        record.course.course_name
    )

# joinedload Version

print("\nUsing joinedload\n")

records = (
session.query(Enrollment)
.options(
joinedload(Enrollment.student),
joinedload(Enrollment.course)
)
.all()
)

for record in records:
    print(
        record.student.first_name,
        record.course.course_name
    )

# Update

student = (
session.query(Student)
.filter(Student.email == "bala@gmail.com")
.first()
)

student.enrollment_year = 2024

session.commit()

print("\nStudent Updated")

# Delete

record = session.query(Enrollment).first()

session.delete(record)

session.commit()

print("Enrollment Deleted")

session.close()