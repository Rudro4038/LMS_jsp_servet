package com.weblab.controllers;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/teacher/dashboard")
public class TeacherDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Logic to fetch data for teacher
        req.getRequestDispatcher("/WEB-INF/views/teacher/dashboard.jsp").forward(req, resp);
    }
}
