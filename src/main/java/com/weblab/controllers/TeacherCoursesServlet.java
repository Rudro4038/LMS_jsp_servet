package com.weblab.controllers;

import com.weblab.dao.CourseDAO;
import com.weblab.model.Course;
import com.weblab.model.Enrollment;
import com.weblab.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Teacher Course Management Servlet
 * Handles R-4 & R-5: View courses taught and view students in courses
 */
@WebServlet("/teacher/courses")
public class TeacherCoursesServlet extends HttpServlet {
    private CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        // Check if user is logged in and is teacher
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"teacher".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("viewStudents".equals(action)) {
            viewStudentsInCourse(req, resp, user.getId());
        } else {
            viewTeacherCourses(req, resp, user.getId());
        }
    }

    /**
     * View all courses taught by the teacher (R-4)
     */
    private void viewTeacherCourses(HttpServletRequest req, HttpServletResponse resp, int teacherId) 
            throws ServletException, IOException {
        List<Course> courses = courseDAO.getCoursesByTeacher(teacherId);
        req.setAttribute("courses", courses);
        req.getRequestDispatcher("/WEB-INF/views/teacher/view_courses.jsp").forward(req, resp);
    }

    /**
     * View all students enrolled in a specific course (R-5)
     */
    private void viewStudentsInCourse(HttpServletRequest req, HttpServletResponse resp, int teacherId) 
            throws ServletException, IOException {
        String courseIdStr = req.getParameter("courseId");

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/teacher/courses");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);

            // Get course details (verify it belongs to this teacher)
            Course course = courseDAO.getCourseById(courseId);
            
            if (course == null || course.getTeacherId() != teacherId) {
                req.setAttribute("error", "You don't have access to this course");
                resp.sendRedirect(req.getContextPath() + "/teacher/courses");
                return;
            }

            // Get all students in this course
            List<Enrollment> enrollments = courseDAO.getStudentsByCourse(courseId, teacherId);
            
            req.setAttribute("course", course);
            req.setAttribute("enrollments", enrollments);
            req.getRequestDispatcher("/WEB-INF/views/teacher/view_students.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/teacher/courses");
        }
    }
}
