package com.kawaiicrate.controller;

import com.kawaiicrate.dao.UserDAO;
import com.kawaiicrate.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;


    // =====================================================
    // INITIALIZE
    // =====================================================

    @Override
    public void init() throws ServletException {

        userDAO = new UserDAO();
    }


    // =====================================================
    // LOGIN
    // =====================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");


        // =================================================
        // GET LOGIN DATA
        // =================================================

        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");


        // =================================================
        // VALIDATION
        // =================================================

        if (email == null ||
                password == null ||
                email.trim().isEmpty() ||
                password.isEmpty()) {

            request.setAttribute(
                    "error",
                    "Please enter your email and password."
            );

            request.getRequestDispatcher(
                    "/login.jsp"
            ).forward(request, response);

            return;
        }


        email = email.trim().toLowerCase();


        // =================================================
        // CHECK USER
        // =================================================

        try {

            User user =
                    userDAO.login(
                            email,
                            password
                    );


            // =================================================
            // LOGIN SUCCESS
            // =================================================

            if (user != null) {

                HttpSession session =
                        request.getSession(true);


                // Store user information
                session.setAttribute(
                        "user",
                        user
                );


                session.setAttribute(
                        "userId",
                        user.getId()
                );


                session.setAttribute(
                        "userName",
                        user.getName()
                );


                session.setAttribute(
                        "userEmail",
                        user.getEmail()
                );


                session.setAttribute(
                        "userRole",
                        user.getRole()
                );


                // =================================================
                // GET ROLE FROM DATABASE
                // =================================================

                String role =
                        user.getRole();


                // =================================================
                // ADMIN
                // =================================================

                if ("ADMIN".equalsIgnoreCase(role)) {

                    response.sendRedirect(
                            request.getContextPath()
                                    + "/admin.jsp"
                    );

                    return;
                }


                // =================================================
                // SELLER
                // =================================================

                if ("SELLER".equalsIgnoreCase(role)) {

                    response.sendRedirect(
                            request.getContextPath()
                                    + "/seller.jsp"
                    );

                    return;
                }


                // =================================================
                // BUYER
                // =================================================

                response.sendRedirect(
                        request.getContextPath()
                                + "/buyer.jsp"
                );

                return;
            }


            // =================================================
            // INVALID LOGIN
            // =================================================

            request.setAttribute(
                    "error",
                    "Invalid email or password."
            );


            request.getRequestDispatcher(
                    "/login.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            e.printStackTrace();


            request.setAttribute(
                    "error",
                    "Unable to login. Please try again."
            );


            request.getRequestDispatcher(
                    "/login.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }


    // =====================================================
    // GET /login
    // =====================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/login.jsp"
        );
    }
}