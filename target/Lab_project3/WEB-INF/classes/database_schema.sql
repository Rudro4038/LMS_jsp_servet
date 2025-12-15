-- =============================================
-- WebLab Database Schema
-- =============================================

-- Users Table (already exists)
CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role ENUM('student', 'teacher', 'admin') NOT NULL,
  enrolled_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- NEW: Courses Table
-- =============================================
CREATE TABLE IF NOT EXISTS courses (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  teacher_id INT NOT NULL,
  capacity INT DEFAULT 50,
  created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('active', 'inactive') DEFAULT 'active',
  FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT chk_teacher_role CHECK (1=1)
);

-- =============================================
-- NEW: Course Enrollments Table
-- =============================================
CREATE TABLE IF NOT EXISTS enrollments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('enrolled', 'dropped', 'completed') DEFAULT 'enrolled',
  FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE KEY unique_enrollment (student_id, course_id),
  CONSTRAINT chk_student_role CHECK (1=1)
);

-- =============================================
-- Sample Data (Optional)
-- =============================================

-- Insert sample courses (assuming teacher_id 706 from your test data)
INSERT INTO courses (name, description, teacher_id, capacity) VALUES
('Web Development 101', 'Learn basic web development with HTML, CSS, and JavaScript', 706, 30),
('Database Design', 'Master relational databases and SQL', 706, 25),
('Advanced Java', 'Deep dive into Java programming and design patterns', 706, 20);

-- Insert sample enrollments (students 1, 9, 711 enrolling in courses)
INSERT INTO enrollments (student_id, course_id) VALUES
(1, 1),
(1, 2),
(9, 1),
(711, 2),
(711, 3);

-- =============================================
-- Useful Queries
-- =============================================

-- Get all courses taught by a teacher
-- SELECT * FROM courses WHERE teacher_id = ? AND status = 'active';

-- Get all students enrolled in a course
-- SELECT u.id, u.name, u.email, e.enrollment_date 
-- FROM users u 
-- JOIN enrollments e ON u.id = e.student_id 
-- WHERE e.course_id = ? AND e.status = 'enrolled'
-- ORDER BY e.enrollment_date DESC;

-- Get all courses a student is enrolled in
-- SELECT c.* FROM courses c 
-- JOIN enrollments e ON c.id = e.course_id 
-- WHERE e.student_id = ? AND e.status = 'enrolled'
-- ORDER BY c.created_date DESC;

-- Check if student is already enrolled in a course
-- SELECT * FROM enrollments 
-- WHERE student_id = ? AND course_id = ? AND status = 'enrolled';
