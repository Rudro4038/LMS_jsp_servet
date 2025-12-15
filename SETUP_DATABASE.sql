-- =====================================================
-- WebLab Course Management System - SQL Setup Script
-- Database: weblab (or your configured database)
-- =====================================================

-- =====================================================
-- STEP 1: Create Courses Table (for R-3)
-- =====================================================
CREATE TABLE IF NOT EXISTS courses (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  teacher_id INT NOT NULL,
  capacity INT DEFAULT 50,
  created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('active', 'inactive') DEFAULT 'active',
  FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_teacher_id (teacher_id),
  INDEX idx_status (status)
);

-- =====================================================
-- STEP 2: Create Enrollments Table (for R-4, R-5)
-- =====================================================
CREATE TABLE IF NOT EXISTS enrollments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('enrolled', 'dropped', 'completed') DEFAULT 'enrolled',
  FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE KEY unique_enrollment (student_id, course_id),
  INDEX idx_student_id (student_id),
  INDEX idx_course_id (course_id),
  INDEX idx_status (status)
);

-- =====================================================
-- STEP 3: Verify Tables Created
-- =====================================================
-- Run these to verify:
-- SHOW TABLES LIKE 'courses';
-- SHOW TABLES LIKE 'enrollments';
-- DESCRIBE courses;
-- DESCRIBE enrollments;

-- =====================================================
-- STEP 4 (OPTIONAL): Insert Sample Data
-- =====================================================
-- Assuming your existing users table has:
-- ID 706 as teacher user
-- ID 1, 9, 711 as student users

INSERT INTO courses (name, description, teacher_id, capacity) VALUES
('Web Development 101', 'Learn the fundamentals of HTML, CSS, and JavaScript. Build responsive websites from scratch.', 706, 30),
('Database Design', 'Master relational database design, SQL queries, and optimization techniques.', 706, 25),
('Advanced Java', 'Deep dive into Java programming, design patterns, and enterprise application development.', 706, 20);

-- Sample enrollments
INSERT INTO enrollments (student_id, course_id, status) VALUES
(1, 1, 'enrolled'),
(1, 2, 'enrolled'),
(9, 1, 'enrolled'),
(711, 2, 'enrolled'),
(711, 3, 'enrolled');

-- =====================================================
-- STEP 5 (OPTIONAL): Verify Data
-- =====================================================
-- Run these to check:
-- SELECT * FROM courses;
-- SELECT * FROM enrollments;
-- SELECT c.name, u.name as teacher FROM courses c 
--   LEFT JOIN users u ON c.teacher_id = u.id;

-- =====================================================
-- Useful Queries for Testing
-- =====================================================

-- Get all courses taught by teacher ID 706
-- SELECT * FROM courses WHERE teacher_id = 706 AND status = 'active';

-- Get all students in course ID 1
-- SELECT u.id, u.name, u.email, e.enrollment_date 
-- FROM enrollments e 
-- JOIN users u ON e.student_id = u.id 
-- WHERE e.course_id = 1 AND e.status = 'enrolled'
-- ORDER BY e.enrollment_date;

-- Get all courses student ID 1 is enrolled in
-- SELECT c.* FROM courses c 
-- JOIN enrollments e ON c.id = e.course_id 
-- WHERE e.student_id = 1 AND e.status = 'enrolled';

-- Count total enrollments per course
-- SELECT c.id, c.name, COUNT(e.id) as enrolled_count
-- FROM courses c 
-- LEFT JOIN enrollments e ON c.id = e.course_id AND e.status = 'enrolled'
-- GROUP BY c.id, c.name;

-- =====================================================
-- Clean Up (if needed - WARNING: Deletes data!)
-- =====================================================
-- DROP TABLE IF EXISTS enrollments;
-- DROP TABLE IF EXISTS courses;

-- =====================================================
-- End of Setup Script
-- =====================================================
