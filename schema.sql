-- schema.sql: tables for the school database (SQLite)
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS marks;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS teachers;

CREATE TABLE teachers (
  teacher_id INTEGER PRIMARY KEY,
  name       TEXT NOT NULL,
  subject    TEXT NOT NULL
);

CREATE TABLE classes (
  class_id   INTEGER PRIMARY KEY,
  class_name TEXT NOT NULL,
  teacher_id INTEGER NOT NULL,          -- class teacher
  FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

CREATE TABLE students (
  student_id INTEGER PRIMARY KEY,
  name       TEXT NOT NULL,
  gender     TEXT CHECK (gender IN ('F','M')),
  class_id   INTEGER NOT NULL,
  FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

CREATE TABLE marks (
  mark_id    INTEGER PRIMARY KEY,
  student_id INTEGER NOT NULL,
  subject    TEXT NOT NULL,
  exam_name  TEXT NOT NULL,
  score      INTEGER CHECK (score BETWEEN 0 AND 100),
  exam_date  TEXT NOT NULL,             -- YYYY-MM-DD
  FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE attendance (
  attendance_id INTEGER PRIMARY KEY,
  student_id    INTEGER NOT NULL,
  date          TEXT NOT NULL,          -- YYYY-MM-DD
  status        TEXT CHECK (status IN ('Present','Absent')),
  FOREIGN KEY (student_id) REFERENCES students(student_id)
);
