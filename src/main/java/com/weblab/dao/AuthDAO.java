package com.weblab.dao;

import com.weblab.model.User;
import com.weblab.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AuthDAO {

    public User getUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("id"),
                            rs.getString("email"),
                            rs.getString("role")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR in getUser: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public User login(String email, String password, String role) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ? AND role = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);
            stmt.setString(3, role);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User(
                            rs.getInt("id"),
                            rs.getString("email"),
                            rs.getString("role")
                    );
                    System.out.println("✓ User Login Success - ID: " + user.getId() + ", Email: " + user.getUsername() + ", Role: " + user.getRole());
                    return user;
                } else {
                    System.out.println("✗ Login failed for email: " + email + " with role: " + role);
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR in login: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean registerStudent(String name, String email, String password) {
        String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setString(4, "student");

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("✓ Student registered successfully - Email: " + email);
                return true;
            }
        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate entry")) {
                System.out.println("✗ Email already exists: " + email);
            } else {
                System.err.println("ERROR in registerStudent: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return false;
    }

    public boolean registerTeacher(String name, String email, String password) {
        String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setString(4, "teacher");

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("✓ Teacher registered successfully - Email: " + email);
                return true;
            }
        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate entry")) {
                System.out.println("✗ Email already exists: " + email);
            } else {
                System.err.println("ERROR in registerTeacher: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return false;
    }

    public boolean registerAdmin(String name, String email, String password) {
        String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setString(4, "admin");

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("✓ Admin registered successfully - Email: " + email);
                return true;
            }
        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate entry")) {
                System.out.println("✗ Email already exists: " + email);
            } else {
                System.err.println("ERROR in registerAdmin: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return false;
    }
}
