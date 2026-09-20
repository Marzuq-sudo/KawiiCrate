<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Object sessionUserObj = session.getAttribute("user");
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    boolean loggedIn = sessionUserObj != null;

    String dashboardLink = "login.jsp";
    if (loggedIn) {
        if ("SELLER".equalsIgnoreCase(userRole)) {
            dashboardLink = "seller.jsp";
        } else if ("ADMIN".equalsIgnoreCase(userRole)) {
            dashboardLink = "admin.jsp";
        } else {
            dashboardLink = "buyer.jsp";
        }
    }

    com.kawaiicrate.dao.ProductDAO productDAO = new com.kawaiicrate.dao.ProductDAO();
    java.util.List<com.kawaiicrate.model.Product> allProducts = productDAO.getAllProducts();

    java.util.List<com.kawaiicrate.model.Product> showcaseProducts =
            allProducts.size() > 9 ? allProducts.subList(0, 9) : allProducts;

    // Most recently added product powers the "New Launch" section
    com.kawaiicrate.model.Product featured = allProducts.isEmpty() ? null : allProducts.get(0);

    java.util.LinkedHashSet<String> categorySet = new java.util.LinkedHashSet<>();
    for (com.kawaiicrate.model.Product p : allProducts) {
        if (p.getCategory() != null && !p.getCategory().trim().isEmpty()) {
            categorySet.add(p.getCategory().trim());
        }
    }
    java.util.List<String> categoryList = new java.util.ArrayList<>(categorySet);

    String[] categoryIcons = {"◇", "✦", "◈", "☆", "♡", "❖"};
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Kawaii Crate | Discover Something Extraordinary</title>

    <style>

        @import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap');

        :root {
            --sapphire: #3C507D;
            --royal: #112250;
            --quicksand: #E0C58F;
            --swan: #F5F0E9;
            --shellstone: #D9CBC2;
            --white: #ffffff;
            --text-dark: #172342;
            --muted: #aeb8cc;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { scroll-behavior: smooth; }
        body { font-family: 'Inter', sans-serif; background: var(--swan); color: var(--text-dark); }
        a { text-decoration: none; color: inherit; }
        img { display: block; max-width: 100%; }

        /* NAVBAR */
        nav {
            height: 82px;
            background: var(--royal);
            color: var(--swan);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 7%;
            position: sticky;
            top: 0;
            z-index: 100;
            border-bottom: 1px solid rgba(224, 197, 143, 0.25);
        }

        .logo {
            font-family: 'Cormorant Garamond', serif;
            font-size: 29px;
            font-weight: 600;
            letter-spacing: 2px;
            color: var(--quicksand);
        }

        .nav-links { display: flex; gap: 38px; font-size: 13px; letter-spacing: 1px; text-transform: uppercase; }
        .nav-links a { color: var(--swan); transition: 0.3s; }
        .nav-links a:hover { color: var(--quicksand); }

        .nav-actions { display: flex; align-items: center; gap: 22px; font-size: 13px; }
        .login { color: var(--swan); }

        .join {
            padding: 11px 22px;
            border: 1px solid var(--quicksand);
            color: var(--quicksand);
            transition: 0.3s;
        }
        .join:hover { background: var(--quicksand); color: var(--royal); }

        .nav-welcome { color: var(--muted); font-size: 13px; }

        /* HERO */
        .hero {
            min-height: 650px;
            background: var(--royal);
            display: grid;
            grid-template-columns: 1.05fr 0.95fr;
            align-items: center;
            padding: 75px 9%;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: "KAWAII";
            position: absolute;
            right: -80px;
            bottom: -120px;
            font-family: 'Cormorant Garamond', serif;
            font-size: 250px;
            color: rgba(255,255,255,0.025);
            letter-spacing: 20px;
        }

        .hero-content { position: relative; z-index: 2; }

        .eyebrow {
            color: var(--quicksand);
            font-size: 12px;
            letter-spacing: 4px;
            text-transform: uppercase;
            margin-bottom: 25px;
        }

        .hero h1 {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(65px, 7vw, 105px);
            line-height: 0.88;
            font-weight: 500;
            color: var(--swan);
            margin-bottom: 32px;
        }
        .hero h1 span { color: var(--quicksand); }

        .hero-description {
            color: var(--muted);
            font-size: 16px;
            line-height: 1.8;
            max-width: 500px;
            margin-bottom: 38px;
        }

        .hero-buttons { display: flex; gap: 15px; }

        .primary-btn {
            background: var(--quicksand);
            color: var(--royal);
            padding: 15px 28px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            transition: 0.3s;
            border: none;
            cursor: pointer;
            display: inline-block;
        }
        .primary-btn:hover { background: var(--swan); }

        .outline-btn {
            border: 1px solid rgba(245,240,233,0.5);
            color: var(--swan);
            padding: 15px 28px;
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            transition: 0.3s;
        }
        .outline-btn:hover { border-color: var(--quicksand); color: var(--quicksand); }

        /* HERO PRODUCT */
        .hero-product {
            position: relative;
            height: 500px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .hero-product-circle {
            width: 410px;
            height: 410px;
            border-radius: 50%;
            background: var(--sapphire);
            position: absolute;
            box-shadow: 0 0 0 1px rgba(224,197,143,0.15), 0 30px 80px rgba(0,0,0,0.3);
        }

        .hero-product img {
            position: relative;
            z-index: 2;
            width: 370px;
            height: 370px;
            object-fit: cover;
            border-radius: 8px;
        }

        .hero-product .hero-placeholder {
            position: relative;
            z-index: 2;
            font-family: 'Cormorant Garamond', serif;
            font-size: 90px;
            color: var(--quicksand);
        }

        .hero-label {
            position: absolute;
            right: 15px;
            bottom: 45px;
            z-index: 5;
            background: var(--quicksand);
            color: var(--royal);
            padding: 15px 20px;
            font-size: 11px;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        /* MARQUEE */
        .marquee {
            height: 55px;
            background: var(--quicksand);
            display: flex;
            align-items: center;
            overflow: hidden;
            color: var(--royal);
            font-family: 'Cormorant Garamond', serif;
            font-size: 17px;
            letter-spacing: 3px;
        }
        .marquee-content { white-space: nowrap; animation: move 20s linear infinite; }
        @keyframes move { from { transform: translateX(0); } to { transform: translateX(-50%); } }

        /* SECTION */
        .section { padding: 100px 8%; }

        .section-header {
            display: flex;
            align-items: end;
            justify-content: space-between;
            margin-bottom: 45px;
        }

        .section-eyebrow {
            color: var(--sapphire);
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 3px;
            text-transform: uppercase;
            margin-bottom: 10px;
        }

        .section-title {
            font-family: 'Cormorant Garamond', serif;
            font-size: 55px;
            font-weight: 500;
            color: var(--royal);
        }

        .section-description { max-width: 370px; color: #777b88; font-size: 13px; line-height: 1.8; }

        /* CATEGORIES */
        .categories {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            border-top: 1px solid var(--shellstone);
            border-bottom: 1px solid var(--shellstone);
        }

        .category {
            padding: 38px 28px;
            border-right: 1px solid var(--shellstone);
            transition: 0.3s;
        }
        .category:last-child { border-right: none; }
        .category:hover { background: var(--royal); color: var(--swan); }

        .category-number { font-size: 11px; color: var(--sapphire); margin-bottom: 35px; }
        .category:hover .category-number { color: var(--quicksand); }

        .category-icon { font-size: 35px; margin-bottom: 22px; }

        .category h3 { font-family: 'Cormorant Garamond', serif; font-size: 27px; font-weight: 600; margin-bottom: 15px; }

        .category p { font-size: 12px; line-height: 1.7; color: #858794; margin-bottom: 20px; }
        .category:hover p { color: var(--muted); }

        .category-link { font-size: 11px; text-transform: uppercase; letter-spacing: 1.5px; color: var(--sapphire); }
        .category:hover .category-link { color: var(--quicksand); }

        .no-categories { grid-column: 1 / -1; padding: 45px 20px; text-align: center; color: #777b88; }

        /* PRODUCTS */
        .products-section { background: var(--swan); }
        .products { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; }

        .product { background: white; border: 1px solid var(--shellstone); transition: 0.35s; position: relative; }
        .product:hover { transform: translateY(-7px); box-shadow: 0 25px 45px rgba(17,34,80,0.12); }

        .product-image {
            height: 330px;
            background: #ece9e4;
            position: relative;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .product-image img { width: 100%; height: 100%; object-fit: cover; transition: 0.5s; }
        .product:hover .product-image img { transform: scale(1.04); }

        .product-image-placeholder {
            font-family: 'Cormorant Garamond', serif;
            font-size: 60px;
            color: var(--shellstone);
        }

        .product-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: var(--royal);
            color: var(--quicksand);
            padding: 7px 11px;
            font-size: 9px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            z-index: 2;
        }

        .product-info { padding: 22px 23px 25px; }

        .product-category { font-size: 9px; letter-spacing: 2px; text-transform: uppercase; color: var(--sapphire); margin-bottom: 8px; }

        .product-name { font-family: 'Cormorant Garamond', serif; font-size: 28px; color: var(--royal); margin-bottom: 15px; }

        .product-bottom { display: flex; justify-content: space-between; align-items: center; }

        .price { font-size: 15px; font-weight: 700; color: var(--royal); }

        .heart {
            width: 34px;
            height: 34px;
            border: 1px solid var(--shellstone);
            background: white;
            color: var(--royal);
            cursor: pointer;
            font-size: 16px;
            transition: 0.2s;
        }
        .heart:hover { background: var(--quicksand); border-color: var(--quicksand); }

        .no-products-msg {
            grid-column: 1 / -1;
            text-align: center;
            padding: 60px 20px;
            background: white;
            border: 1px solid var(--shellstone);
            color: #777b88;
            font-size: 14px;
        }

        /* NEW LAUNCH */
        .launch {
            background: var(--royal);
            color: var(--swan);
            padding: 110px 9%;
            display: grid;
            grid-template-columns: 0.8fr 1.2fr;
            align-items: center;
            gap: 70px;
        }

        .launch-image {
            height: 520px;
            background: var(--sapphire);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        .launch-image img { width: 100%; height: 100%; object-fit: cover; }
        .launch-image .launch-placeholder { font-family: 'Cormorant Garamond', serif; font-size: 110px; color: var(--quicksand); }

        .launch-content .section-eyebrow { color: var(--quicksand); }

        .launch-title { font-family: 'Cormorant Garamond', serif; font-size: 75px; line-height: 0.9; font-weight: 500; margin-bottom: 25px; }
        .launch-title span { color: var(--quicksand); }

        .launch-text { color: var(--muted); font-size: 14px; line-height: 1.9; max-width: 480px; margin-bottom: 32px; }

        .launch-details { display: flex; gap: 35px; margin-bottom: 35px; }
        .launch-detail strong { display: block; color: var(--quicksand); font-family: 'Cormorant Garamond', serif; font-size: 25px; }
        .launch-detail span { font-size: 9px; text-transform: uppercase; letter-spacing: 1.5px; color: var(--muted); }

        /* FEATURE STRIP */
        .features { padding: 65px 8%; display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px; background: var(--shellstone); }
        .feature { display: flex; align-items: center; gap: 20px; }
        .feature-icon { width: 48px; height: 48px; border: 1px solid var(--royal); display: flex; align-items: center; justify-content: center; color: var(--royal); font-size: 20px; }
        .feature h4 { color: var(--royal); margin-bottom: 5px; font-size: 13px; text-transform: uppercase; letter-spacing: 1px; }
        .feature p { color: #706d6b; font-size: 11px; }

        /* CTA */
        .cta { background: var(--swan); text-align: center; padding: 110px 20px; }
        .cta-small { color: var(--sapphire); font-size: 11px; text-transform: uppercase; letter-spacing: 4px; margin-bottom: 18px; }
        .cta h2 { font-family: 'Cormorant Garamond', serif; font-size: 65px; font-weight: 500; color: var(--royal); margin-bottom: 20px; }
        .cta p { color: #7e7e83; font-size: 14px; margin-bottom: 32px; }

        /* FOOTER */
        footer {
            background: var(--royal);
            color: var(--swan);
            padding: 55px 8%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid rgba(224,197,143,0.2);
        }
        .footer-logo { font-family: 'Cormorant Garamond', serif; font-size: 28px; color: var(--quicksand); letter-spacing: 2px; }
        .footer-text { color: var(--muted); font-size: 11px; }
        .copyright { color: var(--muted); font-size: 10px; }

        /* RESPONSIVE */
        @media (max-width: 1000px) {
            .nav-links { display: none; }
            .hero { grid-template-columns: 1fr; text-align: center; }
            .hero-description { margin-left: auto; margin-right: auto; }
            .hero-buttons { justify-content: center; }
            .categories { grid-template-columns: repeat(2, 1fr); }
            .category:nth-child(2) { border-right: none; }
            .category:nth-child(3), .category:nth-child(4) { border-top: 1px solid var(--shellstone); }
            .products { grid-template-columns: repeat(2, 1fr); }
            .launch { grid-template-columns: 1fr; }
        }

        @media (max-width: 650px) {
            nav { padding: 0 5%; }
            .nav-actions { gap: 10px; }
            .hero { padding: 70px 6%; }
            .hero-product-circle { width: 290px; height: 290px; }
            .hero-product img { width: 270px; height: 270px; }
            .section { padding: 70px 6%; }
            .section-header { display: block; }
            .section-title { font-size: 43px; }
            .categories, .products, .features { grid-template-columns: 1fr; }
            .category { border-right: none; border-bottom: 1px solid var(--shellstone); }
            .category:last-child { border-bottom: none; }
            .product-image { height: 300px; }
            .launch { padding: 75px 6%; }
            .launch-title { font-size: 55px; }
            .launch-image { height: 400px; }
            .cta h2 { font-size: 48px; }
            footer { flex-direction: column; gap: 20px; text-align: center; }
        }

    </style>

</head>


<body>


<!-- NAVIGATION -->

<nav>

    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">♡ KAWAII CRATE</a>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="#shop">Shop</a>
        <a href="#categories">Categories</a>
        <a href="#about">About</a>
    </div>

    <div class="nav-actions">

        <% if (loggedIn) { %>

            <span class="nav-welcome">Hi, <%= userName %> ♡</span>

            <a href="${pageContext.request.contextPath}/<%= dashboardLink %>" class="join">
                Dashboard
            </a>

            <a href="${pageContext.request.contextPath}/logout" class="login">
                Logout
            </a>

        <% } else { %>

            <a href="${pageContext.request.contextPath}/login.jsp" class="login">
                Login
            </a>

            <a href="${pageContext.request.contextPath}/register.jsp" class="join">
                Join Us ♡
            </a>

        <% } %>

    </div>

</nav>


<!-- HERO -->

<section class="hero">

    <div class="hero-content">

        <div class="eyebrow">✦ Welcome to Kawaii Crate ✦</div>

        <h1>Find Your<br><span>Little Happiness.</span></h1>

        <p class="hero-description">
            A curated world of beautiful things, unexpected
            discoveries and everyday essentials made to make
            your world a little more extraordinary.
        </p>

        <div class="hero-buttons">
            <a href="#shop" class="primary-btn">Explore Collection</a>

            <% if (!loggedIn) { %>
                <a href="${pageContext.request.contextPath}/register.jsp" class="outline-btn">Create Account</a>
            <% } %>
        </div>

    </div>


    <div class="hero-product">

        <div class="hero-product-circle"></div>

        <% if (featured != null && featured.getImageUrl() != null && !featured.getImageUrl().trim().isEmpty()) { %>

            <img
                src="<%= featured.getImageUrl() %>"
                alt="<%= featured.getName() %>"
                onerror="this.onerror=null;this.style.display='none';this.parentNode.querySelector('.hero-placeholder-fallback').style.display='flex';"
            >
            <div class="hero-placeholder hero-placeholder-fallback" style="display:none;align-items:center;justify-content:center;">♡</div>

        <% } else { %>

            <div class="hero-placeholder">♡</div>

        <% } %>

        <div class="hero-label">
            <% if (featured != null) { %>
                <%= featured.getCategory() == null || featured.getCategory().isEmpty() ? "Featured" : featured.getCategory() %> · Featured
            <% } else { %>
                Coming Soon
            <% } %>
        </div>

    </div>

</section>


<!-- MARQUEE -->

<div class="marquee">
    <div class="marquee-content">
        ✦ DISCOVER · CREATE · COLLECT · ENJOY ·
        DISCOVER · CREATE · COLLECT · ENJOY ·
        ✦ DISCOVER · CREATE · COLLECT · ENJOY ·
        DISCOVER · CREATE · COLLECT · ENJOY ·
    </div>
</div>


<!-- CATEGORIES -->

<section class="section" id="categories">

    <div class="section-header">
        <div>
            <div class="section-eyebrow">Explore Our World</div>
            <h2 class="section-title">Find Your Thing.</h2>
        </div>

        <p class="section-description">
            From technology and lifestyle to sports and
            everything in between — discover something
            worth bringing home.
        </p>
    </div>


    <div class="categories">

        <% if (categoryList.isEmpty()) { %>

            <div class="no-categories">
                No categories yet — check back once sellers add products.
            </div>

        <% } else {
            int catNum = 1;
            for (String cat : categoryList) {
                if (catNum > 4) break;
                String icon = categoryIcons[(catNum - 1) % categoryIcons.length];
        %>

            <div class="category">

                <div class="category-number"><%= String.format("%02d", catNum++) %></div>
                <div class="category-icon"><%= icon %></div>
                <h3><%= cat %></h3>
                <p>Explore our <%= cat.toLowerCase() %> picks, handpicked for Kawaii Crate.</p>
                <a href="${pageContext.request.contextPath}/buyer.jsp" class="category-link">Explore →</a>

            </div>

        <% } } %>

    </div>

</section>


<!-- PRODUCTS -->

<section class="section products-section" id="shop">

    <div class="section-header">
        <div>
            <div class="section-eyebrow">Handpicked For You</div>
            <h2 class="section-title">Our Collection.</h2>
        </div>

        <p class="section-description">
            Carefully selected products with a little
            something extra. Find your next favourite.
        </p>
    </div>


    <div class="products">

        <% if (showcaseProducts.isEmpty()) { %>

            <div class="no-products-msg">
                No products available yet — sellers are still stocking the shelves. ✦
            </div>

        <% } else {
            boolean first = true;
            for (com.kawaiicrate.model.Product p : showcaseProducts) {
                String imgUrl = p.getImageUrl();
                boolean hasImage = imgUrl != null && !imgUrl.trim().isEmpty();
        %>

            <div class="product">

                <div class="product-image">

                    <% if (first) { %>
                        <div class="product-badge">Featured</div>
                    <% } %>

                    <% if (hasImage) { %>
                        <img
                            src="<%= imgUrl %>"
                            alt="<%= p.getName() %>"
                            onerror="this.onerror=null;this.style.display='none';this.parentNode.querySelector('.product-image-placeholder').style.display='flex';"
                        >
                        <div class="product-image-placeholder" style="display:none;align-items:center;justify-content:center;height:100%;width:100%;position:absolute;top:0;left:0;">♡</div>
                    <% } else { %>
                        <div class="product-image-placeholder" style="display:flex;align-items:center;justify-content:center;height:100%;width:100%;">♡</div>
                    <% } %>

                </div>

                <div class="product-info">

                    <div class="product-category">
                        <%= (p.getCategory() == null || p.getCategory().isEmpty()) ? "Kawaii Crate" : p.getCategory() %>
                    </div>

                    <div class="product-name"><%= p.getName() %></div>

                    <div class="product-bottom">
                        <span class="price">₹<%= p.getPrice() %></span>
                        <button class="heart">♡</button>
                    </div>

                </div>

            </div>

        <%
                first = false;
            }
        } %>

    </div>

    <% if (!allProducts.isEmpty()) { %>
        <div style="text-align:center;margin-top:45px;">
            <a href="${pageContext.request.contextPath}/buyer.jsp" class="outline-btn" style="color:var(--royal);border-color:var(--royal);">
                View Full Shop →
            </a>
        </div>
    <% } %>

</section>


<!-- NEW LAUNCH -->

<% if (featured != null) { %>

<section class="launch" id="about">

    <div class="launch-image">

        <% if (featured.getImageUrl() != null && !featured.getImageUrl().trim().isEmpty()) { %>
            <img
                src="<%= featured.getImageUrl() %>"
                alt="<%= featured.getName() %>"
                onerror="this.onerror=null;this.style.display='none';this.parentNode.querySelector('.launch-placeholder').style.display='flex';"
            >
            <div class="launch-placeholder" style="display:none;align-items:center;justify-content:center;height:100%;width:100%;position:absolute;top:0;left:0;">♡</div>
        <% } else { %>
            <div class="launch-placeholder" style="display:flex;align-items:center;justify-content:center;height:100%;width:100%;">♡</div>
        <% } %>

    </div>


    <div class="launch-content">

        <div class="section-eyebrow">✦ Just Arrived</div>

        <h2 class="launch-title">
            Meet the<br><span><%= featured.getName() %>.</span>
        </h2>

        <p class="launch-text">
            Something new has entered the collection.
            Meet <%= featured.getName() %> — our latest addition, designed for
            those who want something a little more extraordinary.
        </p>

        <div class="launch-details">

            <div class="launch-detail">
                <strong>NEW</strong>
                <span>Latest Launch</span>
            </div>

            <div class="launch-detail">
                <strong>₹<%= featured.getPrice() %></strong>
                <span>Price</span>
            </div>

            <div class="launch-detail">
                <strong><%= featured.getStockQty() %></strong>
                <span>In Stock</span>
            </div>

        </div>

        <a href="${pageContext.request.contextPath}/buyer.jsp" class="primary-btn">
            Discover <%= featured.getName() %>
        </a>

    </div>

</section>

<% } %>


<!-- FEATURES -->

<section class="features">

    <div class="feature">
        <div class="feature-icon">✦</div>
        <div>
            <h4>Carefully Selected</h4>
            <p>Products chosen with purpose.</p>
        </div>
    </div>

    <div class="feature">
        <div class="feature-icon">♡</div>
        <div>
            <h4>Made For You</h4>
            <p>Discover things worth keeping.</p>
        </div>
    </div>

    <div class="feature">
        <div class="feature-icon">◇</div>
        <div>
            <h4>New Every Time</h4>
            <p>Always something new to discover.</p>
        </div>
    </div>

</section>


<!-- CTA -->

<section class="cta">

    <div class="cta-small">Ready to discover?</div>

    <h2>Your next favourite<br>thing is waiting.</h2>

    <p>
        <% if (loggedIn) { %>
            Jump back into the collection and keep exploring.
        <% } else { %>
            Join Kawaii Crate and start exploring.
        <% } %>
    </p>

    <% if (loggedIn) { %>
        <a href="${pageContext.request.contextPath}/buyer.jsp" class="primary-btn">Shop Now ✦</a>
    <% } else { %>
        <a href="${pageContext.request.contextPath}/register.jsp" class="primary-btn">Create Your Account ✦</a>
    <% } %>

</section>


<!-- FOOTER -->

<footer>
    <div class="footer-logo">♡ KAWAII CRATE</div>
    <div class="footer-text">Made for people who love discovering beautiful things.</div>
    <div class="copyright">© 2026 Kawaii Crate</div>
</footer>


<script>
    document.addEventListener("DOMContentLoaded", function () {
        const hearts = document.querySelectorAll(".heart");
        hearts.forEach(function (heart) {
            heart.addEventListener("click", function () {
                if (heart.textContent.trim() === "♡") {
                    heart.textContent = "♥";
                    heart.style.background = "#E0C58F";
                    heart.style.borderColor = "#E0C58F";
                } else {
                    heart.textContent = "♡";
                    heart.style.background = "white";
                    heart.style.borderColor = "#D9CBC2";
                }
            });
        });
    });
</script>


</body>

</html>
