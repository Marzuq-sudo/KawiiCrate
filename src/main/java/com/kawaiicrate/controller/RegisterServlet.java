import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    // =====================================================
    // DATABASE CONFIGURATION
    // =====================================================

    private static final String DB_URL =
            "jdbc:postgresql://localhost:5433/kawaiicrate";

    private static final String DB_USER =
            "kawaii";

    private static final String DB_PASSWORD =
            "kawaii123";


    // =====================================================
    // GET
    // =====================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath() + "/register.jsp"
        );
    }


    // =====================================================
    // POST - REGISTER
    // =====================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");


        // =================================================
        // GET FORM DATA
        // =================================================

        String name =
                request.getParameter("name");

        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");

        String confirmPassword =
                request.getParameter("confirmPassword");


        // =================================================
        // CHECK EMPTY FIELDS
        // =================================================

        if (name == null ||
                email == null ||
                password == null ||
                confirmPassword == null ||
                name.trim().isEmpty() ||
                email.trim().isEmpty() ||
                password.isEmpty() ||
                confirmPassword.isEmpty()) {

            request.setAttribute(
                    "error",
                    "Please fill in all fields."
            );

            request.getRequestDispatcher(
                    "/register.jsp"
            ).forward(request, response);

            return;
        }


        // =================================================
        // CLEAN INPUT
        // =================================================

        name = name.trim();

        email = email.trim().toLowerCase();


        // =================================================
        // CHECK PASSWORD MATCH
        // =================================================

        if (!password.equals(confirmPassword)) {

            request.setAttribute(
                    "error",
                    "Passwords do not match."
            );

            request.getRequestDispatcher(
                    "/register.jsp"
            ).forward(request, response);

            return;
        }


        // =================================================
        // CHECK PASSWORD LENGTH
        // =================================================

        if (password.length() < 6) {

            request.setAttribute(
                    "error",
                    "Password must contain at least 6 characters."
            );

            request.getRequestDispatcher(
                    "/register.jsp"
            ).forward(request, response);

            return;
        }


        // =================================================
        // SQL QUERIES
        // =================================================

        String checkUserSql =
                "SELECT id FROM users WHERE email = ?";


        String insertUserSql =
                "INSERT INTO users (name, email, password) " +
                "VALUES (?, ?, ?)";


        // =================================================
        // DATABASE CONNECTION
        // =================================================

        try {

            // Load PostgreSQL JDBC driver
            Class.forName(
                    "org.postgresql.Driver"
            );


            try (Connection connection =
                         DriverManager.getConnection(
                                 DB_URL,
                                 DB_USER,
                                 DB_PASSWORD
                         )) {


                // =========================================
                // CHECK IF EMAIL ALREADY EXISTS
                // =========================================

                try (PreparedStatement statement =
                             connection.prepareStatement(
                                     checkUserSql
                             )) {

                    statement.setString(
                            1,
                            email
                    );


                    try (ResultSet result =
                                 statement.executeQuery()) {

                        if (result.next()) {

                            request.setAttribute(
                                    "error",
                                    "An account with this email already exists."
                            );

                            request.getRequestDispatcher(
                                    "/register.jsp"
                            ).forward(
                                    request,
                                    response
                            );

                            return;
                        }
                    }
                }


                // =========================================
                // HASH PASSWORD
                // =========================================

                String hashedPassword =
                        BCrypt.hashpw(
                                password,
                                BCrypt.gensalt(12)
                        );


                // =========================================
                // INSERT NEW USER
                // =========================================

                try (PreparedStatement statement =
                             connection.prepareStatement(
                                     insertUserSql
                             )) {

                    statement.setString(
                            1,
                            name
                    );

                    statement.setString(
                            2,
                            email
                    );

                    statement.setString(
                            3,
                            hashedPassword
                    );


                    int rowsInserted =
                            statement.executeUpdate();


                    // =====================================
                    // REGISTRATION SUCCESSFUL
                    // =====================================

                    if (rowsInserted > 0) {

                        response.sendRedirect(
                                request.getContextPath()
                                        + "/login.jsp"
                        );

                        return;
                    }


                    // =====================================
                    // REGISTRATION FAILED
                    // =====================================

                    request.setAttribute(
                            "error",
                            "Registration failed. Please try again."
                    );

                    request.getRequestDispatcher(
                            "/register.jsp"
                    ).forward(
                            request,
                            response
                    );
                }
            }


        } catch (Exception e) {

            // =============================================
            // DATABASE / SERVER ERROR
            // =============================================

            e.printStackTrace();


            request.setAttribute(
                    "error",
                    "Something went wrong: "
                            + e.getMessage()
            );


            request.getRequestDispatcher(
                    "/register.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}