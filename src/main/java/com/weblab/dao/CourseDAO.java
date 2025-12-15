package com.weblab.dao;

import com.weblab.model.Course;
import com.weblab.model.Enrollment;
import com.weblab.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    // ==================== ADMIN OPERATIONS ====================

    /**
     * Add a new course (Admin only)
     */
    public boolean addCourse(String name, String description, int teacherId, int capacity) {
        String sql = "INSERT INTO courses (name, description, teacher_id, capacity, status) VALUES (?, ?, ?, ?, 'active')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            stmt.setString(2, description);
            stmt.setInt(3, teacherId);
            stmt.setInt(4, capacity);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("✓ Course added successfully: " + name);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("ERROR in addCourse: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all courses for admin dashboard
     */
    public List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, u.name as teacher_name, " +
                     "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.id AND e.status = 'enrolled') as enrolled_count " +
                     "FROM courses c " +
                     "LEFT JOIN users u ON c.teacher_id = u.id " +
                     "WHERE c.status = 'active' " +
                     "ORDER BY c.created_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Course course = new Course(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getInt("teacher_id"),
                        rs.getInt("capacity"),
                        rs.getTimestamp("created_date"),
                        rs.getString("status")
                );
                course.setTeacherName(rs.getString("teacher_name"));
                course.setEnrolledCount(rs.getInt("enrolled_count"));
                courses.add(course);
            }
        } catch (SQLException e) {
            System.err.println("ERROR in getAllCourses: " + e.getMessage());
            e.printStackTrace();
        }
        return courses;
    }

    /**
     * Get course by ID
     */
    public Course getCourseById(int courseId) {
        String sql = "SELECT c.*, u.name as teacher_name, " +
                     "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.id AND e.status = 'enrolled') as enrolled_count " +
                     "FROM courses c " +
                     "LEFT JOIN users u ON c.teacher_id = u.id " +
                     "WHERE c.id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Course course = new Course(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getInt("teacher_id"),
                            rs.getInt("capacity"),
                            rs.getTimestamp("created_date"),
                            rs.getString("status")
                    );
                    course.setTeacherName(rs.getString("teacher_name"));
                    course.setEnrolledCount(rs.getInt("enrolled_count"));
                    return course;
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR in getCourseById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // ==================== TEACHER OPERATIONS ====================

    /**
     * Get all courses taught by a teacher (R-4)
     */
    public List<Course> getCoursesByTeacher(int teacherId) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, u.name as teacher_name, " +
                     "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.id AND e.status = 'enrolled') as enrolled_count " +
                     "FROM courses c " +
                     "LEFT JOIN users u ON c.teacher_id = u.id " +
                     "WHERE c.teacher_id = ? AND c.status = 'active' " +
                     "ORDER BY c.created_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, teacherId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getInt("teacher_id"),
                            rs.getInt("capacity"),
                            rs.getTimestamp("created_date"),
                            rs.getString("status")
                    );
                    course.setTeacherName(rs.getString("teacher_name"));
                    course.setEnrolledCount(rs.getInt("enrolled_count"));
                    courses.add(course);
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR in getCoursesByTeacher: " + e.getMessage());
            e.printStackTrace();
        }
        return courses;
    }

    /**
     * Get enrolled students for a course taught by a teacher (R-5)
     */
    public List<Enrollment> getStudentsByCourse(int courseId, int teacherId) {
        List<Enrollment> enrollments = new ArrayList<>();
        String sql = "SELECT e.id, e.student_id, u.name as student_name, u.email as student_email, " +
                     "e.course_id, e.enrollment_date, e.status " +
                     "FROM enrollments e " +
                     "JOIN users u ON e.student_id = u.id " +
                     "JOIN courses c ON e.course_id = c.id " +
                     "WHERE e.course_id = ? AND c.teacher_id = ? AND e.status = 'enrolled' " +
                     "ORDER BY e.enrollment_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, courseId);
            stmt.setInt(2, teacherId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Enrollment enrollment = new Enrollment(
                            rs.getInt("id"),
                            rs.getInt("student_id"),
                            rs.getInt("course_id"),
                            rs.getTimestamp("enrollment_date"),
                            rs.getString("status")
                    );
                    enrollment.setStudentName(rs.getString("student_name"));
                    enrollment.setStudentEmail(rs.getString("student_email"));
                    enrollments.add(enrollment);
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR in getStudentsByCourse: " + e.getMessage());
            e.printStackTrace();
        }
        return enrollments;
    }

    // ==================== STUDENT OPERATIONS ====================

    /**
     * Get all courses a student is enrolled in
     */
    public List<Course> getStudentEnrolledCourses(int studentId) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, u.name as teacher_name, " +
                     "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.id AND e.status = 'enrolled') as enrolled_count " +
                     "FROM courses c " +
                     "JOIN enrollments e ON c.id = e.course_id " +
                     "LEFT JOIN users u ON c.teacher_id = u.id " +
                     "WHERE e.student_id = ? AND e.status = 'enrolled' AND c.status = 'active' " +
                     "ORDER BY c.created_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getInt("teacher_id"),
                            rs.getInt("capacity"),
                            rs.getTimestamp("created_date"),
                            rs.getString("status")
                    );
                    course.setTeacherName(rs.getString("teacher_name"));
                    course.setEnrolledCount(rs.getInt("enrolled_count"));
                    courses.add(course);
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR in getStudentEnrolledCourses: " + e.getMessage());
            e.printStackTrace();
        }
        return courses;
    }

    /**
     * Get all available courses for a student to enroll
     */
    public List<Course> getAvailableCoursesForStudent(int studentId) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, u.name as teacher_name, " +
                     "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.id AND e.status = 'enrolled') as enrolled_count " +
                     "FROM courses c " +
                     "LEFT JOIN users u ON c.teacher_id = u.id " +
                     "WHERE c.status = 'active' " +
                     "AND c.id NOT IN (SELECT course_id FROM enrollments WHERE student_id = ? AND status = 'enrolled') " +
                     "AND (SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.id AND e.status = 'enrolled') < c.capacity " +
                     "ORDER BY c.created_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getInt("teacher_id"),
                            rs.getInt("capacity"),
                            rs.getTimestamp("created_date"),
                            rs.getString("status")
                    );
                    course.setTeacherName(rs.getString("teacher_name"));
                    course.setEnrolledCount(rs.getInt("enrolled_count"));
                    courses.add(course);
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR in getAvailableCoursesForStudent: " + e.getMessage());
            e.printStackTrace();
        }
        return courses;
    }

    /**
     * Check if student is already enrolled in a course
     */
    public boolean isStudentEnrolled(int studentId, int courseId) {
        String sql = "SELECT COUNT(*) as count FROM enrollments WHERE student_id = ? AND course_id = ? AND status = 'enrolled'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR in isStudentEnrolled: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Enroll a student in a course
     */
    public boolean enrollStudentInCourse(int studentId, int courseId) {
        if (isStudentEnrolled(studentId, courseId)) {
            System.out.println("✗ Student is already enrolled in this course");
            return false;
        }

        String sql = "INSERT INTO enrollments (student_id, course_id, status) VALUES (?, ?, 'enrolled')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("✓ Student enrolled successfully in course");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("ERROR in enrollStudentInCourse: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Drop a course (change status to dropped)
     */
    public boolean dropCourse(int studentId, int courseId) {
        String sql = "UPDATE enrollments SET status = 'dropped' WHERE student_id = ? AND course_id = ? AND status = 'enrolled'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("✓ Course dropped successfully");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("ERROR in dropCourse: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
