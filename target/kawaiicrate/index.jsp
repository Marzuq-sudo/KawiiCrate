<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--swan);
            color: var(--text-dark);
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        img {
            display: block;
            max-width: 100%;
        }

        /* =========================
           NAVBAR
        ========================= */

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

        .nav-links {
            display: flex;
            gap: 38px;
            font-size: 13px;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .nav-links a {
            color: var(--swan);
            transition: 0.3s;
        }

        .nav-links a:hover {
            color: var(--quicksand);
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 22px;
            font-size: 13px;
        }

        .login {
            color: var(--swan);
        }

        .join {
            padding: 11px 22px;
            border: 1px solid var(--quicksand);
            color: var(--quicksand);
            transition: 0.3s;
        }

        .join:hover {
            background: var(--quicksand);
            color: var(--royal);
        }

        /* =========================
           HERO
        ========================= */

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

        .hero-content {
            position: relative;
            z-index: 2;
        }

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

        .hero h1 span {
            color: var(--quicksand);
        }

        .hero-description {
            color: var(--muted);
            font-size: 16px;
            line-height: 1.8;

            max-width: 500px;

            margin-bottom: 38px;
        }

        .hero-buttons {
            display: flex;
            gap: 15px;
        }

        .primary-btn {
            background: var(--quicksand);
            color: var(--royal);

            padding: 15px 28px;

            font-size: 12px;
            font-weight: 700;

            letter-spacing: 1.5px;
            text-transform: uppercase;

            transition: 0.3s;
        }

        .primary-btn:hover {
            background: var(--swan);
        }

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

        .outline-btn:hover {
            border-color: var(--quicksand);
            color: var(--quicksand);
        }

        /* =========================
           HERO PRODUCT
        ========================= */

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

            box-shadow:
                0 0 0 1px rgba(224,197,143,0.15),
                0 30px 80px rgba(0,0,0,0.3);
        }

        .hero-product img {
            position: relative;
            z-index: 2;

            width: 370px;
            height: 370px;

            object-fit: contain;

            mix-blend-mode: multiply;

            border-radius: 8px;
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

        /* =========================
           MARQUEE
        ========================= */

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

        .marquee-content {
            white-space: nowrap;
            animation: move 20s linear infinite;
        }

        @keyframes move {

            from {
                transform: translateX(0);
            }

            to {
                transform: translateX(-50%);
            }

        }

        /* =========================
           SECTION
        ========================= */

        .section {
            padding: 100px 8%;
        }

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

        .section-description {
            max-width: 370px;

            color: #777b88;

            font-size: 13px;

            line-height: 1.8;
        }

        /* =========================
           CATEGORIES
        ========================= */

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

        .category:last-child {
            border-right: none;
        }

        .category:hover {
            background: var(--royal);
            color: var(--swan);
        }

        .category-number {
            font-size: 11px;
            color: var(--sapphire);

            margin-bottom: 35px;
        }

        .category:hover .category-number {
            color: var(--quicksand);
        }

        .category-icon {
            font-size: 35px;
            margin-bottom: 22px;
        }

        .category h3 {
            font-family: 'Cormorant Garamond', serif;

            font-size: 27px;

            font-weight: 600;

            margin-bottom: 15px;
        }

        .category p {
            font-size: 12px;

            line-height: 1.7;

            color: #858794;

            margin-bottom: 20px;
        }

        .category:hover p {
            color: var(--muted);
        }

        .category-link {
            font-size: 11px;

            text-transform: uppercase;

            letter-spacing: 1.5px;

            color: var(--sapphire);
        }

        .category:hover .category-link {
            color: var(--quicksand);
        }

        /* =========================
           PRODUCTS
        ========================= */

        .products-section {
            background: var(--swan);
        }

        .products {
            display: grid;

            grid-template-columns: repeat(3, 1fr);

            gap: 25px;
        }

        .product {
            background: white;

            border: 1px solid var(--shellstone);

            transition: 0.35s;

            position: relative;
        }

        .product:hover {
            transform: translateY(-7px);

            box-shadow: 0 25px 45px rgba(17,34,80,0.12);
        }

        .product-image {
            height: 330px;

            background: #ece9e4;

            position: relative;

            overflow: hidden;

            display: flex;
            justify-content: center;
            align-items: center;
        }

        .product-image img {
            width: 100%;
            height: 100%;

            object-fit: cover;

            transition: 0.5s;
        }

        .product:hover .product-image img {
            transform: scale(1.04);
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

        .product-info {
            padding: 22px 23px 25px;
        }

        .product-category {
            font-size: 9px;

            letter-spacing: 2px;

            text-transform: uppercase;

            color: var(--sapphire);

            margin-bottom: 8px;
        }

        .product-name {
            font-family: 'Cormorant Garamond', serif;

            font-size: 28px;

            color: var(--royal);

            margin-bottom: 15px;
        }

        .product-bottom {
            display: flex;

            justify-content: space-between;

            align-items: center;
        }

        .price {
            font-size: 15px;

            font-weight: 700;

            color: var(--royal);
        }

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

        .heart:hover {
            background: var(--quicksand);

            border-color: var(--quicksand);
        }

        /* =========================
           NEW LAUNCH
        ========================= */

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

        .launch-image img {
            width: 100%;
            height: 100%;

            object-fit: cover;
        }

        .launch-content .section-eyebrow {
            color: var(--quicksand);
        }

        .launch-title {
            font-family: 'Cormorant Garamond', serif;

            font-size: 75px;

            line-height: 0.9;

            font-weight: 500;

            margin-bottom: 25px;
        }

        .launch-title span {
            color: var(--quicksand);
        }

        .launch-text {
            color: var(--muted);

            font-size: 14px;

            line-height: 1.9;

            max-width: 480px;

            margin-bottom: 32px;
        }

        .launch-details {
            display: flex;

            gap: 35px;

            margin-bottom: 35px;
        }

        .launch-detail strong {
            display: block;

            color: var(--quicksand);

            font-family: 'Cormorant Garamond', serif;

            font-size: 25px;
        }

        .launch-detail span {
            font-size: 9px;

            text-transform: uppercase;

            letter-spacing: 1.5px;

            color: var(--muted);
        }

        /* =========================
           FEATURE STRIP
        ========================= */

        .features {
            padding: 65px 8%;

            display: grid;

            grid-template-columns: repeat(3, 1fr);

            gap: 30px;

            background: var(--shellstone);
        }

        .feature {
            display: flex;

            align-items: center;

            gap: 20px;
        }

        .feature-icon {
            width: 48px;
            height: 48px;

            border: 1px solid var(--royal);

            display: flex;

            align-items: center;

            justify-content: center;

            color: var(--royal);

            font-size: 20px;
        }

        .feature h4 {
            color: var(--royal);

            margin-bottom: 5px;

            font-size: 13px;

            text-transform: uppercase;

            letter-spacing: 1px;
        }

        .feature p {
            color: #706d6b;

            font-size: 11px;
        }

        /* =========================
           CTA
        ========================= */

        .cta {
            background: var(--swan);

            text-align: center;

            padding: 110px 20px;
        }

        .cta-small {
            color: var(--sapphire);

            font-size: 11px;

            text-transform: uppercase;

            letter-spacing: 4px;

            margin-bottom: 18px;
        }

        .cta h2 {
            font-family: 'Cormorant Garamond', serif;

            font-size: 65px;

            font-weight: 500;

            color: var(--royal);

            margin-bottom: 20px;
        }

        .cta p {
            color: #7e7e83;

            font-size: 14px;

            margin-bottom: 32px;
        }

        /* =========================
           FOOTER
        ========================= */

        footer {
            background: var(--royal);

            color: var(--swan);

            padding: 55px 8%;

            display: flex;

            justify-content: space-between;

            align-items: center;

            border-top: 1px solid rgba(224,197,143,0.2);
        }

        .footer-logo {
            font-family: 'Cormorant Garamond', serif;

            font-size: 28px;

            color: var(--quicksand);

            letter-spacing: 2px;
        }

        .footer-text {
            color: var(--muted);

            font-size: 11px;
        }

        .copyright {
            color: var(--muted);

            font-size: 10px;
        }

        /* =========================
           RESPONSIVE
        ========================= */

        @media (max-width: 1000px) {

            .nav-links {
                display: none;
            }

            .hero {
                grid-template-columns: 1fr;

                text-align: center;
            }

            .hero-description {
                margin-left: auto;
                margin-right: auto;
            }

            .hero-buttons {
                justify-content: center;
            }

            .categories {
                grid-template-columns: repeat(2, 1fr);
            }

            .category:nth-child(2) {
                border-right: none;
            }

            .category:nth-child(3),
            .category:nth-child(4) {
                border-top: 1px solid var(--shellstone);
            }

            .products {
                grid-template-columns: repeat(2, 1fr);
            }

            .launch {
                grid-template-columns: 1fr;
            }

        }

        @media (max-width: 650px) {

            nav {
                padding: 0 5%;
            }

            .nav-actions {
                gap: 10px;
            }

            .hero {
                padding: 70px 6%;
            }

            .hero-product-circle {
                width: 290px;
                height: 290px;
            }

            .hero-product img {
                width: 270px;
                height: 270px;
            }

            .section {
                padding: 70px 6%;
            }

            .section-header {
                display: block;
            }

            .section-title {
                font-size: 43px;
            }

            .categories,
            .products,
            .features {
                grid-template-columns: 1fr;
            }

            .category {
                border-right: none;
                border-bottom: 1px solid var(--shellstone);
            }

            .category:last-child {
                border-bottom: none;
            }

            .product-image {
                height: 300px;
            }

            .launch {
                padding: 75px 6%;
            }

            .launch-title {
                font-size: 55px;
            }

            .launch-image {
                height: 400px;
            }

            .cta h2 {
                font-size: 48px;
            }

            footer {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }

        }

    </style>

</head>


<body>


<!-- =========================
     NAVIGATION
========================= -->

<nav>

    <a href="index.jsp" class="logo">
        ♡ KAWAII CRATE
    </a>

    <div class="nav-links">

        <a href="index.jsp">Home</a>

        <a href="#shop">Shop</a>

        <a href="#categories">Categories</a>

        <a href="#about">About</a>

    </div>

    <div class="nav-actions">

        <a href="login.jsp" class="login">
            Login
        </a>

        <a href="register.jsp" class="join">
            Join Us ♡
        </a>

    </div>

</nav>


<!-- =========================
     HERO
========================= -->

<section class="hero">

    <div class="hero-content">

        <div class="eyebrow">
            ✦ Welcome to Kawaii Crate ✦
        </div>

        <h1>
            Find Your<br>
            <span>Little Happiness.</span>
        </h1>

        <p class="hero-description">
            A curated world of beautiful things, unexpected
            discoveries and everyday essentials made to make
            your world a little more extraordinary.
        </p>

        <div class="hero-buttons">

            <a href="#shop" class="primary-btn">
                Explore Collection
            </a>

            <a href="register.jsp" class="outline-btn">
                Create Account
            </a>

        </div>

    </div>


    <div class="hero-product">

        <div class="hero-product-circle"></div>

        <!-- ONLY THE HERO IMAGE HAS BEEN CHANGED -->
        <img
            src="https://i.pinimg.com/736x/82/54/be/8254bed4c3d1dd2408600a80fd2fb239.jpg"
            alt="Featured Product"
        >

        <div class="hero-label">
            PERFUME · Featured
        </div>

    </div>

</section>


<!-- =========================
     MARQUEE
========================= -->

<div class="marquee">

    <div class="marquee-content">

        ✦ DISCOVER · CREATE · COLLECT · ENJOY ·
        DISCOVER · CREATE · COLLECT · ENJOY ·

        ✦ DISCOVER · CREATE · COLLECT · ENJOY ·
        DISCOVER · CREATE · COLLECT · ENJOY ·

    </div>

</div>


<!-- =========================
     CATEGORIES
========================= -->

<section class="section" id="categories">

    <div class="section-header">

        <div>

            <div class="section-eyebrow">
                Explore Our World
            </div>

            <h2 class="section-title">
                Find Your Thing.
            </h2>

        </div>

        <p class="section-description">
            From technology and lifestyle to sports and
            everything in between — discover something
            worth bringing home.
        </p>

    </div>


    <div class="categories">


        <div class="category">

            <div class="category-number">
                01
            </div>

            <div class="category-icon">
                ◇
            </div>

            <h3>
                Technology
            </h3>

            <p>
                Discover the latest devices and gadgets
                designed for modern life.
            </p>

            <a href="#shop" class="category-link">
                Explore →
            </a>

        </div>


        <div class="category">

            <div class="category-number">
                02
            </div>

            <div class="category-icon">
                ✦
            </div>

            <h3>
                Lifestyle
            </h3>

            <p>
                Beautiful pieces that bring comfort and
                character to your everyday world.
            </p>

            <a href="#shop" class="category-link">
                Explore →
            </a>

        </div>


        <div class="category">

            <div class="category-number">
                03
            </div>

            <div class="category-icon">
                ◈
            </div>

            <h3>
                Sports
            </h3>

            <p>
                Gear up with products made for movement,
                performance and adventure.
            </p>

            <a href="#shop" class="category-link">
                Explore →
            </a>

        </div>


        <div class="category">

            <div class="category-number">
                04
            </div>

            <div class="category-icon">
                ☆
            </div>

            <h3>
                More
            </h3>

            <p>
                Explore unusual finds and products that
                deserve a place in your collection.
            </p>

            <a href="#shop" class="category-link">
                Explore →
            </a>

        </div>


    </div>

</section>


<!-- =========================
     PRODUCTS
========================= -->

<section class="section products-section" id="shop">

    <div class="section-header">

        <div>

            <div class="section-eyebrow">
                Handpicked For You
            </div>

            <h2 class="section-title">
                Our Collection.
            </h2>

        </div>

        <p class="section-description">
            Carefully selected products with a little
            something extra. Find your next favourite.
        </p>

    </div>


    <div class="products">


        <!-- PRODUCT 1 -->

        <div class="product">

            <div class="product-image">

                <div class="product-badge">
                    Featured
                </div>

                <img
                    src="https://i.pinimg.com/1200x/7b/b7/8c/7bb78ce1d918d6782ea0287e4026776f.jpg"
                    alt="Packet Watch"
                >

            </div>

            <div class="product-info">

                <div class="product-category">
                    Accessories
                </div>

                <div class="product-name">
                    Packet Watch
                </div>

                <div class="product-bottom">

                    <span class="price">
                        ₹4,999
                    </span>

                    <button class="heart">
                        ♡
                    </button>

                </div>

            </div>

        </div>


        <!-- PRODUCT 2 -->

        <div class="product">

            <div class="product-image">

                <div class="product-badge">
                    New Launch
                </div>

                <img
                    src="https://i.pinimg.com/1200x/92/5a/95/925a9587d80a4257281d90cb3e5ea77f.jpg"
                    alt="PS7"
                >

            </div>

            <div class="product-info">

                <div class="product-category">
                    Technology
                </div>

                <div class="product-name">
                    PS7
                </div>

                <div class="product-bottom">

                    <span class="price">
                        ₹59,999
                    </span>

                    <button class="heart">
                        ♡
                    </button>

                </div>

            </div>

        </div>


        <!-- PRODUCT 3 -->

        <div class="product">

            <div class="product-image">

                <img
                    src="https://i.pinimg.com/736x/96/f5/81/96f581d8f994ac99f247c69836e0c4ad.jpg"
                    alt="Mac18"
                >

            </div>

            <div class="product-info">

                <div class="product-category">
                    Technology
                </div>

                <div class="product-name">
                    Mac18
                </div>

                <div class="product-bottom">

                    <span class="price">
                        ₹1,49,999
                    </span>

                    <button class="heart">
                        ♡
                    </button>

                </div>

            </div>

        </div>


        <!-- PRODUCT 4 -->

        <div class="product">

            <div class="product-image">

                <img
                    src="https://i.pinimg.com/736x/fe/d5/8e/fed58e642901c86c8462d631e7ee9967.jpg"
                    alt="iPhone 20"
                >

            </div>

            <div class="product-info">

                <div class="product-category">
                    Technology
                </div>

                <div class="product-name">
                    iPhone 20
                </div>

                <div class="product-bottom">

                    <span class="price">
                        ₹1,29,999
                    </span>

                    <button class="heart">
                        ♡
                    </button>

                </div>

            </div>

        </div>


        <!-- PRODUCT 5 -->

        <div class="product">

            <div class="product-image">

                <img
                    src="https://i.pinimg.com/1200x/10/c9/27/10c9274b7ca2b50f2be535b9ef1c83eb.jpg"
                    alt="Mikasa Volleyball"
                >

            </div>

            <div class="product-info">

                <div class="product-category">
                    Sports
                </div>

                <div class="product-name">
                    Mikasa Volleyball
                </div>

                <div class="product-bottom">

                    <span class="price">
                        ₹2,499
                    </span>

                    <button class="heart">
                        ♡
                    </button>

                </div>

            </div>

        </div>


        <!-- PRODUCT 6 -->

        <div class="product">

            <div class="product-image">

                <img
                    src="https://i.pinimg.com/1200x/e2/4a/18/e24a181957461a7bc19eb483e411bd5f.jpg"
                    alt="MTB Cycle"
                >

            </div>

            <div class="product-info">

                <div class="product-category">
                    Sports
                </div>

                <div class="product-name">
                    MTB Cycle
                </div>

                <div class="product-bottom">

                    <span class="price">
                        ₹34,999
                    </span>

                    <button class="heart">
                        ♡
                    </button>

                </div>

            </div>

        </div>


        <!-- PRODUCT 7 -->

        <div class="product">

            <div class="product-image">

                <img
                    src="https://i.pinimg.com/736x/aa/b7/7e/aab77efbf6b4ede1aadd57c035033f75.jpg"
                    alt="Jumpjet"
                >

            </div>

            <div class="product-info">

                <div class="product-category">
                    Lifestyle
                </div>

                <div class="product-name">
                    Jumpjet
                </div>

                <div class="product-bottom">

                    <span class="price">
                        ₹7,999
                    </span>

                    <button class="heart">
                        ♡
                    </button>

                </div>

            </div>

        </div>


        <!-- PRODUCT 8 -->

        <div class="product">

            <div class="product-image">

                <img
                    src="https://i.pinimg.com/1200x/ee/22/00/ee220034175e87fc9105ee789f6ea7b4.jpg"
                    alt="Sofa"
                >

            </div>

            <div class="product-info">

                <div class="product-category">
                    Lifestyle
                </div>

                <div class="product-name">
                    Cloud Sofa
                </div>

                <div class="product-bottom">

                    <span class="price">
                        ₹49,999
                    </span>

                    <button class="heart">
                        ♡
                    </button>

                </div>

            </div>

        </div>


        <!-- PRODUCT 9 -->

        <div class="product">

            <div class="product-image">

                <img
                    src="https://i.pinimg.com/736x/88/3e/d2/883ed262aa18e5342242284b7acffb6c.jpg"
                    alt="Shuriken"
                >

            </div>

            <div class="product-info">

                <div class="product-category">
                    Collection
                </div>

                <div class="product-name">
                    Shuriken
                </div>

                <div class="product-bottom">

                    <span class="price">
                        ₹1,999
                    </span>

                    <button class="heart">
                        ♡
                    </button>

                </div>

            </div>

        </div>


    </div>

</section>


<!-- =========================
     NEW LAUNCH
========================= -->

<section class="launch" id="about">


    <div class="launch-image">

        <img
            src="https://i.pinimg.com/1200x/92/5a/95/925a9587d80a4257281d90cb3e5ea77f.jpg"
            alt="PS7 New Launch"
        >

    </div>


    <div class="launch-content">

        <div class="section-eyebrow">
            ✦ Just Arrived
        </div>

        <h2 class="launch-title">
            Meet the<br>
            <span>PS7.</span>
        </h2>

        <p class="launch-text">
            Something new has entered the collection.
            Meet PS7 — our latest launch, designed for
            those who want performance, style and something
            that feels different.
        </p>


        <div class="launch-details">

            <div class="launch-detail">

                <strong>NEW</strong>

                <span>
                    Latest Launch
                </span>

            </div>


            <div class="launch-detail">

                <strong>PS7</strong>

                <span>
                    Featured Product
                </span>

            </div>


            <div class="launch-detail">

                <strong>01</strong>

                <span>
                    Collection
                </span>

            </div>

        </div>


        <a href="#shop" class="primary-btn">
            Discover PS7
        </a>

    </div>


</section>


<!-- =========================
     FEATURES
========================= -->

<section class="features">


    <div class="feature">

        <div class="feature-icon">
            ✦
        </div>

        <div>

            <h4>
                Carefully Selected
            </h4>

            <p>
                Products chosen with purpose.
            </p>

        </div>

    </div>


    <div class="feature">

        <div class="feature-icon">
            ♡
        </div>

        <div>

            <h4>
                Made For You
            </h4>

            <p>
                Discover things worth keeping.
            </p>

        </div>

    </div>


    <div class="feature">

        <div class="feature-icon">
            ◇
        </div>

        <div>

            <h4>
                New Every Time
            </h4>

            <p>
                Always something new to discover.
            </p>

        </div>

    </div>


</section>


<!-- =========================
     CTA
========================= -->

<section class="cta">

    <div class="cta-small">
        Ready to discover?
    </div>

    <h2>
        Your next favourite<br>
        thing is waiting.
    </h2>

    <p>
        Join Kawaii Crate and start exploring.
    </p>

    <a href="register.jsp" class="primary-btn">
        Create Your Account ✦
    </a>

</section>


<!-- =========================
     FOOTER
========================= -->

<footer>

    <div class="footer-logo">
        ♡ KAWAII CRATE
    </div>

    <div class="footer-text">
        Made for people who love discovering beautiful things.
    </div>

    <div class="copyright">
        © 2026 Kawaii Crate
    </div>

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