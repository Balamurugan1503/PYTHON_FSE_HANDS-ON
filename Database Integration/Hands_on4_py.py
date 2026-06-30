import mysql.connector
import time

connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="###########",
    database="college_db"
)

cursor = connection.cursor()

print("Version 1 : N+1 Query")

start = time.time()

cursor.execute("SELECT * FROM enrollments")

enrollments = cursor.fetchall()

query_count = 1

for row in enrollments:

    student_id = row[1]

    cursor.execute(
        "SELECT first_name,last_name FROM students WHERE student_id=%s",
        (student_id,)
    )

    print(cursor.fetchone())

    query_count += 1

end = time.time()

print("\nQueries Executed :", query_count)
print("Execution Time :", round(end-start,5), "seconds")

print("\n-------------------------------")

print("Version 2 : JOIN Query")

start = time.time()

cursor.execute("""

SELECT
s.first_name,
s.last_name,
c.course_name,
e.grade

FROM enrollments e

JOIN students s
ON e.student_id=s.student_id

JOIN courses c
ON e.course_id=c.course_id

""")

rows = cursor.fetchall()

for row in rows:
    print(row)

end = time.time()

print("\nQueries Executed : 1")
print("Execution Time :", round(end-start,5), "seconds")

cursor.close()
connection.close()