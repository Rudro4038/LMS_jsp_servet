package com.weblab.controllers;

import com.weblab.dao.AuthDAO;
import com.weblab.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    private AuthDAO authDAO = new AuthDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Display registration form
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        // Print to console for debugging
        System.out.println("========== REGISTRATION REQUEST RECEIVED ==========");
        System.out.println("Name: " + name);
        System.out.println("Email: " + email);
        System.out.println("Password: " + (password != null ? "***" : "null"));
        System.out.println("Role: " + role);
        System.out.println("====================================================\n");

        boolean success = false;
        if ("student".equals(role)) {
            System.out.println("Attempting to register STUDENT...");
            success = authDAO.registerStudent(name, email, password);
            System.out.println("Student registration result: " + (success ? "SUCCESS" : "FAILED"));
        } else if ("teacher".equals(role)) {
            System.out.println("Attempting to register TEACHER...");
            success = authDAO.registerTeacher(name, email, password);
            System.out.println("Teacher registration result: " + (success ? "SUCCESS" : "FAILED"));
        } else if ("admin".equals(role)) {
            System.out.println("Attempting to register ADMIN...");
            success = authDAO.registerAdmin(name, email, password);
            System.out.println("Admin registration result: " + (success ? "SUCCESS" : "FAILED"));
        } else {
            System.out.println("ERROR: Invalid role - " + role);
        }

        if (success) {
            System.out.println("Registration successful! Logging in user...\n");
            // Auto-login after registration - fetch user and set session like login does
            User authUser = authDAO.login(email, password, role);
            
            if (authUser != null) {
                HttpSession session = req.getSession();
                session.setAttribute("user", authUser);
                session.setAttribute("userId", authUser.getId());
                session.setAttribute("userRole", authUser.getRole());
                session.setAttribute("userEmail", authUser.getUsername());
                
                String redirectUrl = req.getContextPath() + "/home/" + authUser.getRole();
                resp.sendRedirect(redirectUrl);
            } else {
                // Fallback if login fails after registration
                req.setAttribute("error", "Registration successful but auto-login failed. Please login manually.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        } else {
            System.out.println("Registration failed! Redirecting to register.jsp XXX...\n");
            req.setAttribute("error", "Registration failed. Email might already be in use.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
