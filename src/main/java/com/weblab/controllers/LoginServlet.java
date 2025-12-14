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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private AuthDAO authDAO = new AuthDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String pass = req.getParameter("password");
        String role = req.getParameter("role");

        User authUser = authDAO.login(email, pass, role);

        if (authUser != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", authUser);
            session.setAttribute("userId", authUser.getId());
            session.setAttribute("userRole", authUser.getRole());
            session.setAttribute("userEmail", authUser.getUsername());

            String redirectUrl = req.getContextPath() + "/home/" + authUser.getRole();
            resp.sendRedirect(redirectUrl);
        } else {
            req.setAttribute("error", "Invalid credentials or user role");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
