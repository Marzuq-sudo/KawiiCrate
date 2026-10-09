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

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    private void fail(HttpServletRequest request,
                      HttpServletResponse response,
                      String message)
            throws ServletException, IOException {

        request.setAttribute("error", message);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("role");

        // ---------- basic validation ----------

        if (email == null || password == null
                || email.trim().isEmpty() || password.isEmpty()) {
            fail(request, response, "Please enter your email and password.");
            return;
        }

        // The form only offers BUYER and SELLER. Anything else
        // (including a hand-edited "ADMIN") is rejected.
        selectedRole = selectedRole == null ? "" : selectedRole.trim().toUpperCase();

        if (!selectedRole.equals("BUYER") && !selectedRole.equals("SELLER")) {
            fail(request, response, "Please choose Buyer or Seller.");
            return;
        }

        email = email.trim().toLowerCase();

        try {

            // ---------- check credentials ----------

            User user = userDAO.login(email, password);

            if (user == null) {
                fail(request, response, "Invalid email or password.");
                return;
            }

            String actualRole = user.getRole() == null
                    ? "BUYER"
                    : user.getRole().trim().toUpperCase();

            // ---------- role check (done on the server) ----------
            // Admins skip the selector. Everyone else must pick the
            // role their account actually has.

            boolean isAdmin = actualRole.equals("ADMIN");

            if (!isAdmin && !actualRole.equals(selectedRole)) {

                String nice = actualRole.equals("SELLER") ? "Seller" : "Buyer";

                fail(request, response,
                        "This account is registered as a " + nice
                                + ". Please select " + nice + " to log in.");
                return;
            }

            // ---------- success: create a fresh session ----------

            HttpSession old = request.getSession(false);
            if (old != null) {
                old.invalidate();
            }

            HttpSession session = request.getSession(true);

            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userRole", actualRole);

            String target;
            if (isAdmin) {
                target = "/admin.jsp";
            } else if (actualRole.equals("SELLER")) {
                target = "/seller.jsp";
            } else {
                target = "/buyer.jsp";
            }

            response.sendRedirect(request.getContextPath() + target);

        } catch (Exception e) {

            e.printStackTrace();
            fail(request, response, "Unable to login. Please try again.");
        }
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}