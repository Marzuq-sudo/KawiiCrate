package com.kawaiicrate.controller;

import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final String DB_URL =
            "jdbc:postgresql://localhost:5433/kawaiicrate";

    private static final String DB_USER = "kawaii";

    private static final String DB_PASSWORD = "kawaii123";


    private void fail(HttpServletRequest request,
                      HttpServletResponse response,
                      String message)
            throws ServletException, IOException {

        request.setAttribute("error", message);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }


    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }


    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");

        if (name == null || email == null || password == null
                || confirmPassword == null
                || name.trim().isEmpty()
                || email.trim().isEmpty()
                || password.isEmpty()
                || confirmPassword.isEmpty()) {

            fail(request, response, "Please fill in all fields.");
            return;
        }

        // ---------------------------------------------------
        // ROLE: only BUYER or SELLER can ever be self-registered.
        // "ADMIN" (or anything else) is refused, so nobody can
        // make themselves an admin by editing the form.
        // ---------------------------------------------------

        role = role == null ? "" : role.trim().toUpperCase();

        if (!role.equals("BUYER") && !role.equals("SELLER")) {
            fail(request, response, "Please choose Buyer or Seller.");
            return;
        }

        name = name.trim();
        email = email.trim().toLowerCase();

        if (!password.equals(confirmPassword)) {
            fail(request, response, "Passwords do not match.");
            return;
        }

        if (password.length() < 6) {
            fail(request, response,
                    "Password must contain at least 6 characters.");
            return;
        }

        String checkUserSql = "SELECT id FROM users WHERE email = ?";

        String insertUserSql =
                "INSERT INTO users (name, email, password_hash, role) " +
                "VALUES (?, ?, ?, ?)";

        try {

            Class.forName("org.postgresql.Driver");

            try (Connection connection =
                         DriverManager.getConnection(
                                 DB_URL, DB_USER, DB_PASSWORD)) {

                try (PreparedStatement statement =
                             connection.prepareStatement(checkUserSql)) {

                    statement.setString(1, email);

                    try (ResultSet result = statement.executeQuery()) {

                        if (result.next()) {
                            fail(request, response,
                                    "An account with this email already exists.");
                            return;
                        }
                    }
                }

                String hashedPassword =
                        BCrypt.hashpw(password, BCrypt.gensalt(12));

                try (PreparedStatement statement =
                             connection.prepareStatement(insertUserSql)) {

                    statement.setString(1, name);
                    statement.setString(2, email);
                    statement.setString(3, hashedPassword);
                    statement.setString(4, role);

                    if (statement.executeUpdate() > 0) {
                        response.sendRedirect(
                                request.getContextPath() + "/login.jsp");
                        return;
                    }

                    fail(request, response,
                            "Registration failed. Please try again.");
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
            fail(request, response,
                    "Something went wrong: " + e.getMessage());
        }
    }
}