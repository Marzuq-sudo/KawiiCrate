<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Create Account | Kawaii Crate</title>


    <style>

        /* =========================
           RESET
           ========================= */

        * {
            box-sizing: border-box;
        }

        html,
        body {
            margin: 0;
            padding: 0;
            width: 100%;
            min-height: 100%;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f5f0e9;
            color: #112250;
        }


        /* =========================
           HEADER
           ========================= */

        header {
            width: 100%;
            min-height: 82px;

            display: flex;
            align-items: center;
            justify-content: space-between;

            padding: 20px 60px;

            background: #fdfbf8;

            border-bottom: 1px solid #d9cbc2;
        }


        .logo {
            color: #112250;

            text-decoration: none;

            font-size: 24px;

            font-weight: 700;

            letter-spacing: 2px;

            white-space: nowrap;
        }


        .logo:hover {
            color: #30507d;
        }


        /* =========================
           NAVIGATION
           ========================= */

        nav {
            display: flex;

            align-items: center;

            gap: 30px;
        }


        nav a {
            color: #485070;

            text-decoration: none;

            font-size: 15px;

            transition: 0.25s ease;
        }


        nav a:hover {
            color: #112250;
        }


        /* =========================
           NAV ACTIONS
           ========================= */

        .nav-actions {
            display: flex;

            align-items: center;

            gap: 18px;
        }


        .login-link {
            color: #112250;

            text-decoration: none;

            font-size: 15px;
        }


        .login-link:hover {
            color: #30507d;
        }


        .join-btn {
            color: #f5f0e9;

            background: #112250;

            text-decoration: none;

            padding: 11px 20px;

            border-radius: 9px;

            font-size: 14px;

            transition: 0.25s ease;
        }


        .join-btn:hover {
            background: #30507d;

            transform: translateY(-1px);
        }


        /* =========================
           REGISTER SECTION
           ========================= */

        main {
            min-height: calc(100vh - 190px);

            display: flex;

            justify-content: center;

            align-items: center;

            padding: 65px 20px;

            background: #f5f0e9;
        }


        /* =========================
           REGISTER CARD
           ========================= */

        .auth-card {
            width: 470px;

            max-width: 100%;

            background: #fdfbf8;

            border: 1px solid #d9cbc2;

            border-radius: 24px;

            padding: 45px 50px;

            text-align: center;

            box-shadow:
                0 18px 50px rgba(17, 34, 80, 0.15);
        }


        /* =========================
           DECORATION
           ========================= */

        .auth-decoration {
            font-size: 30px;

            color: #e0c58f;

            margin-bottom: 12px;
        }


        /* =========================
           LABEL
           ========================= */

        .auth-label {
            color: #30507d;

            font-size: 12px;

            letter-spacing: 4px;

            margin: 0 0 12px;

            font-weight: 600;
        }


        /* =========================
           HEADING
           ========================= */

        .auth-card h1 {
            color: #112250;

            font-size: 40px;

            font-weight: 400;

            margin: 10px 0 14px;
        }


        /* =========================
           SUBTITLE
           ========================= */

        .auth-subtitle {
            color: #485070;

            font-size: 15px;

            line-height: 1.6;

            margin: 0 0 30px;
        }


        /* =========================
           ERROR
           ========================= */

        .error-message {
            background: #f3dede;

            color: #7a3030;

            border: 1px solid #d9b5b5;

            border-radius: 8px;

            padding: 12px;

            margin-bottom: 20px;

            font-size: 14px;
        }


        /* =========================
           SUCCESS
           ========================= */

        .success-message {
            background: #e5f0e5;

            color: #315f3b;

            border: 1px solid #b8d4bc;

            border-radius: 8px;

            padding: 12px;

            margin-bottom: 20px;

            font-size: 14px;
        }


        /* =========================
           FORM
           ========================= */

        .form-group {
            text-align: left;

            margin-bottom: 18px;
        }


        .form-group label {
            display: block;

            color: #112250;

            font-size: 14px;

            margin-bottom: 8px;

            font-weight: 600;
        }


        .form-group input {
            width: 100%;

            padding: 14px 16px;

            border: 1px solid #d9cbc2;

            border-radius: 10px;

            background: #fdfbf8;

            color: #112250;

            font-size: 15px;

            outline: none;

            transition: 0.25s ease;
        }


        .form-group input::placeholder {
            color: #999;
        }


        .form-group input:focus {
            border-color: #30507d;

            box-shadow:
                0 0 0 3px rgba(48, 80, 125, 0.12);
        }


        /* =========================
           REGISTER BUTTON
           ========================= */

        .auth-button {
            width: 100%;

            padding: 16px;

            margin-top: 8px;

            border: none;

            border-radius: 10px;

            background: #112250;

            color: #f5f0e9;

            font-size: 15px;

            font-weight: 600;

            cursor: pointer;

            transition: 0.25s ease;
        }


        .auth-button:hover {
            background: #30507d;

            transform: translateY(-2px);

            box-shadow:
                0 8px 20px rgba(17, 34, 80, 0.18);
        }


        /* =========================
           LOGIN LINK
           ========================= */

        .auth-footer {
            margin-top: 25px;

            color: #485070;

            font-size: 14px;
        }


        .auth-footer a {
            color: #30507d;

            text-decoration: none;

            font-weight: 600;
        }


        .auth-footer a:hover {
            text-decoration: underline;
        }


        /* =========================
           FOOTER
           ========================= */

        footer {
            width: 100%;

            background: #112250;

            color: #f5f0e9;

            text-align: center;

            padding: 30px 20px;
        }


        footer p {
            font-size: 18px;

            margin: 0 0 8px;

            font-weight: 600;
        }


        footer span {
            font-size: 13px;

            opacity: 0.8;
        }


        /* =========================
           MOBILE
           ========================= */

        @media (max-width: 850px) {

            header {
                padding: 20px 25px;

                flex-wrap: wrap;

                gap: 18px;
            }


            nav {
                order: 3;

                width: 100%;

                justify-content: center;

                gap: 20px;
            }


            .nav-actions {
                margin-left: auto;
            }

        }


        @media (max-width: 600px) {

            header {
                justify-content: center;
            }


            .nav-actions {
                margin-left: 0;
            }


            nav {
                gap: 12px;

                flex-wrap: wrap;
            }


            main {
                padding: 40px 15px;
            }


            .auth-card {
                padding: 35px 25px;

                border-radius: 20px;
            }


            .auth-card h1 {
                font-size: 34px;
            }

        }

    </style>

</head>


<body>


<!-- =========================
     HEADER
     ========================= -->

<header>

    <a href="${pageContext.request.contextPath}/index.jsp"
       class="logo">

        KAWAII CRATE

    </a>


    <nav>

        <a href="${pageContext.request.contextPath}/index.jsp">
            Home
        </a>

        <a href="${pageContext.request.contextPath}/index.jsp">
            Shop
        </a>

        <a href="${pageContext.request.contextPath}/index.jsp">
            Categories
        </a>

        <a href="${pageContext.request.contextPath}/index.jsp">
            About
        </a>

    </nav>


    <div class="nav-actions">

        <a href="${pageContext.request.contextPath}/login.jsp"
           class="login-link">

            Login

        </a>


        <a href="${pageContext.request.contextPath}/register.jsp"
           class="join-btn">

            Join Us

        </a>

    </div>

</header>



<!-- =========================
     REGISTER
     ========================= -->

<main>

    <div class="auth-card">


        <div class="auth-decoration">

            ✦

        </div>


        <p class="auth-label">

            WELCOME TO KAWAII CRATE

        </p>


        <h1>

            Create Account ♡

        </h1>


        <p class="auth-subtitle">

            Join us and start your Kawaii Crate journey.

        </p>


        <% if (request.getAttribute("error") != null) { %>

            <div class="error-message">

                <%= request.getAttribute("error") %>

            </div>

        <% } %>


        <% if (request.getAttribute("success") != null) { %>

            <div class="success-message">

                <%= request.getAttribute("success") %>

            </div>

        <% } %>



        <!-- =========================
             REGISTER FORM
             ========================= -->

        <form action="${pageContext.request.contextPath}/register"
              method="post">


            <!-- NAME -->

            <div class="form-group">

                <label for="name">

                    Full Name

                </label>


                <input
                    type="text"
                    id="name"
                    name="name"
                    placeholder="Enter your full name"
                    required>

            </div>



            <!-- EMAIL -->

            <div class="form-group">

                <label for="email">

                    Email

                </label>


                <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="Enter your email"
                    required>

            </div>



            <!-- PASSWORD -->

            <div class="form-group">

                <label for="password">

                    Password

                </label>


                <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="Create a password"
                    minlength="6"
                    required>

            </div>



            <!-- CONFIRM PASSWORD -->

            <div class="form-group">

                <label for="confirmPassword">

                    Confirm Password

                </label>


                <input
                    type="password"
                    id="confirmPassword"
                    name="confirmPassword"
                    placeholder="Confirm your password"
                    minlength="6"
                    required>

            </div>



            <!-- BUTTON -->

            <button type="submit"
                    class="auth-button">

                Create Account ✦

            </button>


        </form>



        <!-- LOGIN -->

        <p class="auth-footer">

            Already have an account?

            <a href="${pageContext.request.contextPath}/login.jsp">

                Login here

            </a>

        </p>


    </div>

</main>



<!-- =========================
     FOOTER
     ========================= -->

<footer>

    <p>

        ♡ KAWAII CRATE

    </p>


    <span>

        Made with love for people who love cute things. ✦

    </span>

</footer>


</body>

</html>