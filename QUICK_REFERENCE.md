# Course Management System - Quick Reference Guide

## 🚀 Getting Started

### 1. Database Setup
Execute this SQL in your MySQL database:
```sql
-- Run the database_schema.sql file located in src/main/resources/
```

### 2. Compile & Deploy
```bash
mvn clean compile
mvn clean install
```

### 3. Access the Application
- Base URL: `http://localhost:8080/Lab_project3/`

---

## 📱 User Workflows

### ADMIN WORKFLOW (R-3)

```
1. Login → admin@example.com / password / admin role
2. Navigate → /admin/courses
3. Click "Add New Course"
4. Fill Form:
   - Course Name: "Web Development 101"
   - Description: "Learn HTML, CSS, JavaScript"
   - Teacher ID: 706
   - Capacity: 30
5. Submit → Course Created
6. View All → Click "View All Courses"
```

**Page Screenshots:**
- `/admin/courses` - Default (add course form)
- `/admin/courses?action=view` - View all courses

---

### TEACHER WORKFLOW (R-4 & R-5)

#### View My Courses (R-4)
```
1. Login → teacher@example.com / password / teacher role
2. Navigate → /teacher/courses
3. See Table:
   ┌─────────────────────────────┐
   │ Course Name │ Students │ ... │
   └─────────────────────────────┘
4. Each course shows:
   - Name
   - Description
   - Enrolled/Capacity
   - "View Students" button
```

#### View Course Students (R-5)
```
1. From /teacher/courses
2. Click "View Students" on any course
3. See Student Table:
   ┌─────────────────────────────────────┐
   │ Student Name │ Email │ Enrollment Date │
   └─────────────────────────────────────┘
4. Track enrollments and dates
```

---

### STUDENT WORKFLOW

#### Browse Available Courses
```
1. Login → student@example.com / password / student role
2. Navigate → /student/courses
3. See Available Courses Tab with:
   - Course cards
   - Teacher name
   - Enrollment progress bar
   - "Enroll" button
4. Click "Enroll" → Student added to course
```

#### View Enrolled Courses
```
1. From /student/courses
2. Click "My Enrolled Courses" tab
3. See courses with:
   - Course details
   - "Drop Course" button (if needed)
```

---

## 🎯 Method Reference

### CourseDAO Methods

| Method | Purpose | Parameters | Returns |
|--------|---------|-----------|---------|
| `addCourse()` | Create new course | name, description, teacherId, capacity | boolean |
| `getAllCourses()` | Get all active courses | none | List<Course> |
| `getCourseById()` | Get course details | courseId | Course |
| `getCoursesByTeacher()` | Get teacher's courses | teacherId | List<Course> |
| `getStudentsByCourse()` | Get enrolled students | courseId, teacherId | List<Enrollment> |
| `getStudentEnrolledCourses()` | Get student's courses | studentId | List<Course> |
| `getAvailableCoursesForStudent()` | Browse courses | studentId | List<Course> |
| `enrollStudentInCourse()` | Enroll student | studentId, courseId | boolean |
| `dropCourse()` | Drop a course | studentId, courseId | boolean |

---

## 📊 Database Schema Quick View

### Courses Table
```
id          | name              | description      | teacher_id | capacity | status
1           | Web Development   | HTML, CSS, JS... | 706        | 30       | active
2           | Database Design   | SQL & Databases  | 706        | 25       | active
```

### Enrollments Table
```
id | student_id | course_id | enrollment_date | status
1  | 1          | 1         | 2025-12-15      | enrolled
2  | 1          | 2         | 2025-12-15      | enrolled
```

---

## 🔐 Security Notes

✅ **Session Validation** - All pages check if user is logged in
✅ **Role Check** - Admin can only access admin pages
✅ **Input Validation** - All fields validated on server
✅ **SQL Injection Prevention** - PreparedStatements used everywhere
✅ **Capacity Check** - Can't enroll if course is full
✅ **Duplicate Prevention** - Same student can't enroll twice

---

## ⚠️ Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| "Course not found" | Invalid course ID | Check course exists |
| "Invalid Teacher ID" | Teacher doesn't exist | Verify teacher user ID |
| "Course is full" | No available seats | Choose different course |
| "Already enrolled" | Student already in course | Check enrolled courses |
| "Unauthorized access" | Wrong role for action | Check user role |

---

## 🧪 Sample Test Data

### Setup (Run in MySQL)
```sql
-- Add sample courses
INSERT INTO courses (name, description, teacher_id, capacity) VALUES
('Web Development 101', 'Learn web basics', 706, 30),
('Database Design', 'SQL and databases', 706, 25);

-- Add sample enrollments
INSERT INTO enrollments (student_id, course_id) VALUES
(1, 1),
(1, 2),
(9, 1),
(711, 2);
```

### Test Credentials
| Role | Email | Password | ID |
|------|-------|----------|-----|
| Admin | any admin | any pass | 1+ |
| Teacher | k@gmail.com | adf | 706 |
| Student | robindey4038@gmail.com | 123 | 1 |
| Student | afdsad@gmail.com | adfasd | 9 |
| Student | ad@gmail.com | 123 | 711 |

---

## 🔧 Configuration Files

No additional configuration needed! The system uses:
- Existing `DatabaseConnection.java` for DB access
- Existing user authentication system
- Bootstrap CSS already in project

---

## 📋 Checklist for Submission

- [ ] Database tables created (`courses` & `enrollments`)
- [ ] Sample data inserted
- [ ] Code compiles without errors: `mvn clean compile`
- [ ] Application deploys: `mvn clean install`
- [ ] Admin can add courses (R-3)
- [ ] Teacher can view courses (R-4)
- [ ] Teacher can view students in course (R-5)
- [ ] Student can browse and enroll in courses
- [ ] All error messages display correctly
- [ ] UI is responsive on different screen sizes

---

## 🎬 Demo Flow (5 minutes)

1. **Admin Demo** (1 min)
   - Login as admin
   - Add a course "Advanced Python"
   - Show all courses list

2. **Teacher Demo** (2 min)
   - Login as teacher
   - Show "My Courses" page
   - Click "View Students" to show enrollment list

3. **Student Demo** (2 min)
   - Login as student
   - Browse available courses
   - Enroll in a course
   - Show enrolled courses

---

## 📞 Troubleshooting

**Problem**: "User not found" error
- **Solution**: Verify user exists in `users` table with correct role

**Problem**: Cannot enroll in course
- **Solution**: Check if course is full or student already enrolled

**Problem**: Teacher ID not recognized
- **Solution**: Verify teacher user ID exists and has "teacher" role

**Problem**: Pages show 403/404
- **Solution**: Check user role matches servlet expectations

---

## 📚 Complete File Structure

```
Lab_project3/
├── src/main/java/com/weblab/
│   ├── model/
│   │   ├── User.java
│   │   ├── Course.java (⭐ Enhanced)
│   │   └── Enrollment.java (⭐ New)
│   ├── dao/
│   │   ├── AuthDAO.java
│   │   └── CourseDAO.java (⭐ Rewritten)
│   └── controllers/
│       ├── AdminCoursesServlet.java (⭐ New - R-3)
│       ├── TeacherCoursesServlet.java (⭐ New - R-4, R-5)
│       └── StudentCoursesServlet.java (⭐ New)
├── src/main/webapp/
│   └── WEB-INF/views/
│       ├── admin/
│       │   ├── add_course.jsp (⭐ New - R-3)
│       │   └── view_courses.jsp (⭐ New - R-3)
│       ├── teacher/
│       │   ├── view_courses.jsp (⭐ New - R-4)
│       │   └── view_students.jsp (⭐ New - R-5)
│       └── student/
│           └── view_courses.jsp (⭐ New)
└── src/main/resources/
    └── database_schema.sql (⭐ New - Setup)
```

---

**✅ All R-3, R-4, R-5 requirements implemented with professional UI and complete documentation!**
