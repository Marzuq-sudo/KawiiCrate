<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%
    // =====================================================
    // ADMIN SECURITY CHECK
    // =====================================================

    if (session.getAttribute("user") == null) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );

        return;
    }


    String userRole =
            (String) session.getAttribute("userRole");


    if (userRole == null ||
            !"ADMIN".equalsIgnoreCase(userRole)) {

        response.sendRedirect(
                request.getContextPath() + "/buyer.jsp"
        );

        return;
    }


    String adminName =
            (String) session.getAttribute("userName");


    // =====================================================
    // DATABASE CONFIGURATION
    // =====================================================

    String DB_URL =
            "jdbc:postgresql://localhost:5433/kawaiicrate";

    String DB_USER =
            "kawaii";

    String DB_PASSWORD =
            "kawaii123";


    int totalUsers = 0;
    int totalBuyers = 0;
    int totalSellers = 0;
    int totalAdmins = 0;


    // =====================================================
    // GET USER STATISTICS
    // =====================================================

    try {

        Class.forName("org.postgresql.Driver");


        try (
                Connection connection =
                        DriverManager.getConnection(
                                DB_URL,
                                DB_USER,
                                DB_PASSWORD
                        )
        ) {

            // Total users
            String totalUsersSql =
                    "SELECT COUNT(*) FROM users";


            try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    totalUsersSql
                            );

                    ResultSet result =
                            statement.executeQuery()
            ) {

                if (result.next()) {
                    totalUsers = result.getInt(1);
                }
            }


            // Total buyers
            String buyersSql =
                    "SELECT COUNT(*) FROM users " +
                    "WHERE UPPER(role) = 'BUYER'";


            try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    buyersSql
                            );

                    ResultSet result =
                            statement.executeQuery()
            ) {

                if (result.next()) {
                    totalBuyers = result.getInt(1);
                }
            }


            // Total sellers
            String sellersSql =
                    "SELECT COUNT(*) FROM users " +
                    "WHERE UPPER(role) = 'SELLER'";


            try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    sellersSql
                            );

                    ResultSet result =
                            statement.executeQuery()
            ) {

                if (result.next()) {
                    totalSellers = result.getInt(1);
                }
            }


            // Total admins
            String adminsSql =
                    "SELECT COUNT(*) FROM users " +
                    "WHERE UPPER(role) = 'ADMIN'";


            try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    adminsSql
                            );

                    ResultSet result =
                            statement.executeQuery()
            ) {

                if (result.next()) {
                    totalAdmins = result.getInt(1);
                }
            }

        }

    } catch (Exception e) {

        e.printStackTrace();
    }

%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">


    <title>
        Admin Dashboard | Kawaii Crate
    </title>


    <style>

        /* =================================================
           RESET
           ================================================= */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }


        body {

            font-family:
                Georgia,
                "Times New Roman",
                serif;

            background: #f5f0e9;

            color: #112250;

            min-height: 100vh;
        }


        /* =================================================
           LAYOUT
           ================================================= */

        .layout {

            display: flex;

            min-height: 100vh;
        }


        /* =================================================
           SIDEBAR
           ================================================= */

        .sidebar {

            width: 250px;

            background: #112250;

            color: #f5f0e9;

            padding: 35px 25px;

            display: flex;

            flex-direction: column;

            position: fixed;

            left: 0;

            top: 0;

            bottom: 0;
        }


        .brand {

            font-size: 22px;

            font-weight: bold;

            letter-spacing: 3px;

            margin-bottom: 50px;

            text-align: center;
        }


        .admin-badge {

            text-align: center;

            font-family: Arial, sans-serif;

            font-size: 11px;

            letter-spacing: 3px;

            color: #e0c58f;

            margin-top: -35px;

            margin-bottom: 40px;
        }


        .menu-title {

            font-family: Arial, sans-serif;

            font-size: 10px;

            letter-spacing: 3px;

            color: #aeb5c7;

            margin-bottom: 15px;
        }


        .menu {

            display: flex;

            flex-direction: column;

            gap: 8px;
        }


        .menu a {

            text-decoration: none;

            color: #dfe3ec;

            padding: 13px 15px;

            border-radius: 9px;

            font-family: Arial, sans-serif;

            font-size: 14px;

            transition: 0.2s;
        }


        .menu a:hover,
        .menu a.active {

            background: #30507d;

            color: white;
        }


        .sidebar-bottom {

            margin-top: auto;
        }


        .logout {

            display: block;

            text-align: center;

            padding: 12px;

            border: 1px solid #536887;

            border-radius: 9px;

            color: #f5f0e9;

            text-decoration: none;

            font-family: Arial, sans-serif;

            font-size: 13px;

            transition: 0.2s;
        }


        .logout:hover {

            background: #f5f0e9;

            color: #112250;
        }


        /* =================================================
           MAIN
           ================================================= */

        .main {

            margin-left: 250px;

            width: calc(100% - 250px);

            padding: 45px 50px;
        }


        /* =================================================
           HEADER
           ================================================= */

        .topbar {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 45px;
        }


        .topbar h1 {

            font-size: 40px;

            font-weight: 400;

            margin-bottom: 8px;
        }


        .topbar p {

            color: #686b7b;

            font-family: Arial, sans-serif;

            font-size: 14px;
        }


        .admin-profile {

            background: #fdfbf8;

            border: 1px solid #d9cbc2;

            padding: 12px 18px;

            border-radius: 12px;

            font-family: Arial, sans-serif;

            font-size: 13px;
        }


        .admin-profile strong {

            color: #112250;
        }


        /* =================================================
           STATISTICS
           ================================================= */

        .stats {

            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 20px;

            margin-bottom: 45px;
        }


        .stat-card {

            background: #fdfbf8;

            border: 1px solid #d9cbc2;

            border-radius: 16px;

            padding: 25px;

            box-shadow:
                0 10px 30px
                rgba(17, 34, 80, 0.07);
        }


        .stat-icon {

            font-size: 25px;

            color: #e0c58f;

            margin-bottom: 18px;
        }


        .stat-label {

            font-family: Arial, sans-serif;

            color: #777a89;

            font-size: 12px;

            letter-spacing: 1px;

            margin-bottom: 8px;
        }


        .stat-number {

            font-size: 34px;

            color: #112250;
        }


        /* =================================================
           USERS SECTION
           ================================================= */

        .section {

            background: #fdfbf8;

            border: 1px solid #d9cbc2;

            border-radius: 18px;

            padding: 30px;

            box-shadow:
                0 10px 30px
                rgba(17, 34, 80, 0.06);
        }


        .section-header {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 25px;
        }


        .section-header h2 {

            font-size: 26px;

            font-weight: 400;
        }


        .section-header span {

            font-family: Arial, sans-serif;

            font-size: 12px;

            color: #777a89;
        }


        /* =================================================
           TABLE
           ================================================= */

        .table-wrapper {

            overflow-x: auto;
        }


        table {

            width: 100%;

            border-collapse: collapse;

            font-family: Arial, sans-serif;
        }


        th {

            text-align: left;

            padding: 15px;

            font-size: 11px;

            letter-spacing: 1px;

            color: #777a89;

            border-bottom:
                1px solid #ded6ce;
        }


        td {

            padding: 17px 15px;

            font-size: 13px;

            color: #30364c;

            border-bottom:
                1px solid #eee8e1;
        }


        tr:last-child td {

            border-bottom: none;
        }


        .user-name {

            color: #112250;

            font-weight: 600;
        }


        /* =================================================
           ROLE BADGES
           ================================================= */

        .role {

            display: inline-block;

            padding: 6px 12px;

            border-radius: 20px;

            font-size: 10px;

            letter-spacing: 1px;

            font-weight: bold;
        }


        .role-admin {

            background: #e8dfc9;

            color: #73591e;
        }


        .role-seller {

            background: #dce8f2;

            color: #30507d;
        }


        .role-buyer {

            background: #eee7e1;

            color: #625d58;
        }


        /* =================================================
           QUICK ACTIONS
           ================================================= */

        .actions {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 18px;

            margin-top: 25px;
        }


        .action {

            text-decoration: none;

            background: #f5f0e9;

            border: 1px solid #d9cbc2;

            padding: 20px;

            border-radius: 12px;

            transition: 0.2s;
        }


        .action:hover {

            transform: translateY(-3px);

            border-color: #30507d;
        }


        .action-icon {

            font-size: 22px;

            color: #e0c58f;

            margin-bottom: 10px;
        }


        .action h3 {

            color: #112250;

            font-size: 16px;

            font-weight: 400;

            margin-bottom: 6px;
        }


        .action p {

            color: #777a89;

            font-family: Arial, sans-serif;

            font-size: 12px;

            line-height: 1.5;
        }


        /* =================================================
           FOOTER
           ================================================= */

        .footer {

            text-align: center;

            margin-top: 45px;

            color: #888b98;

            font-family: Arial, sans-serif;

            font-size: 11px;
        }


        /* =================================================
           MOBILE
           ================================================= */

        @media (max-width: 1000px) {

            .stats {

                grid-template-columns:
                    repeat(2, 1fr);
            }


            .actions {

                grid-template-columns:
                    1fr;
            }
        }


        @media (max-width: 700px) {

            .sidebar {

                width: 100%;

                height: auto;

                position: relative;

                padding: 20px;
            }


            .sidebar-bottom {

                margin-top: 25px;
            }


            .layout {

                display: block;
            }


            .main {

                margin-left: 0;

                width: 100%;

                padding: 25px 20px;
            }


            .stats {

                grid-template-columns:
                    1fr;
            }


            .topbar {

                flex-direction: column;

                align-items: flex-start;

                gap: 20px;
            }
        }

    </style>

</head>


<body>


<div class="layout">


    <!-- =================================================
         SIDEBAR
         ================================================= -->

    <aside class="sidebar">

        <div class="brand">

            KAWAII CRATE

        </div>


        <div class="admin-badge">

            ✦ ADMIN PANEL ✦

        </div>


        <div class="menu-title">

            DASHBOARD

        </div>


        <nav class="menu">

            <a href="admin.jsp"
               class="active">

                ✦ Overview

            </a>


            <a href="#users">

                ♡ Users

            </a>


            <a href="#statistics">

                ✦ Statistics

            </a>


            <a href="#actions">

                ♡ Quick Actions

            </a>

        </nav>


        <div class="sidebar-bottom">

            <a href="${pageContext.request.contextPath}/logout"
               class="logout">

                Logout

            </a>

        </div>

    </aside>



    <!-- =================================================
         MAIN CONTENT
         ================================================= -->

    <main class="main">


        <!-- HEADER -->

        <div class="topbar">

            <div>

                <h1>
                    Admin Dashboard ✦
                </h1>


                <p>
                    Welcome back, <%= adminName %>.
                    Here's what's happening with Kawaii Crate.
                </p>

            </div>


            <div class="admin-profile">

                Logged in as:

                <strong>
                    ADMIN
                </strong>

            </div>

        </div>



        <!-- =================================================
             STATISTICS
             ================================================= -->

        <section id="statistics"
                 class="stats">


            <!-- TOTAL USERS -->

            <div class="stat-card">

                <div class="stat-icon">
                    ♡
                </div>

                <div class="stat-label">
                    TOTAL USERS
                </div>

                <div class="stat-number">
                    <%= totalUsers %>
                </div>

            </div>


            <!-- BUYERS -->

            <div class="stat-card">

                <div class="stat-icon">
                    ✦
                </div>

                <div class="stat-label">
                    BUYERS
                </div>

                <div class="stat-number">
                    <%= totalBuyers %>
                </div>

            </div>


            <!-- SELLERS -->

            <div class="stat-card">

                <div class="stat-icon">
                    ♡
                </div>

                <div class="stat-label">
                    SELLERS
                </div>

                <div class="stat-number">
                    <%= totalSellers %>
                </div>

            </div>


            <!-- ADMINS -->

            <div class="stat-card">

                <div class="stat-icon">
                    ✦
                </div>

                <div class="stat-label">
                    ADMINS
                </div>

                <div class="stat-number">
                    <%= totalAdmins %>
                </div>

            </div>


        </section>



        <!-- =================================================
             USERS
             ================================================= -->

        <section id="users"
                 class="section">


            <div class="section-header">

                <h2>
                    Registered Users
                </h2>


                <span>
                    Kawaii Crate members
                </span>

            </div>


            <div class="table-wrapper">

                <table>

                    <thead>

                    <tr>

                        <th>
                            ID
                        </th>

                        <th>
                            NAME
                        </th>

                        <th>
                            EMAIL
                        </th>

                        <th>
                            ROLE
                        </th>

                    </tr>

                    </thead>


                    <tbody>


                    <%

                        try {

                            Class.forName(
                                    "org.postgresql.Driver"
                            );


                            try (
                                    Connection connection =
                                            DriverManager.getConnection(
                                                    DB_URL,
                                                    DB_USER,
                                                    DB_PASSWORD
                                            );

                                    PreparedStatement statement =
                                            connection.prepareStatement(
                                                    "SELECT id, name, email, role " +
                                                    "FROM users " +
                                                    "ORDER BY id"
                                            );

                                    ResultSet result =
                                            statement.executeQuery()
                            ) {


                                while (result.next()) {

                                    int id =
                                            result.getInt("id");

                                    String name =
                                            result.getString("name");

                                    String email =
                                            result.getString("email");

                                    String role =
                                            result.getString("role");


                                    String roleClass =
                                            "role-buyer";


                                    if ("ADMIN".equalsIgnoreCase(role)) {

                                        roleClass =
                                                "role-admin";

                                    } else if (
                                            "SELLER".equalsIgnoreCase(role)
                                    ) {

                                        roleClass =
                                                "role-seller";
                                    }

                    %>


                    <tr>

                        <td>
                            #<%= id %>
                        </td>


                        <td class="user-name">

                            <%= name %>

                        </td>


                        <td>

                            <%= email %>

                        </td>


                        <td>

                            <span class="role <%= roleClass %>">

                                <%= role %>

                            </span>

                        </td>

                    </tr>


                    <%

                                }

                            }

                        } catch (Exception e) {

                            e.printStackTrace();

                    %>


                    <tr>

                        <td colspan="4">

                            Unable to load users.

                        </td>

                    </tr>


                    <%

                        }

                    %>


                    </tbody>

                </table>

            </div>

        </section>



        <!-- =================================================
             QUICK ACTIONS
             ================================================= -->

        <section id="actions"
                 class="section"
                 style="margin-top: 25px;">


            <div class="section-header">

                <h2>
                    Quick Actions
                </h2>

            </div>


            <div class="actions">


                <a href="#users"
                   class="action">

                    <div class="action-icon">
                        ♡
                    </div>

                    <h3>
                        View Users
                    </h3>

                    <p>
                        View all registered
                        Kawaii Crate users.
                    </p>

                </a>


                <a href="#statistics"
                   class="action">

                    <div class="action-icon">
                        ✦
                    </div>

                    <h3>
                        View Statistics
                    </h3>

                    <p>
                        See the current
                        platform user statistics.
                    </p>

                </a>


                <a href="${pageContext.request.contextPath}/logout"
                   class="action">

                    <div class="action-icon">
                        ♡
                    </div>

                    <h3>
                        Logout
                    </h3>

                    <p>
                        Securely sign out
                        of the admin account.
                    </p>

                </a>


            </div>

        </section>



        <!-- FOOTER -->

        <div class="footer">

            ♡ KAWAII CRATE · ADMIN PANEL ✦

        </div>


    </main>

</div>


</body>

</html>