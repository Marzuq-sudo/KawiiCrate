<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    com.kawaiicrate.model.User user = (com.kawaiicrate.model.User) session.getAttribute("user");
    String userName = (String) session.getAttribute("userName");

    com.kawaiicrate.dao.OrderDAO orderDAO = new com.kawaiicrate.dao.OrderDAO();
    java.util.List<com.kawaiicrate.model.Order> orders = orderDAO.getOrdersByBuyer(user.getId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History | Kawaii Crate</title>

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

        .success-banner {
            max-width: 900px;
            margin: 0 auto 30px;
            background: #e9f5ea;
            border: 1px solid #b7dcb9;
            color: #2f6b34;
            padding: 16px 22px;
            border-radius: 12px;
            font-family: Arial, sans-serif;
            font-size: 14px;
            text-align: center;
        }

        .orders-wrap {
            max-width: 900px;
            margin: 0 auto 80px;
            padding: 0 30px;
        }

        .orders-card {
            background: #fdfbf8;
            border: 1px solid #d9cbc2;
            border-radius: 18px;
            padding: 30px;
            box-shadow: 0 15px 35px rgba(17, 34, 80, 0.08);
        }

        table.orders-table {
            width: 100%;
            border-collapse: collapse;
            font-family: Arial, sans-serif;
        }
        .orders-table th {
            text-align: left;
            padding: 14px 12px;
            border-bottom: 1px solid #ded6ce;
            color: #777a89;
            font-size: 11px;
            letter-spacing: 1px;
        }
        .orders-table td {
            padding: 18px 12px;
            border-bottom: 1px solid #eee8e1;
            color: #112250;
            font-size: 14px;
        }
        .orders-table tr:last-child td { border-bottom: none; }

        .status-pill {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 11px;
            letter-spacing: 0.5px;
            font-family: Arial, sans-serif;
        }
        .status-pending { background: #f7ecd4; color: #8a6d1f; }
        .status-completed { background: #e0efe1; color: #2f6b34; }
        .status-cancelled { background: #f6e0df; color: #8a3d38; }

        .back-link {
            display: inline-block;
            margin-top: 25px;
            color: #485070;
            text-decoration: none;
            font-family: Arial, sans-serif;
            font-size: 13px;
        }
        .back-link:hover { color: #112250; }

        .empty-orders {
            text-align: center;
            padding: 70px 20px;
        }
        .empty-orders .icon { font-size: 45px; color: #e0c58f; margin-bottom: 18px; }
        .empty-orders h3 { font-size: 24px; font-weight: 400; margin-bottom: 10px; }
        .empty-orders p {
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
            .orders-card { padding: 18px; }
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
    <p class="small-title">YOUR HISTORY</p>
    <h1>Order History ♡</h1>
</div>

<% if (request.getParameter("success") != null) { %>
    <div class="success-banner">✦ Order placed successfully! ✦</div>
<% } %>

<div class="orders-wrap">
    <% if (orders.isEmpty()) { %>

        <div class="orders-card">
            <div class="empty-orders">
                <div class="icon">✦</div>
                <h3>No orders yet</h3>
                <p>Once you place an order, it'll show up here.</p>
                <a href="${pageContext.request.contextPath}/buyer.jsp" class="shop-button">Start Shopping ✦</a>
            </div>
        </div>

    <% } else { %>

        <div class="orders-card">
            <table class="orders-table">
                <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Status</th>
                    <th>Total</th>
                </tr>
                </thead>
                <tbody>
                <% for (com.kawaiicrate.model.Order o : orders) {
                    String status = o.getStatus() == null ? "PENDING" : o.getStatus();
                    String pillClass = "status-pill status-pending";
                    if ("COMPLETED".equalsIgnoreCase(status)) pillClass = "status-pill status-completed";
                    else if ("CANCELLED".equalsIgnoreCase(status)) pillClass = "status-pill status-cancelled";
                %>
                    <tr>
                        <td>#<%= o.getId() %></td>
                        <td><span class="<%= pillClass %>"><%= status %></span></td>
                        <td>₹<%= o.getTotalAmount() %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <a href="${pageContext.request.contextPath}/buyer.jsp" class="back-link">← Back to shop</a>
        </div>

    <% } %>
</div>

<footer>
    <p>♡ KAWAII CRATE</p>
    <span>Made with love for people who love cute things. ✦</span>
</footer>

</body>
</html>
