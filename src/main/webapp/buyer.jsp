<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Check whether the user is logged in
    if (session.getAttribute("user") == null) {
        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
        return;
    }

    String userName =
            (String) session.getAttribute("userName");

    String userEmail =
            (String) session.getAttribute("userEmail");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Kawaii Crate | Home</title>

    <style>

        /* =========================================
           RESET
           ========================================= */

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


        /* =========================================
           NAVBAR
           ========================================= */

        .navbar {

            width: 100%;

            padding: 22px 60px;

            background: #fdfbf8;

            border-bottom:
                1px solid #d9cbc2;

            display: flex;

            align-items: center;

            justify-content: space-between;
        }


        .logo {

            color: #112250;

            text-decoration: none;

            font-size: 23px;

            font-weight: bold;

            letter-spacing: 3px;
        }


        .nav-links {

            display: flex;

            gap: 35px;
        }


        .nav-links a {

            color: #485070;

            text-decoration: none;

            font-size: 14px;

            transition: 0.2s;
        }


        .nav-links a:hover {

            color: #112250;
        }


        .nav-user {

            display: flex;

            align-items: center;

            gap: 15px;
        }


        .welcome {

            color: #485070;

            font-size: 14px;
        }


        .logout {

            background: #112250;

            color: #f5f0e9;

            text-decoration: none;

            padding: 10px 18px;

            border-radius: 8px;

            font-size: 13px;

            transition: 0.25s;
        }


        .logout:hover {

            background: #30507d;

            transform: translateY(-1px);
        }


        /* =========================================
           HERO
           ========================================= */

        .hero {

            min-height: 65vh;

            display: flex;

            justify-content: center;

            align-items: center;

            text-align: center;

            padding: 70px 20px;
        }


        .hero-content {

            max-width: 750px;
        }


        .star {

            font-size: 35px;

            color: #e0c58f;

            margin-bottom: 20px;
        }


        .label {

            color: #30507d;

            font-size: 12px;

            letter-spacing: 5px;

            margin-bottom: 18px;
        }


        .hero h1 {

            font-size: 58px;

            font-weight: 400;

            color: #112250;

            margin-bottom: 20px;
        }


        .hero h1 span {

            color: #30507d;
        }


        .hero p {

            color: #485070;

            font-size: 17px;

            line-height: 1.8;

            margin-bottom: 35px;
        }


        .shop-button {

            display: inline-block;

            background: #112250;

            color: #f5f0e9;

            text-decoration: none;

            padding: 16px 35px;

            border-radius: 10px;

            font-size: 14px;

            transition: 0.25s;
        }


        .shop-button:hover {

            background: #30507d;

            transform: translateY(-2px);
        }


        /* =========================================
           ACCOUNT CARD
           ========================================= */

        .account-section {

            padding: 20px;

            display: flex;

            justify-content: center;
        }


        .account-card {

            width: 500px;

            background: #fdfbf8;

            border: 1px solid #d9cbc2;

            border-radius: 20px;

            padding: 35px;

            box-shadow:
                0 15px 40px
                rgba(17, 34, 80, 0.10);
        }


        .account-card h2 {

            color: #112250;

            font-size: 28px;

            font-weight: 400;

            margin-bottom: 25px;
        }


        .account-row {

            display: flex;

            justify-content: space-between;

            padding: 15px 0;

            border-bottom:
                1px solid #e5ddd5;
        }


        .account-row:last-child {

            border-bottom: none;
        }


        .account-label {

            color: #7b7d8d;

            font-size: 13px;
        }


        .account-value {

            color: #112250;

            font-size: 14px;

            font-weight: 600;
        }


        /* =========================================
           FEATURES
           ========================================= */

        .features {

            padding: 70px 50px;

            text-align: center;
        }


        .features h2 {

            font-size: 32px;

            font-weight: 400;

            margin-bottom: 40px;
        }


        .feature-container {

            display: flex;

            justify-content: center;

            gap: 25px;

            flex-wrap: wrap;
        }


        .feature {

            width: 250px;

            background: #fdfbf8;

            border: 1px solid #d9cbc2;

            border-radius: 16px;

            padding: 30px 20px;
        }


        .feature-icon {

            font-size: 28px;

            color: #e0c58f;

            margin-bottom: 15px;
        }


        .feature h3 {

            font-size: 18px;

            font-weight: 400;

            margin-bottom: 10px;
        }


        .feature p {

            color: #6b6d7c;

            font-size: 13px;

            line-height: 1.6;
        }


        /* =========================================
           FOOTER
           ========================================= */

        footer {

            background: #112250;

            color: #f5f0e9;

            text-align: center;

            padding: 35px 20px;

            margin-top: 50px;
        }


        footer p {

            font-size: 18px;

            margin-bottom: 8px;
        }


        footer span {

            font-size: 12px;

            opacity: 0.75;
        }


        /* =========================================
           MOBILE
           ========================================= */

        @media (max-width: 800px) {

            .navbar {

                padding: 20px;
            }


            .nav-links {

                display: none;
            }


            .hero h1 {

                font-size: 42px;
            }


            .hero p {

                font-size: 15px;
            }


            .account-card {

                width: 100%;
            }

        }

    </style>

</head>


<body>


<!-- =========================================
     NAVBAR
     ========================================= -->

<header class="navbar">

    <a href="buyer.jsp"
       class="logo">

        KAWAII CRATE

    </a>


    <nav class="nav-links">

        <a href="buyer.jsp">
            Home
        </a>

        <a href="#">
            Shop
        </a>

        <a href="#">
            Categories
        </a>

        <a href="#">
            About
        </a>

    </nav>


    <div class="nav-user">

        <span class="welcome">

            Hi, <%= userName %> ♡

        </span>


        <a href="${pageContext.request.contextPath}/logout"
           class="logout">

            Logout

        </a>

    </div>

</header>



<!-- =========================================
     HERO
     ========================================= -->

<section class="hero">

    <div class="hero-content">

        <div class="star">
            ✦
        </div>


        <p class="label">
            WELCOME TO KAWAII CRATE
        </p>


        <h1>

            Hello, <span><%= userName %></span> ♡

        </h1>


        <p>

            Your cute little corner of the internet
            is ready for you.

            Discover adorable things,
            lovely surprises,
            and everything that makes
            your day a little sweeter.

        </p>


        <a href="#"
           class="shop-button">

            Explore the Collection ✦

        </a>

    </div>

</section>



<!-- =========================================
     ACCOUNT
     ========================================= -->

<section class="account-section">

    <div class="account-card">

        <h2>
            Your Account ♡
        </h2>


        <div class="account-row">

            <span class="account-label">
                Name
            </span>

            <span class="account-value">
                <%= userName %>
            </span>

        </div>


        <div class="account-row">

            <span class="account-label">
                Email
            </span>

            <span class="account-value">
                <%= userEmail %>
            </span>

        </div>


        <div class="account-row">

            <span class="account-label">
                Account Type
            </span>

            <span class="account-value">
                Buyer
            </span>

        </div>

    </div>

</section>



<!-- =========================================
     FEATURES
     ========================================= -->

<section class="features">

    <h2>
        Made for Cute Things ✦
    </h2>


    <div class="feature-container">


        <div class="feature">

            <div class="feature-icon">
                ♡
            </div>

            <h3>
                Cute Collection
            </h3>

            <p>
                Discover adorable products
                selected especially for
                kawaii lovers.
            </p>

        </div>



        <div class="feature">

            <div class="feature-icon">
                ✦
            </div>

            <h3>
                Lovely Finds
            </h3>

            <p>
                Find little things that
                make ordinary days feel
                extra special.
            </p>

        </div>



        <div class="feature">

            <div class="feature-icon">
                ♡
            </div>

            <h3>
                Happy Shopping
            </h3>

            <p>
                Enjoy a simple and pleasant
                shopping experience
                at Kawaii Crate.
            </p>

        </div>


    </div>

</section>



<!-- =========================================
     FOOTER
     ========================================= -->

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