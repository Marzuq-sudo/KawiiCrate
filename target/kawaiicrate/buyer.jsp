<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // =========================================
    // CHECK LOGIN
    // =========================================

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


    // =========================================
    // LOAD PRODUCTS
    // =========================================

    com.kawaiicrate.dao.ProductDAO productDAO =
            new com.kawaiicrate.dao.ProductDAO();

    java.util.List<com.kawaiicrate.model.Product> allProducts =
            productDAO.getAllProducts();
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Kawaii Crate | Shop</title>


    <style>

        /* =========================================
           RESET
           ========================================= */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }


        /* =========================================
           BODY
           ========================================= */

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

            position: sticky;

            top: 0;

            z-index: 100;
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

            gap: 30px;

            align-items: center;
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
           PRODUCTS SECTION
           ========================================= */

        .products-section {

            padding: 90px 60px;

            max-width: 1250px;

            margin: auto;
        }


        .products-heading {

            text-align: center;

            margin-bottom: 45px;
        }


        .products-heading .small-title {

            color: #30507d;

            font-size: 12px;

            letter-spacing: 4px;

            margin-bottom: 12px;
        }


        .products-heading h2 {

            color: #112250;

            font-size: 38px;

            font-weight: 400;

            margin-bottom: 12px;
        }


        .products-heading p {

            color: #6b6d7c;

            font-size: 14px;

            line-height: 1.7;
        }


        /* =========================================
           PRODUCT GRID
           ========================================= */

        .product-grid {

            display: grid;

            grid-template-columns:
                    repeat(3, minmax(0, 1fr));

            gap: 25px;
        }


        /* =========================================
           PRODUCT CARD
           ========================================= */

        .product-card {

            background: #fdfbf8;

            border: 1px solid #d9cbc2;

            border-radius: 18px;

            padding: 25px;

            transition:
                    transform 0.25s,
                    box-shadow 0.25s;

            display: flex;

            flex-direction: column;
        }


        .product-card:hover {

            transform: translateY(-5px);

            box-shadow:
                    0 15px 35px
                    rgba(17, 34, 80, 0.12);
        }


        /* =========================================
           PRODUCT IMAGE
           ========================================= */

        .product-image {

            width: 100%;

            height: 180px;

            object-fit: cover;

            border-radius: 12px;

            margin-bottom: 18px;

            background: #efe8df;

            border: 1px solid #e5ddd5;
        }


        .product-number {

            color: #e0c58f;

            font-size: 12px;

            letter-spacing: 2px;

            margin-bottom: 15px;
        }


        .product-card h3 {

            color: #112250;

            font-size: 22px;

            font-weight: 400;

            margin-bottom: 10px;
        }


        .product-category {

            color: #7b7d8d;

            font-size: 13px;

            margin-bottom: 20px;
        }


        .product-details {

            display: flex;

            justify-content: space-between;

            align-items: center;

            padding: 15px 0;

            border-top:
                    1px solid #e5ddd5;

            border-bottom:
                    1px solid #e5ddd5;

            margin-bottom: 20px;
        }


        .product-price {

            color: #112250;

            font-size: 20px;

            font-weight: bold;
        }


        .product-stock {

            color: #6b6d7c;

            font-size: 12px;
        }


        .out-of-stock {

            color: #a33d3d;

            font-weight: bold;
        }


        /* =========================================
           CART FORM
           ========================================= */

        .cart-form {

            display: flex;

            align-items: center;

            gap: 10px;

            margin-top: auto;
        }


        .quantity-input {

            width: 65px;

            height: 43px;

            border: 1px solid #d9cbc2;

            border-radius: 8px;

            background: #fff;

            color: #112250;

            padding: 8px;

            font-family: inherit;

            text-align: center;
        }


        .quantity-input:focus {

            outline: none;

            border-color: #30507d;
        }


        .cart-button {

            flex: 1;

            height: 43px;

            border: none;

            border-radius: 8px;

            background: #112250;

            color: #f5f0e9;

            font-family: inherit;

            font-size: 13px;

            cursor: pointer;

            transition: 0.25s;
        }


        .cart-button:hover {

            background: #30507d;

            transform: translateY(-1px);
        }


        .cart-button:disabled {

            background: #b8b3ae;

            cursor: not-allowed;

            transform: none;
        }


        /* =========================================
           NO PRODUCTS
           ========================================= */

        .no-products {

            grid-column: 1 / -1;

            text-align: center;

            padding: 60px 20px;

            background: #fdfbf8;

            border: 1px solid #d9cbc2;

            border-radius: 18px;

            color: #6b6d7c;
        }


        .no-products h3 {

            color: #112250;

            font-size: 24px;

            font-weight: 400;

            margin-bottom: 10px;
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
           TABLET
           ========================================= */

        @media (max-width: 950px) {

            .product-grid {

                grid-template-columns:
                        repeat(2, minmax(0, 1fr));
            }

            .navbar {

                padding: 20px 30px;
            }

            .nav-links {

                gap: 18px;
            }
        }


        /* =========================================
           MOBILE
           ========================================= */

        @media (max-width: 700px) {

            .navbar {

                padding: 18px 20px;

                flex-wrap: wrap;

                gap: 15px;
            }


            .nav-links {

                display: none;
            }


            .nav-user {

                margin-left: auto;
            }


            .welcome {

                display: none;
            }


            .hero {

                min-height: 55vh;

                padding: 60px 20px;
            }


            .hero h1 {

                font-size: 42px;
            }


            .hero p {

                font-size: 15px;
            }


            .products-section {

                padding: 60px 20px;
            }


            .products-heading h2 {

                font-size: 31px;
            }


            .product-grid {

                grid-template-columns: 1fr;
            }


            .account-card {

                width: 100%;
            }


            .features {

                padding: 60px 20px;
            }
        }

    </style>

</head>


<body>


<!-- =========================================
     NAVBAR
     ========================================= -->

<header class="navbar">

    <a href="${pageContext.request.contextPath}/index.jsp"
       class="logo">

        KAWAII CRATE

    </a>


    <nav class="nav-links">

        <a href="${pageContext.request.contextPath}/index.jsp">
            Home
        </a>

        <a href="#products">
            Shop
        </a>

        <a href="#products">
            Categories
        </a>

        <a href="#features">
            About
        </a>

        <!-- NEW: CART LINK -->
        <a href="${pageContext.request.contextPath}/cart.jsp">
            Cart ♡
        </a>

        <!-- NEW: ORDERS LINK -->
        <a href="${pageContext.request.contextPath}/orders.jsp">
            My Orders
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

            Hello,
            <span><%= userName %></span>
            ♡

        </h1>


        <p>

            Your cute little corner of the internet
            is ready for you.

            Discover adorable things,
            lovely surprises,
            and everything that makes
            your day a little sweeter.

        </p>


        <a href="#products"
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
     PRODUCTS
     ========================================= -->

<section class="products-section"
         id="products">


    <div class="products-heading">

        <p class="small-title">
            KAWAII COLLECTION
        </p>


        <h2>
            Shop Our Products
        </h2>


        <p>
            Discover something lovely from our collection.
            Add your favourites to your cart and enjoy
            your Kawaii Crate experience.
        </p>

    </div>



    <div class="product-grid">


        <%
            if (allProducts == null || allProducts.isEmpty()) {
        %>


            <div class="no-products">

                <h3>
                    No Products Available
                </h3>

                <p>
                    There are currently no products
                    available in the store.
                </p>

            </div>


        <%
            } else {

                int productNumber = 1;

                for (com.kawaiicrate.model.Product p : allProducts) {

                    boolean available = p.getStockQty() > 0;

                    String imgUrl = p.getImageUrl();
                    boolean hasImage = imgUrl != null && !imgUrl.trim().isEmpty();
        %>


            <div class="product-card">


                <!-- NEW: PRODUCT IMAGE, straight from the seller's URL -->
                <% if (hasImage) { %>

                    <img
                        class="product-image"
                        src="<%= imgUrl %>"
                        alt="<%= p.getName() %>"
                        onerror="this.onerror=null;this.style.display='none';"
                    >

                <% } %>


                <div class="product-number">

                    PRODUCT
                    <%= String.format("%02d", productNumber++) %>

                </div>


                <h3>
                    <%= p.getName() %>
                </h3>


                <p class="product-category">

                    <%= p.getCategory() %>

                </p>


                <div class="product-details">

                    <span class="product-price">

                        ₹<%= p.getPrice() %>

                    </span>


                    <span class="<%= available
                            ? "product-stock"
                            : "product-stock out-of-stock" %>">

                        <% if (available) { %>

                            Stock: <%= p.getStockQty() %>

                        <% } else { %>

                            Out of Stock

                        <% } %>

                    </span>

                </div>


                <form
                        action="${pageContext.request.contextPath}/cart"
                        method="post"
                        class="cart-form"
                >


                    <input
                            type="hidden"
                            name="productId"
                            value="<%= p.getId() %>"
                    >


                    <input
                            type="number"
                            name="quantity"
                            value="1"
                            min="1"
                            max="<%= p.getStockQty() %>"
                            class="quantity-input"
                            <%= available ? "" : "disabled" %>
                    >


                    <button
                            type="submit"
                            class="cart-button"
                            <%= available ? "" : "disabled" %>
                    >

                        <%= available
                                ? "Add to Cart"
                                : "Unavailable" %>

                    </button>


                </form>


            </div>


        <%
                }

            }
        %>


    </div>

</section>



<!-- =========================================
     FEATURES
     ========================================= -->

<section class="features"
         id="features">


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
