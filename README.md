# school_database_sql
SQL database and queries for school student, class, marks and attendance data.
# School Database SQL Project

A small relational database for a school, with 10 SQL queries that answer
questions a principal or class teacher would ask about performance and attendance.

## Business question
How can a school track student performance and attendance, and spot students who need support?

## Data
Mock data created for practice (no real students). 5 teachers, 5 classes, 30 students,
240 exam scores (4 subjects x 2 terms), 600 attendance records (20 school days in October 2026).

## Tables
| Table | What it holds |
| --- | --- |
| teachers | teacher name and subject |
| classes | class name and class teacher |
| students | name, gender, class |
| marks | score per student, subject and exam (Term 1, Term 2) |
| attendance | Present or Absent per student per day |

## SQL skills used
JOINs (up to 4 tables), GROUP BY and HAVING, CASE WHEN, subqueries,
CTEs, window functions (RANK with PARTITION BY), conditional aggregation.

## Files
- `schema.sql`: creates the tables
- `data.sql`: inserts the mock data
- `queries.sql`: the 10 queries, each with a comment explaining the question
- `school.db`: the ready-made SQLite database

## How to run
1. Open `school.db` in [DB Browser for SQLite](https://sqlitebrowser.org).
2. Go to the **Execute SQL** tab, paste a query from `queries.sql` and run it.
3. To rebuild from scratch, create a new database and run `schema.sql`, then `data.sql`.

## Sample findings (mock data)
- **Pass rate:** classes 9B and 10A had a 100% subject pass rate in Term 2, while 8B had the lowest at 87.5%.
- **Attendance:** 4 of 30 students were below 75% in October, with the lowest at 55%.
- **Top performer:** Arjun Das (10A) had the highest Term 2 total, 388 out of 400.
- **Class performance:** class 10A had the highest Term 2 average (74.3) and 8B the lowest (63.5).
- **Attendance vs scores:** in this mock data, low-attendance students did not score lower (70.3 vs 67.8 average), because the data is random. With real data, this query would show whether absence affects results.

## What I would add next
A Power BI dashboard on this data, and more months of attendance.
