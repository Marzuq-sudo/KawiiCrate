<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // =====================================================
    // SELLER SECURITY CHECK
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
            !"SELLER".equalsIgnoreCase(userRole)) {

        response.sendRedirect(
                request.getContextPath() + "/buyer.jsp"
        );

        return;
    }


    String sellerName =
            (String) session.getAttribute("userName");

    String sellerEmail =
            (String) session.getAttribute("userEmail");

    int sellerId =
            ((com.kawaiicrate.model.User)
                    session.getAttribute("user")).getId();


    com.kawaiicrate.dao.ProductDAO productDAO =
            new com.kawaiicrate.dao.ProductDAO();

    java.util.List<com.kawaiicrate.model.Product> myProducts =
            productDAO.getProductsBySeller(sellerId);


    // =========================================
    // REAL SALES DATA (replaces hardcoded stats)
    // =========================================

    com.kawaiicrate.dao.OrderDAO orderDAO =
            new com.kawaiicrate.dao.OrderDAO();

    java.util.List<com.kawaiicrate.model.SellerOrderItem> sales =
            orderDAO.getSalesBySeller(sellerId);

    java.util.Set<Integer> distinctOrderIds = new java.util.HashSet<>();
    int itemsSold = 0;
    java.math.BigDecimal totalEarnings = java.math.BigDecimal.ZERO;

    for (com.kawaiicrate.model.SellerOrderItem s : sales) {
        distinctOrderIds.add(s.getOrderId());
        itemsSold += s.getQuantity();
        totalEarnings = totalEarnings.add(s.getSubtotal());
    }

    int totalOrders = distinctOrderIds.size();


    String productError =
            (String) session.getAttribute("productError");

    session.removeAttribute("productError");
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Seller Dashboard | Kawaii Crate
    </title>


    <style>

        /* =====================================================
           RESET
           ===================================================== */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }


        /* =====================================================
           BODY
           ===================================================== */

        body {

            font-family:
                Georgia,
                "Times New Roman",
                serif;

            background: #f5f0e9;

            color: #112250;

            min-height: 100vh;
        }


        /* =====================================================
           LAYOUT
           ===================================================== */

        .layout {

            display: flex;

            min-height: 100vh;
        }


        /* =====================================================
           SIDEBAR
           ===================================================== */

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

            text-align: center;

            margin-bottom: 48px;
        }


        /* =====================================================
           BACK TO STOREFRONT
           ===================================================== */

        .storefront-link {

            display: block;

            text-align: center;

            color: #dfe3ec;

            text-decoration: none;

            font-size: 12px;

            margin-bottom: 20px;
        }


        .storefront-link:hover {

            color: #ffffff;
        }


        .seller-badge {

            text-align: center;

            font-family: Arial, sans-serif;

            font-size: 10px;

            letter-spacing: 3px;

            color: #e0c58f;

            margin-top: -32px;

            margin-bottom: 42px;
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


        /* =====================================================
           MAIN
           ===================================================== */

        .main {

            margin-left: 250px;

            width: calc(100% - 250px);

            padding: 45px 50px;
        }


        /* =====================================================
           TOP BAR
           ===================================================== */

        .topbar {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 45px;
        }


        .welcome h1 {

            font-size: 40px;

            font-weight: 400;

            margin-bottom: 8px;
        }


        .welcome p {

            color: #686b7b;

            font-family: Arial, sans-serif;

            font-size: 14px;
        }


        .seller-profile {

            background: #fdfbf8;

            border: 1px solid #d9cbc2;

            padding: 12px 18px;

            border-radius: 12px;

            font-family: Arial, sans-serif;

            font-size: 12px;

            color: #686b7b;
        }


        .seller-profile strong {

            color: #112250;

            display: block;

            margin-top: 3px;

            font-size: 13px;
        }


        /* =====================================================
           STATISTICS
           ===================================================== */

        .stats {

            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 20px;

            margin-bottom: 35px;
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

            margin-bottom: 17px;
        }


        .stat-label {

            font-family: Arial, sans-serif;

            color: #777a89;

            font-size: 11px;

            letter-spacing: 1px;

            margin-bottom: 8px;
        }


        .stat-number {

            font-size: 32px;

            color: #112250;
        }


        /* =====================================================
           SECTION
           ===================================================== */

        .section {

            background: #fdfbf8;

            border: 1px solid #d9cbc2;

            border-radius: 18px;

            padding: 30px;

            margin-bottom: 25px;

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

            color: #777a89;

            font-size: 12px;
        }


        /* =====================================================
           QUICK ACTIONS
           ===================================================== */

        .actions {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 18px;
        }


        .action {

            text-decoration: none;

            background: #f5f0e9;

            border: 1px solid #d9cbc2;

            border-radius: 13px;

            padding: 23px;

            transition: 0.2s;
        }


        .action:hover {

            transform: translateY(-4px);

            border-color: #30507d;

            box-shadow:
                0 10px 25px
                rgba(17, 34, 80, 0.08);
        }


        .action-icon {

            font-size: 25px;

            color: #e0c58f;

            margin-bottom: 12px;
        }


        .action h3 {

            color: #112250;

            font-size: 17px;

            font-weight: 400;

            margin-bottom: 7px;
        }


        .action p {

            color: #777a89;

            font-family: Arial, sans-serif;

            font-size: 12px;

            line-height: 1.5;
        }


        /* =====================================================
           PRODUCTS
           ===================================================== */

        .empty-products {

            border: 1px dashed #cfc4ba;

            border-radius: 12px;

            padding: 35px;

            text-align: center;

            background: #f8f4ee;
        }


        .empty-products .icon {

            font-size: 35px;

            color: #e0c58f;

            margin-bottom: 12px;
        }


        .empty-products h3 {

            font-size: 20px;

            font-weight: 400;

            margin-bottom: 8px;
        }


        .empty-products p {

            font-family: Arial, sans-serif;

            color: #777a89;

            font-size: 13px;

            line-height: 1.6;
        }


        /* =====================================================
           ORDERS
           ===================================================== */

        .orders-table {

            width: 100%;

            border-collapse: collapse;

            font-family: Arial, sans-serif;
        }


        .orders-table th {

            text-align: left;

            padding: 14px;

            border-bottom:
                1px solid #ded6ce;

            color: #777a89;

            font-size: 10px;

            letter-spacing: 1px;
        }


        .orders-table td {

            padding: 17px 14px;

            border-bottom:
                1px solid #eee8e1;

            color: #44495b;

            font-size: 13px;
        }


        .orders-table tr:last-child td {

            border-bottom: none;
        }


        .status {

            display: inline-block;

            padding: 6px 11px;

            border-radius: 20px;

            background: #eee7df;

            color: #68615a;

            font-size: 10px;

            letter-spacing: 1px;
        }

        .status-pending { background: #f7ecd4; color: #8a6d1f; }
        .status-completed { background: #e0efe1; color: #2f6b34; }
        .status-cancelled { background: #f6e0df; color: #8a3d38; }


        /* =====================================================
           FOOTER
           ===================================================== */

        .footer {

            text-align: center;

            color: #888b98;

            font-family: Arial, sans-serif;

            font-size: 11px;

            padding: 15px;

            margin-top: 10px;
        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 1100px) {

            .stats {

                grid-template-columns:
                    repeat(2, 1fr);
            }


            .actions {

                grid-template-columns:
                    1fr;
            }
        }


        @media (max-width: 750px) {

            .layout {

                display: block;
            }


            .sidebar {

                position: relative;

                width: 100%;

                height: auto;
            }


            .sidebar-bottom {

                margin-top: 25px;
            }


            .main {

                margin-left: 0;

                width: 100%;

                padding: 25px 18px;
            }


            .topbar {

                flex-direction: column;

                align-items: flex-start;

                gap: 20px;
            }


            .stats {

                grid-template-columns: 1fr;
            }
        }

    </style>

</head>


<body>


<div class="layout">


    <!-- =====================================================
         SIDEBAR
         ===================================================== -->

    <aside class="sidebar">


        <div class="brand">

            KAWAII CRATE

        </div>


        <!-- NEW: BACK TO STOREFRONT -->

        <a href="${pageContext.request.contextPath}/index.jsp"
           class="storefront-link">

            ← Back to Storefront

        </a>


        <div class="seller-badge">

            ✦ SELLER PANEL ✦

        </div>


        <div class="menu-title">

            SELLER MENU

        </div>


        <nav class="menu">

            <a href="seller.jsp"
               class="active">

                ✦ Dashboard

            </a>


            <a href="#products">

                ♡ My Products

            </a>


            <a href="#orders">

                ✦ Orders

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



    <!-- =====================================================
         MAIN
         ===================================================== -->

    <main class="main">


        <!-- =================================================
             HEADER
             ================================================= -->

        <div class="topbar">


            <div class="welcome">

                <h1>

                    Hello, <%= sellerName %> ♡

                </h1>


                <p>

                    Welcome to your Kawaii Crate seller dashboard.

                </p>

            </div>


            <div class="seller-profile">

                SELLER ACCOUNT

                <strong>
                    <%= sellerEmail %>
                </strong>

            </div>


        </div>



        <!-- =================================================
             STATISTICS (now real)
             ================================================= -->

        <section class="stats">


            <div class="stat-card">

                <div class="stat-icon">
                    ♡
                </div>

                <div class="stat-label">
                    MY PRODUCTS
                </div>

                <div class="stat-number">
                    <%= myProducts.size() %>
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">
                    ✦
                </div>

                <div class="stat-label">
                    TOTAL ORDERS
                </div>

                <div class="stat-number">
                    <%= totalOrders %>
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">
                    ♡
                </div>

                <div class="stat-label">
                    ITEMS SOLD
                </div>

                <div class="stat-number">
                    <%= itemsSold %>
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">
                    ✦
                </div>

                <div class="stat-label">
                    TOTAL EARNINGS
                </div>

                <div class="stat-number">
                    ₹<%= totalEarnings %>
                </div>

            </div>


        </section>



        <!-- =================================================
             QUICK ACTIONS
             ================================================= -->

        <section id="actions"
                 class="section">


            <div class="section-header">

                <h2>
                    Quick Actions
                </h2>

                <span>
                    Manage your shop
                </span>

            </div>


            <div class="actions">


                <a href="#products"
                   class="action">

                    <div class="action-icon">
                        ✦
                    </div>


                    <h3>
                        Add Product
                    </h3>


                    <p>
                        Add a new cute product
                        to your Kawaii Crate shop.
                    </p>

                </a>


                <a href="#products"
                   class="action">

                    <div class="action-icon">
                        ♡
                    </div>


                    <h3>
                        Manage Products
                    </h3>


                    <p>
                        View and manage the
                        products you are selling.
                    </p>

                </a>


                <a href="#orders"
                   class="action">

                    <div class="action-icon">
                        ✦
                    </div>


                    <h3>
                        View Orders
                    </h3>


                    <p>
                        Check your customer
                        orders and their status.
                    </p>

                </a>


            </div>

        </section>



        <!-- =================================================
             PRODUCTS
             ================================================= -->

        <section id="products"
                 class="section">


            <div class="section-header">

                <h2>
                    My Products
                </h2>

                <span>
                    Your shop inventory
                </span>

            </div>


            <% if (productError != null) { %>

                <div style="
                    background:#fbeceb;
                    border:1px solid #e0b4b0;
                    color:#8a3d38;
                    padding:14px 18px;
                    border-radius:10px;
                    font-family:Arial, sans-serif;
                    font-size:13px;
                    margin-bottom:20px;
                ">

                    <%= productError %>

                </div>

            <% } %>


            <form
                    action="${pageContext.request.contextPath}/addProduct"
                    method="post"
                    style="
                        display:grid;
                        grid-template-columns:repeat(2, 1fr);
                        gap:16px;
                        background:#f8f4ee;
                        border:1px solid #d9cbc2;
                        border-radius:14px;
                        padding:25px;
                        margin-bottom:30px;
                        font-family:Arial, sans-serif;
                    "
            >


                <div>

                    <label style="
                        font-size:11px;
                        letter-spacing:1px;
                        color:#777a89;
                        display:block;
                        margin-bottom:6px;
                    ">

                        PRODUCT NAME

                    </label>


                    <input
                            type="text"
                            name="name"
                            required
                            style="
                                width:100%;
                                padding:11px 13px;
                                border:1px solid #d9cbc2;
                                border-radius:8px;
                                font-family:Arial, sans-serif;
                            "
                    >

                </div>


                <div>

                    <label style="
                        font-size:11px;
                        letter-spacing:1px;
                        color:#777a89;
                        display:block;
                        margin-bottom:6px;
                    ">

                        CATEGORY

                    </label>


                    <input
                            type="text"
                            name="category"
                            placeholder="e.g. Stationery"
                            style="
                                width:100%;
                                padding:11px 13px;
                                border:1px solid #d9cbc2;
                                border-radius:8px;
                                font-family:Arial, sans-serif;
                            "
                    >

                </div>


                <div>

                    <label style="
                        font-size:11px;
                        letter-spacing:1px;
                        color:#777a89;
                        display:block;
                        margin-bottom:6px;
                    ">

                        PRICE (₹)

                    </label>


                    <input
                            type="number"
                            name="price"
                            step="0.01"
                            min="0"
                            required
                            style="
                                width:100%;
                                padding:11px 13px;
                                border:1px solid #d9cbc2;
                                border-radius:8px;
                                font-family:Arial, sans-serif;
                            "
                    >

                </div>


                <div>

                    <label style="
                        font-size:11px;
                        letter-spacing:1px;
                        color:#777a89;
                        display:block;
                        margin-bottom:6px;
                    ">

                        STOCK QUANTITY

                    </label>


                    <input
                            type="number"
                            name="stockQty"
                            min="0"
                            required
                            style="
                                width:100%;
                                padding:11px 13px;
                                border:1px solid #d9cbc2;
                                border-radius:8px;
                                font-family:Arial, sans-serif;
                            "
                    >

                </div>


                <div style="grid-column:span 2;">

                    <label style="
                        font-size:11px;
                        letter-spacing:1px;
                        color:#777a89;
                        display:block;
                        margin-bottom:6px;
                    ">

                        IMAGE URL

                    </label>


                    <input
                            type="text"
                            name="imageUrl"
                            placeholder="https://..."
                            style="
                                width:100%;
                                padding:11px 13px;
                                border:1px solid #d9cbc2;
                                border-radius:8px;
                                font-family:Arial, sans-serif;
                            "
                    >

                </div>


                <div style="grid-column:span 2;">

                    <label style="
                        font-size:11px;
                        letter-spacing:1px;
                        color:#777a89;
                        display:block;
                        margin-bottom:6px;
                    ">

                        DESCRIPTION

                    </label>


                    <textarea
                            name="description"
                            rows="3"
                            style="
                                width:100%;
                                padding:11px 13px;
                                border:1px solid #d9cbc2;
                                border-radius:8px;
                                font-family:Arial, sans-serif;
                                resize:vertical;
                            "
                    ></textarea>

                </div>


                <div style="grid-column:span 2;">

                    <button
                            type="submit"
                            style="
                                background:#112250;
                                color:#f5f0e9;
                                border:none;
                                padding:13px 24px;
                                border-radius:9px;
                                font-family:Arial, sans-serif;
                                font-size:13px;
                                letter-spacing:1px;
                                cursor:pointer;
                            "
                    >

                        ✦ ADD PRODUCT

                    </button>

                </div>


            </form>


            <% if (myProducts.isEmpty()) { %>


                <div class="empty-products">

                    <div class="icon">
                        ♡
                    </div>

                    <h3>
                        No Products Yet
                    </h3>

                    <p>
                        Your products will appear here once
                        you add them to Kawaii Crate.
                    </p>

                </div>


            <% } else { %>


                <table class="orders-table">

                    <thead>

                    <tr>

                        <th>
                            NAME
                        </th>

                        <th>
                            CATEGORY
                        </th>

                        <th>
                            PRICE
                        </th>

                        <th>
                            STOCK
                        </th>

                    </tr>

                    </thead>


                    <tbody>

                    <% for (
                            com.kawaiicrate.model.Product p
                            : myProducts
                    ) { %>

                        <tr>

                            <td>
                                <%= p.getName() %>
                            </td>

                            <td>
                                <%= (p.getCategory() == null ||
                                     p.getCategory().isEmpty())
                                        ? "—"
                                        : p.getCategory() %>
                            </td>

                            <td>
                                ₹<%= p.getPrice() %>
                            </td>

                            <td>
                                <%= p.getStockQty() %>
                            </td>

                        </tr>

                    <% } %>

                    </tbody>

                </table>


            <% } %>

        </section>



        <!-- =================================================
             ORDERS (now real)
             ================================================= -->

        <section id="orders"
                 class="section">


            <div class="section-header">

                <h2>
                    Recent Orders
                </h2>


                <span>
                    Your latest sales
                </span>

            </div>


            <table class="orders-table">

                <thead>

                <tr>

                    <th>
                        ORDER
                    </th>

                    <th>
                        CUSTOMER
                    </th>

                    <th>
                        PRODUCT
                    </th>

                    <th>
                        AMOUNT
                    </th>

                    <th>
                        STATUS
                    </th>

                </tr>

                </thead>


                <tbody>

                <% if (sales.isEmpty()) { %>

                    <tr>

                        <td colspan="5"
                            style="
                                text-align:center;
                                padding:35px;
                                color:#888b98;
                            ">

                            ♡ No orders yet ♡

                        </td>

                    </tr>

                <% } else {
                    for (com.kawaiicrate.model.SellerOrderItem s : sales) {
                        String st = s.getStatus() == null ? "PENDING" : s.getStatus();
                        String statusClass = "status status-pending";
                        if ("COMPLETED".equalsIgnoreCase(st)) statusClass = "status status-completed";
                        else if ("CANCELLED".equalsIgnoreCase(st)) statusClass = "status status-cancelled";
                %>

                    <tr>

                        <td>#<%= s.getOrderId() %></td>

                        <td><%= s.getBuyerName() %></td>

                        <td><%= s.getProductName() %> ×<%= s.getQuantity() %></td>

                        <td>₹<%= s.getSubtotal() %></td>

                        <td><span class="<%= statusClass %>"><%= st %></span></td>

                    </tr>

                <% } } %>

                </tbody>

            </table>

        </section>



        <!-- =================================================
             FOOTER
             ================================================= -->

        <div class="footer">

            ♡ KAWAII CRATE · SELLER PANEL ✦

        </div>


    </main>


</div>


</body>

</html>
