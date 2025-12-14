package com.weblab.controllers;

import com.weblab.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/home/*")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String pathInfo = req.getPathInfo();
        String role = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "";

        // Verify user role matches the requested role
        if (!role.equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Route to appropriate dashboard
        String dashboardPath = "";
        switch (role.toLowerCase()) {
            case "admin":
                dashboardPath = "/WEB-INF/views/admin/dashboard.jsp";
                break;
            case "student":
                dashboardPath = "/WEB-INF/views/student/dashboard.jsp";
                break;
            case "teacher":
                dashboardPath = "/WEB-INF/views/teacher/dashboard.jsp";
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
        }

        req.getRequestDispatcher(dashboardPath).forward(req, resp);
    }
}
