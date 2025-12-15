package com.weblab.controllers;

import com.weblab.dao.AuthDAO;
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
 * Admin Course Management Servlet (R-3)
 * Handles: Adding new courses and assigning teachers to courses
 */
@WebServlet("/admin/courses")
public class AdminCoursesServlet extends HttpServlet {
    private CourseDAO courseDAO = new CourseDAO();
    private AuthDAO authDAO = new AuthDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        // Check if user is logged in and is admin
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("view".equals(action)) {
            viewAllCourses(req, resp);
        } else {
            showAddCourseForm(req, resp);
        }
    }

    /**
     * Display all courses
     */
    private void viewAllCourses(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Course> courses = courseDAO.getAllCourses();
        req.setAttribute("courses", courses);
        req.getRequestDispatcher("/WEB-INF/views/admin/view_courses.jsp").forward(req, resp);
    }

    /**
     * Show add course form
     */
    private void showAddCourseForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Get all teachers to assign to courses
        // You can create a method in AuthDAO to get all teachers
        req.getRequestDispatcher("/WEB-INF/views/admin/add_course.jsp").forward(req, resp);
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
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("addCourse".equals(action)) {
            addNewCourse(req, resp);
        }
    }

    /**
     * Add a new course (R-3)
     */
    private void addNewCourse(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String courseName = req.getParameter("courseName");
        String description = req.getParameter("description");
        String teacherIdStr = req.getParameter("teacherId");
        String capacityStr = req.getParameter("capacity");

        // Validation
        if (courseName == null || courseName.trim().isEmpty() ||
            teacherIdStr == null || teacherIdStr.trim().isEmpty() ||
            capacityStr == null || capacityStr.trim().isEmpty()) {
            
            req.setAttribute("error", "All fields are required");
            req.getRequestDispatcher("/WEB-INF/views/admin/add_course.jsp").forward(req, resp);
            return;
        }

        try {
            int teacherId = Integer.parseInt(teacherIdStr);
            int capacity = Integer.parseInt(capacityStr);

            if (capacity <= 0 || capacity > 500) {
                req.setAttribute("error", "Capacity must be between 1 and 500");
                req.getRequestDispatcher("/WEB-INF/views/admin/add_course.jsp").forward(req, resp);
                return;
            }

            boolean success = courseDAO.addCourse(courseName, description, teacherId, capacity);

            if (success) {
                req.setAttribute("message", "Course added successfully!");
                resp.sendRedirect(req.getContextPath() + "/admin/courses?action=view");
            } else {
                req.setAttribute("error", "Failed to add course. Please try again.");
                req.getRequestDispatcher("/WEB-INF/views/admin/add_course.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid input format");
            req.getRequestDispatcher("/WEB-INF/views/admin/add_course.jsp").forward(req, resp);
        }
    }
}
