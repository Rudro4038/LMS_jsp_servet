# WebLab Course Management System - Complete Documentation

## 📋 Overview
Implementation of requirements R-3, R-4, and R-5 with complete database schema, DAOs, servlets, and JSP views.

---

## 🗄️ Database Schema

### Tables Created

#### 1. **courses** Table
```sql
CREATE TABLE courses (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  teacher_id INT NOT NULL,
  capacity INT DEFAULT 50,
  created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('active', 'inactive') DEFAULT 'active',
  FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE CASCADE
);
```

#### 2. **enrollments** Table
```sql
CREATE TABLE enrollments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('enrolled', 'dropped', 'completed') DEFAULT 'enrolled',
  FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE KEY unique_enrollment (student_id, course_id)
);
```

**Key Features:**
- Foreign key relationships maintain data integrity
- CASCADE delete ensures orphaned records don't exist
- UNIQUE constraint prevents duplicate enrollments
- Status tracking for course lifecycle management

---

## 📦 Model Classes

### 1. **Course.java** (Enhanced)
**Location**: `src/main/java/com/weblab/model/Course.java`

**Key Properties:**
- `id` - Unique course identifier
- `name` - Course name
- `description` - Course description
- `teacherId` - Assigned teacher ID
- `capacity` - Maximum enrollment count
- `enrolledCount` - Current enrollment count (calculated from DB)
- `status` - 'active' or 'inactive'
- `createdDate` - Timestamp

**Key Methods:**
- `hasAvailableSeats()` - Check if course has room for enrollment

### 2. **Enrollment.java** (New)
**Location**: `src/main/java/com/weblab/model/Enrollment.java`

**Key Properties:**
- `id` - Enrollment ID
- `studentId` - Student user ID
- `courseId` - Course ID
- `enrollmentDate` - When student enrolled
- `status` - Enrollment status

---

## 🔧 Data Access Objects (DAOs)

### **CourseDAO.java** (Completely Rewritten)
**Location**: `src/main/java/com/weblab/dao/CourseDAO.java`

#### **Admin Methods (R-3)**
- `addCourse(String name, String description, int teacherId, int capacity)` → Adds new course
- `getAllCourses()` → View all courses with enrollment stats
- `getCourseById(int courseId)` → Get course details

#### **Teacher Methods (R-4, R-5)**
- `getCoursesByTeacher(int teacherId)` → Get all courses taught by teacher
- `getStudentsByCourse(int courseId, int teacherId)` → Get enrolled students in a course (R-5)

#### **Student Methods**
- `getStudentEnrolledCourses(int studentId)` → Get courses student is enrolled in
- `getAvailableCoursesForStudent(int studentId)` → Get courses available for enrollment
- `enrollStudentInCourse(int studentId, int courseId)` → Enroll student
- `dropCourse(int studentId, int courseId)` → Drop a course
- `isStudentEnrolled(int studentId, int courseId)` → Check enrollment status

---

## 🎯 Requirements Implementation

### **R-3: Admin Course Management**
**File**: `AdminCoursesServlet.java`
**Endpoint**: `/admin/courses`

**Functionality:**
- Add new courses with:
  - Course name (required)
  - Description (optional)
  - Teacher assignment (required)
  - Student capacity (1-500)
- View all courses with:
  - Enrollment statistics
  - Teacher information
  - Course status

**JSP Views:**
- `/WEB-INF/views/admin/add_course.jsp` - Form to add new course
- `/WEB-INF/views/admin/view_courses.jsp` - Display all courses

**Usage:**
```
1. Navigate to: /admin/courses
2. Click "Add New Course"
3. Fill in course details
4. Assign teacher by ID
5. Submit to create course
```

---

### **R-4: Teacher View Courses**
**File**: `TeacherCoursesServlet.java`
**Endpoint**: `/teacher/courses`

**Functionality:**
- View all courses assigned to the teacher
- See enrollment statistics for each course
- Quick navigation to view students

**JSP Views:**
- `/WEB-INF/views/teacher/view_courses.jsp` - List of teacher's courses

**Features:**
- Responsive table layout
- Real-time enrollment counts
- One-click access to student list

**Usage:**
```
1. Navigate to: /teacher/courses
2. See all assigned courses
3. Click "View Students" to see enrolled students
```

---

### **R-5: Teacher View Course Students**
**File**: `TeacherCoursesServlet.java`
**Endpoint**: `/teacher/courses?action=viewStudents&courseId={courseId}`

**Functionality:**
- View all students enrolled in a specific course
- Display student details:
  - Student name
  - Email address
  - Enrollment date
  - Enrollment status

**JSP Views:**
- `/WEB-INF/views/teacher/view_students.jsp` - Student enrollment list

**Security:**
- Verifies teacher owns the course
- Prevents unauthorized access

**Usage:**
```
1. From teacher's course list
2. Click "View Students" for any course
3. See enrolled students with details
```

---

## 👨‍🎓 Student Course Management

### **Servlet**: `StudentCoursesServlet.java`
**Endpoint**: `/student/courses`

**Functionality:**
- Browse available courses for enrollment
- View enrolled courses
- Enroll in courses (with capacity check)
- Drop courses

**JSP Views:**
- `/WEB-INF/views/student/view_courses.jsp` - Course browser and enrollment

**Features:**
- Tab interface for available/enrolled courses
- Progress bar showing course capacity
- One-click enroll/drop functionality
- Confirmation dialogs for destructive actions

---

## 📊 Database Queries

### Get all courses taught by a teacher
```sql
SELECT c.*, u.name as teacher_name, 
       (SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.id AND e.status = 'enrolled') as enrolled_count 
FROM courses c 
LEFT JOIN users u ON c.teacher_id = u.id 
WHERE c.teacher_id = ? AND c.status = 'active'
ORDER BY c.created_date DESC
```

### Get all students in a course
```sql
SELECT e.id, e.student_id, u.name as student_name, u.email, e.enrollment_date, e.status 
FROM enrollments e 
JOIN users u ON e.student_id = u.id 
WHERE e.course_id = ? AND e.status = 'enrolled'
ORDER BY e.enrollment_date DESC
```

### Get courses a student is enrolled in
```sql
SELECT c.* FROM courses c 
JOIN enrollments e ON c.id = e.course_id 
WHERE e.student_id = ? AND e.status = 'enrolled' AND c.status = 'active'
```

---

## 🔒 Security Features

1. **Authentication Check** - All servlets verify user session
2. **Role Verification** - Ensures users access only allowed actions
3. **Authorization** - Teachers can only see their own courses
4. **Data Validation** - Input sanitization and validation
5. **SQL Injection Prevention** - Prepared statements throughout
6. **Capacity Validation** - Prevents over-enrollment

---

## 🧪 Test Data

Run the included SQL script to populate test data:

```sql
-- Admin Course Creation Test
INSERT INTO courses (name, description, teacher_id, capacity) VALUES
('Web Development 101', 'Learn basic web development with HTML, CSS, and JavaScript', 706, 30),
('Database Design', 'Master relational databases and SQL', 706, 25),
('Advanced Java', 'Deep dive into Java programming and design patterns', 706, 20);

-- Student Enrollments Test
INSERT INTO enrollments (student_id, course_id) VALUES
(1, 1),   -- Robin enrolls in Web Dev
(1, 2),   -- Robin enrolls in Database Design
(9, 1),   -- adsfasd enrolls in Web Dev
(711, 2), -- asd enrolls in Database Design
(711, 3); -- asd enrolls in Advanced Java
```

### Test Scenarios

**Admin (id: any admin):
1. Add course "Python Basics" taught by teacher 706
2. View all courses
3. Verify enrollment counts

**Teacher (id: 706):**
1. Login as teacher
2. View courses taught (Web Dev 101, Database Design, Advanced Java)
3. Click each course to see enrolled students
4. Verify student list displays correctly

**Student (id: 1):**
1. Login as student
2. Browse available courses
3. Enroll in "Web Development 101"
4. View enrolled courses
5. Drop a course

---

## 🚀 Deployment Checklist

- [ ] Create `courses` table via SQL script
- [ ] Create `enrollments` table via SQL script
- [ ] Compile Java code: `mvn clean compile`
- [ ] Deploy: `mvn clean install`
- [ ] Insert sample data (optional)
- [ ] Test admin: Add a course
- [ ] Test teacher: View courses and students
- [ ] Test student: Enroll in a course

---

## 📝 File Summary

| File | Purpose | Requirement |
|------|---------|-------------|
| `database_schema.sql` | Database table definitions | Setup |
| `Course.java` | Course model (enhanced) | All |
| `Enrollment.java` | Enrollment model | All |
| `CourseDAO.java` | Database operations | All |
| `AdminCoursesServlet.java` | Admin course management | R-3 |
| `TeacherCoursesServlet.java` | Teacher course viewing | R-4, R-5 |
| `StudentCoursesServlet.java` | Student enrollment | General |
| `add_course.jsp` | Admin form | R-3 |
| `view_courses.jsp` (admin) | Admin course list | R-3 |
| `view_courses.jsp` (teacher) | Teacher course list | R-4 |
| `view_students.jsp` | Student list for course | R-5 |
| `view_courses.jsp` (student) | Course browser | General |

---

## 🔗 URL Mapping

| URL | Role | Purpose |
|-----|------|---------|
| `/admin/courses` | Admin | Add courses (default) |
| `/admin/courses?action=view` | Admin | View all courses |
| `/teacher/courses` | Teacher | View taught courses (R-4) |
| `/teacher/courses?action=viewStudents&courseId={id}` | Teacher | View course students (R-5) |
| `/student/courses` | Student | Browse available courses |
| `/student/courses?action=enrolled` | Student | View enrolled courses |

---

## 💡 Key Features

✅ Complete course lifecycle management
✅ Role-based access control
✅ Real-time enrollment tracking
✅ Capacity management
✅ Prevent duplicate enrollments
✅ Responsive Bootstrap UI
✅ Error handling & validation
✅ Database integrity with constraints

---

## 🎓 Assignment Requirements Fulfillment

- **R-3**: ✅ Admin adds courses and assigns teachers
- **R-4**: ✅ Teacher registers (views) for courses and views all registered courses
- **R-5**: ✅ Teacher selects a course and views all registered students

All requirements implemented with professional UI and complete functionality.
