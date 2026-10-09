<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
    // Escapes text before it goes back into an HTML attribute / textarea
    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    // ---------- sellers only ----------

    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String userRole = (String) session.getAttribute("userRole");

    if (userRole == null || !"SELLER".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/buyer.jsp");
        return;
    }

    com.kawaiicrate.model.User seller =
            (com.kawaiicrate.model.User) session.getAttribute("user");


    // ---------- load the product ----------

    int productId = -1;

    try {
        productId = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
        // handled below
    }

    com.kawaiicrate.dao.ProductDAO productDAO = new com.kawaiicrate.dao.ProductDAO();

    com.kawaiicrate.model.Product product =
            productId > 0 ? productDAO.getProductById(productId) : null;

    // not found, or it belongs to a different seller
    if (product == null || product.getSellerId() != seller.getId()) {

        session.setAttribute("productError", "That product could not be found.");
        response.sendRedirect(request.getContextPath() + "/seller.jsp#products");
        return;
    }

    String productError = (String) session.getAttribute("productError");
    session.removeAttribute("productError");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Edit Product | Kawaii Crate</title>

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
        }

        .logo {
            color: #112250;
            text-decoration: none;
            font-size: 23px;
            font-weight: bold;
            letter-spacing: 3px;
        }

        .back {
            color: #485070;
            text-decoration: none;
            font-family: Arial, sans-serif;
            font-size: 13px;
        }

        .back:hover { color: #112250; }

        .wrap {
            max-width: 760px;
            margin: 50px auto 80px;
            padding: 0 24px;
        }

        .card {
            background: #fdfbf8;
            border: 1px solid #d9cbc2;
            border-radius: 18px;
            padding: 36px;
            box-shadow: 0 15px 35px rgba(17, 34, 80, 0.08);
        }

        .small-title {
            color: #30507d;
            font-size: 12px;
            letter-spacing: 4px;
            margin-bottom: 10px;
        }

        h1 {
            font-size: 34px;
            font-weight: 400;
            margin-bottom: 26px;
        }

        .error {
            background: #fbeceb;
            border: 1px solid #e0b4b0;
            color: #8a3d38;
            padding: 14px 18px;
            border-radius: 10px;
            font-family: Arial, sans-serif;
            font-size: 13px;
            margin-bottom: 20px;
        }

        form {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
            font-family: Arial, sans-serif;
        }

        .full { grid-column: span 2; }

        label {
            display: block;
            font-size: 11px;
            letter-spacing: 1px;
            color: #777a89;
            margin-bottom: 6px;
        }

        input, textarea {
            width: 100%;
            padding: 11px 13px;
            border: 1px solid #d9cbc2;
            border-radius: 8px;
            font-family: Arial, sans-serif;
            font-size: 14px;
            background: #fff;
            color: #112250;
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: #30507d;
        }

        textarea { resize: vertical; }

        .preview {
            max-width: 160px;
            max-height: 120px;
            border-radius: 10px;
            border: 1px solid #e5ddd5;
            object-fit: cover;
            margin-bottom: 10px;
        }

        .actions {
            display: flex;
            gap: 14px;
            align-items: center;
        }

        .save {
            background: #112250;
            color: #f5f0e9;
            border: none;
            padding: 13px 26px;
            border-radius: 9px;
            font-family: Arial, sans-serif;
            font-size: 13px;
            letter-spacing: 1px;
            cursor: pointer;
            transition: 0.25s;
            width: auto;
        }

        .save:hover { background: #30507d; }

        .cancel {
            color: #485070;
            text-decoration: none;
            font-size: 13px;
        }

        .cancel:hover { text-decoration: underline; }

        @media (max-width: 600px) {
            .navbar { padding: 18px 20px; }
            form { grid-template-columns: 1fr; }
            .full { grid-column: span 1; }
            .card { padding: 24px 20px; }
        }

    </style>

</head>

<body>


<header class="navbar">

    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">KAWAII CRATE</a>

    <a href="${pageContext.request.contextPath}/seller.jsp#products" class="back">← Back to dashboard</a>

</header>


<div class="wrap">

    <div class="card">

        <p class="small-title">SELLER PANEL</p>

        <h1>Edit Product ✦</h1>


        <% if (productError != null) { %>

            <div class="error"><%= productError %></div>

        <% } %>


        <form action="${pageContext.request.contextPath}/manageProduct"
              method="post">

            <input type="hidden" name="action" value="update">
            <input type="hidden" name="productId" value="<%= product.getId() %>">


            <div>
                <label for="name">PRODUCT NAME</label>
                <input type="text" id="name" name="name" required
                       value="<%= esc(product.getName()) %>">
            </div>

            <div>
                <label for="category">CATEGORY</label>
                <input type="text" id="category" name="category"
                       value="<%= esc(product.getCategory()) %>">
            </div>

            <div>
                <label for="price">PRICE (₹)</label>
                <input type="number" id="price" name="price" step="0.01" min="0" required
                       value="<%= product.getPrice() %>">
            </div>

            <div>
                <label for="stockQty">STOCK QUANTITY</label>
                <input type="number" id="stockQty" name="stockQty" min="0" required
                       value="<%= product.getStockQty() %>">
            </div>

            <div class="full">

                <label for="imageUrl">IMAGE URL</label>

                <% if (product.getImageUrl() != null && !product.getImageUrl().trim().isEmpty()) { %>

                    <img class="preview"
                         src="<%= esc(product.getImageUrl()) %>"
                         alt="Current image"
                         onerror="this.style.display='none';">

                <% } %>

                <input type="text" id="imageUrl" name="imageUrl" placeholder="https://..."
                       value="<%= esc(product.getImageUrl()) %>">

            </div>

            <div class="full">
                <label for="description">DESCRIPTION</label>
                <textarea id="description" name="description" rows="4"><%= esc(product.getDescription()) %></textarea>
            </div>

            <div class="full actions">

                <button type="submit" class="save">✦ SAVE CHANGES</button>

                <a class="cancel"
                   href="${pageContext.request.contextPath}/seller.jsp#products">Cancel</a>

            </div>

        </form>

    </div>

</div>


</body>

</html>
