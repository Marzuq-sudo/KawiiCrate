<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    com.kawaiicrate.model.User user = (com.kawaiicrate.model.User) session.getAttribute("user");
    String userName = (String) session.getAttribute("userName");

    com.kawaiicrate.dao.CartDAO cartDAO = new com.kawaiicrate.dao.CartDAO();
    java.util.List<com.kawaiicrate.model.CartItem> items = cartDAO.getCartItems(user.getId());

    java.math.BigDecimal total = java.math.BigDecimal.ZERO;
    for (com.kawaiicrate.model.CartItem i : items) total = total.add(i.getSubtotal());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart | Kawaii Crate</title>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: Georgia, "Times New Roman", serif;
            background: #f5f0e9;
            color: #112250;
            min-height: 100vh;
        }

        .navbar {
            width: 100%;
            padding: 22px 60px;
            background: #fdfbf8;
            border-bottom: 1px solid #d9cbc2;
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

        .nav-links { display: flex; gap: 30px; align-items: center; }
        .nav-links a { color: #485070; text-decoration: none; font-size: 14px; transition: 0.2s; }
        .nav-links a:hover { color: #112250; }

        .nav-user { display: flex; align-items: center; gap: 15px; }
        .welcome { color: #485070; font-size: 14px; }

        .logout {
            background: #112250;
            color: #f5f0e9;
            text-decoration: none;
            padding: 10px 18px;
            border-radius: 8px;
            font-size: 13px;
            transition: 0.25s;
        }
        .logout:hover { background: #30507d; transform: translateY(-1px); }

        .page-header {
            text-align: center;
            padding: 60px 20px 40px;
        }
        .page-header .small-title {
            color: #30507d;
            font-size: 12px;
            letter-spacing: 4px;
            margin-bottom: 12px;
        }
        .page-header h1 { font-size: 42px; font-weight: 400; color: #112250; }

        .cart-wrap {
            max-width: 1000px;
            margin: 0 auto 80px;
            padding: 0 30px;
        }

        .cart-table-card {
            background: #fdfbf8;
            border: 1px solid #d9cbc2;
            border-radius: 18px;
            padding: 30px;
            box-shadow: 0 15px 35px rgba(17, 34, 80, 0.08);
        }

        table.cart-table {
            width: 100%;
            border-collapse: collapse;
            font-family: Arial, sans-serif;
        }
        .cart-table th {
            text-align: left;
            padding: 14px 12px;
            border-bottom: 1px solid #ded6ce;
            color: #777a89;
            font-size: 11px;
            letter-spacing: 1px;
        }
        .cart-table td {
            padding: 18px 12px;
            border-bottom: 1px solid #eee8e1;
            color: #112250;
            font-size: 14px;
            vertical-align: middle;
        }
        .cart-table tr:last-child td { border-bottom: none; }

        .remove-link {
            color: #a33d3d;
            text-decoration: none;
            font-size: 12px;
            font-family: Arial, sans-serif;
            border: 1px solid #e0b4b0;
            padding: 6px 12px;
            border-radius: 20px;
            transition: 0.2s;
        }
        .remove-link:hover { background: #a33d3d; color: #fff; }

        .cart-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 2px solid #112250;
        }
        .cart-total-label {
            font-family: Arial, sans-serif;
            color: #777a89;
            font-size: 12px;
            letter-spacing: 1px;
        }
        .cart-total-amount {
            font-size: 28px;
            color: #112250;
            font-weight: bold;
        }

        .cart-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
        }

        .checkout-btn {
            background: #112250;
            color: #f5f0e9;
            border: none;
            padding: 15px 34px;
            border-radius: 10px;
            font-family: Arial, sans-serif;
            font-size: 14px;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: 0.25s;
        }
        .checkout-btn:hover { background: #30507d; transform: translateY(-2px); }

        .back-link {
            color: #485070;
            text-decoration: none;
            font-family: Arial, sans-serif;
            font-size: 13px;
        }
        .back-link:hover { color: #112250; }

        .empty-cart {
            text-align: center;
            padding: 70px 20px;
        }
        .empty-cart .icon { font-size: 45px; color: #e0c58f; margin-bottom: 18px; }
        .empty-cart h3 { font-size: 24px; font-weight: 400; margin-bottom: 10px; }
        .empty-cart p {
            font-family: Arial, sans-serif;
            color: #777a89;
            font-size: 14px;
            margin-bottom: 25px;
        }
        .shop-button {
            display: inline-block;
            background: #112250;
            color: #f5f0e9;
            text-decoration: none;
            padding: 14px 30px;
            border-radius: 10px;
            font-family: Arial, sans-serif;
            font-size: 13px;
            transition: 0.25s;
        }
        .shop-button:hover { background: #30507d; transform: translateY(-2px); }

        footer {
            background: #112250;
            color: #f5f0e9;
            text-align: center;
            padding: 35px 20px;
        }
        footer p { font-size: 18px; margin-bottom: 8px; }
        footer span { font-size: 12px; opacity: 0.75; }

        @media (max-width: 700px) {
            .navbar { padding: 18px 20px; flex-wrap: wrap; gap: 15px; }
            .nav-links { display: none; }
            .welcome { display: none; }
            .page-header h1 { font-size: 30px; }
            .cart-table-card { padding: 18px; }
            .cart-table th:nth-child(2), .cart-table td:nth-child(2) { display: none; }
            .cart-actions { flex-direction: column; gap: 18px; align-items: stretch; }
            .checkout-btn { width: 100%; }
        }
    </style>
</head>
<body>

<header class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">KAWAII CRATE</a>

    <nav class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/buyer.jsp">Shop</a>
        <a href="${pageContext.request.contextPath}/cart.jsp">Cart ♡</a>
        <a href="${pageContext.request.contextPath}/orders.jsp">My Orders</a>
    </nav>

    <div class="nav-user">
        <span class="welcome">Hi, <%= userName %> ♡</span>
        <a href="${pageContext.request.contextPath}/logout" class="logout">Logout</a>
    </div>
</header>

<div class="page-header">
    <p class="small-title">YOUR SELECTIONS</p>
    <h1>Your Cart ♡</h1>
</div>

<div class="cart-wrap">
    <% if (items.isEmpty()) { %>

        <div class="cart-table-card">
            <div class="empty-cart">
                <div class="icon">♡</div>
                <h3>Your cart is empty</h3>
                <p>Looks like you haven't added anything yet.</p>
                <a href="${pageContext.request.contextPath}/buyer.jsp" class="shop-button">Start Shopping ✦</a>
            </div>
        </div>

    <% } else { %>

        <div class="cart-table-card">
            <table class="cart-table">
                <thead>
                <tr>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Qty</th>
                    <th>Subtotal</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <% for (com.kawaiicrate.model.CartItem item : items) { %>
                    <tr>
                        <td><%= item.getProductName() %></td>
                        <td>₹<%= item.getPrice() %></td>
                        <td><%= item.getQuantity() %></td>
                        <td>₹<%= item.getSubtotal() %></td>
                        <td>
                            <a class="remove-link"
                               href="${pageContext.request.contextPath}/cart?action=remove&cartItemId=<%= item.getId() %>">
                                Remove
                            </a>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>

            <div class="cart-total">
                <span class="cart-total-label">ORDER TOTAL</span>
                <span class="cart-total-amount">₹<%= total %></span>
            </div>

            <div class="cart-actions">
                <a href="${pageContext.request.contextPath}/buyer.jsp" class="back-link">← Back to shop</a>

                <form action="${pageContext.request.contextPath}/checkout" method="post">
                    <button type="submit" class="checkout-btn">Confirm Order (Mock Payment) ✦</button>
                </form>
            </div>
        </div>

    <% } %>
</div>

<footer>
    <p>♡ KAWAII CRATE</p>
    <span>Made with love for people who love cute things. ✦</span>
</footer>

</body>
</html>
