-- queries.sql: 10 business questions on the school database
-- Run in DB Browser for SQLite (Execute SQL tab). Each query is separate.

-- 1. List every student with their class name.
SELECT s.name, c.class_name
FROM students s
JOIN classes c ON s.class_id = c.class_id
ORDER BY c.class_name, s.name;

-- 2. How many students are in each class?
SELECT c.class_name, COUNT(*) AS total_students
FROM students s
JOIN classes c ON s.class_id = c.class_id
GROUP BY c.class_name;

-- 3. Average score per subject in Term 2.
SELECT subject, ROUND(AVG(score), 1) AS avg_score
FROM marks
WHERE exam_name = 'Term 2'
GROUP BY subject
ORDER BY avg_score DESC;

-- 4. Pass rate per class in Term 2 (a subject score of 40 or more is a pass).
SELECT c.class_name,
       ROUND(100.0 * SUM(CASE WHEN m.score >= 40 THEN 1 ELSE 0 END) / COUNT(*), 1) AS pass_rate_pct
FROM marks m
JOIN students s ON m.student_id = s.student_id
JOIN classes c  ON s.class_id = c.class_id
WHERE m.exam_name = 'Term 2'
GROUP BY c.class_name
ORDER BY pass_rate_pct DESC;

-- 5. Students with attendance below 75% in October 2026.
SELECT s.name, c.class_name,
       ROUND(100.0 * SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attendance_pct
FROM attendance a
JOIN students s ON a.student_id = s.student_id
JOIN classes c  ON s.class_id = c.class_id
GROUP BY s.student_id
HAVING attendance_pct < 75
ORDER BY attendance_pct;

-- 6. Each student's total Term 2 score and overall average (subquery in FROM).
SELECT s.name, t.total_score, t.avg_score
FROM (
  SELECT student_id, SUM(score) AS total_score, ROUND(AVG(score), 1) AS avg_score
  FROM marks
  WHERE exam_name = 'Term 2'
  GROUP BY student_id
) t
JOIN students s ON s.student_id = t.student_id
ORDER BY t.total_score DESC;

-- 7. Top 3 students per class by Term 2 total (CTE + window function).
WITH totals AS (
  SELECT s.student_id, s.name, c.class_name, SUM(m.score) AS total_score
  FROM marks m
  JOIN students s ON m.student_id = s.student_id
  JOIN classes c  ON s.class_id = c.class_id
  WHERE m.exam_name = 'Term 2'
  GROUP BY s.student_id
),
ranked AS (
  SELECT *, RANK() OVER (PARTITION BY class_name ORDER BY total_score DESC) AS rnk
  FROM totals
)
SELECT class_name, rnk, name, total_score
FROM ranked
WHERE rnk <= 3
ORDER BY class_name, rnk;

-- 8. Improvement from Term 1 to Term 2 per student (conditional aggregation).
SELECT s.name,
       ROUND(AVG(CASE WHEN m.exam_name = 'Term 1' THEN m.score END), 1) AS term1_avg,
       ROUND(AVG(CASE WHEN m.exam_name = 'Term 2' THEN m.score END), 1) AS term2_avg,
       ROUND(AVG(CASE WHEN m.exam_name = 'Term 2' THEN m.score END)
           - AVG(CASE WHEN m.exam_name = 'Term 1' THEN m.score END), 1) AS change
FROM marks m
JOIN students s ON m.student_id = s.student_id
GROUP BY s.student_id
ORDER BY change DESC;

-- 9. Class teacher with the highest class average in Term 2.
SELECT c.class_name, t.name AS class_teacher, ROUND(AVG(m.score), 1) AS class_avg
FROM marks m
JOIN students s ON m.student_id = s.student_id
JOIN classes c  ON s.class_id = c.class_id
JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE m.exam_name = 'Term 2'
GROUP BY c.class_id
ORDER BY class_avg DESC;

-- 10. Do low-attendance students score lower? (CTEs joined together)
WITH att AS (
  SELECT student_id,
         100.0 * SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) / COUNT(*) AS att_pct
  FROM attendance
  GROUP BY student_id
),
sc AS (
  SELECT student_id, AVG(score) AS avg_score
  FROM marks
  WHERE exam_name = 'Term 2'
  GROUP BY student_id
)
SELECT CASE WHEN att.att_pct < 75 THEN 'Below 75%' ELSE '75% or above' END AS attendance_group,
       COUNT(*) AS students,
       ROUND(AVG(sc.avg_score), 1) AS avg_term2_score
FROM att
JOIN sc ON att.student_id = sc.student_id
GROUP BY attendance_group;
