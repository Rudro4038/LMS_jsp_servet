package com.weblab.controllers;

import com.weblab.dao.AuthDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    private AuthDAO authDAO = new AuthDAO();

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
            System.out.println("Registration successful! Redirecting to home...\n");
            // Directly log the user in after registration
            req.getRequestDispatcher("/home/" + role).forward(req, resp);
        } else {
            System.out.println("Registration failed! Redirecting to register.jsp XXX...\n");
            req.setAttribute("error", "Registration failed. Email might already be in use.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
