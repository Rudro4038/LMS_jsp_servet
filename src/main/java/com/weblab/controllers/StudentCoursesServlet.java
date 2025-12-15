package com.weblab.controllers;

import com.weblab.dao.CourseDAO;
import com.weblab.model.Course;
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
 * Student Course Management Servlet
 * Handles: Viewing available courses and enrolling in courses
 */
@WebServlet("/student/courses")
public class StudentCoursesServlet extends HttpServlet {
    private CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        // Check if user is logged in and is student
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"student".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("enrolled".equals(action)) {
            viewEnrolledCourses(req, resp, user.getId());
        } else {
            viewAvailableCourses(req, resp, user.getId());
        }
    }

    /**
     * View all available courses for enrollment
     */
    private void viewAvailableCourses(HttpServletRequest req, HttpServletResponse resp, int studentId) 
            throws ServletException, IOException {
        List<Course> courses = courseDAO.getAvailableCoursesForStudent(studentId);
        req.setAttribute("courses", courses);
        req.setAttribute("viewType", "available");
        req.getRequestDispatcher("/WEB-INF/views/student/view_courses.jsp").forward(req, resp);
    }

    /**
     * View all enrolled courses
     */
    private void viewEnrolledCourses(HttpServletRequest req, HttpServletResponse resp, int studentId) 
            throws ServletException, IOException {
        List<Course> courses = courseDAO.getStudentEnrolledCourses(studentId);
        req.setAttribute("courses", courses);
        req.setAttribute("viewType", "enrolled");
        req.getRequestDispatcher("/WEB-INF/views/student/view_courses.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        // Security check
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"student".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("enroll".equals(action)) {
            enrollInCourse(req, resp, user.getId());
        } else if ("drop".equals(action)) {
            dropCourse(req, resp, user.getId());
        }
    }

    /**
     * Enroll student in a course
     */
    private void enrollInCourse(HttpServletRequest req, HttpServletResponse resp, int studentId) 
            throws ServletException, IOException {
        String courseIdStr = req.getParameter("courseId");

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/courses");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            Course course = courseDAO.getCourseById(courseId);

            if (course == null) {
                req.setAttribute("error", "Course not found");
                viewAvailableCourses(req, resp, studentId);
                return;
            }

            if (!course.hasAvailableSeats()) {
                req.setAttribute("error", "This course is full");
                viewAvailableCourses(req, resp, studentId);
                return;
            }

            boolean success = courseDAO.enrollStudentInCourse(studentId, courseId);

            if (success) {
                req.setAttribute("message", "Successfully enrolled in course: " + course.getName());
            } else {
                req.setAttribute("error", "Failed to enroll in course");
            }

            viewAvailableCourses(req, resp, studentId);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/student/courses");
        }
    }

    /**
     * Drop a course
     */
    private void dropCourse(HttpServletRequest req, HttpServletResponse resp, int studentId) 
            throws ServletException, IOException {
        String courseIdStr = req.getParameter("courseId");

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/courses?action=enrolled");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            boolean success = courseDAO.dropCourse(studentId, courseId);

            if (success) {
                req.setAttribute("message", "Successfully dropped course");
            } else {
                req.setAttribute("error", "Failed to drop course");
            }

            viewEnrolledCourses(req, resp, studentId);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/student/courses?action=enrolled");
        }
    }
}
