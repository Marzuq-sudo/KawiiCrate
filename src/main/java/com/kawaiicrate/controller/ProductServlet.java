package com.kawaiicrate.controller;

import com.kawaiicrate.dao.ProductDAO;
import com.kawaiicrate.model.Product;
import com.kawaiicrate.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/addProduct")
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        if (userRole == null || !"SELLER".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/buyer.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stockQty");
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("imageUrl");

        if (name == null || name.trim().isEmpty()
                || priceStr == null || priceStr.trim().isEmpty()
                || stockStr == null || stockStr.trim().isEmpty()) {
            session.setAttribute("productError", "Name, price, and stock quantity are required.");
            response.sendRedirect(request.getContextPath() + "/seller.jsp#products");
            return;
        }

        try {
            BigDecimal price = new BigDecimal(priceStr.trim());
            int stockQty = Integer.parseInt(stockStr.trim());

            if (price.compareTo(BigDecimal.ZERO) < 0 || stockQty < 0) {
                session.setAttribute("productError", "Price and stock cannot be negative.");
                response.sendRedirect(request.getContextPath() + "/seller.jsp#products");
                return;
            }

            Product product = new Product();
            product.setSellerId(sessionUser.getId());
            product.setName(name.trim());
            product.setDescription(description == null ? "" : description.trim());
            product.setPrice(price);
            product.setStockQty(stockQty);
            product.setCategory(category == null ? "" : category.trim());
            product.setImageUrl(imageUrl == null ? "" : imageUrl.trim());

            boolean added = productDAO.addProduct(product);
            if (!added) {
                session.setAttribute("productError", "Could not save product — please try again.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("productError", "Price and stock quantity must be valid numbers.");
        }

        response.sendRedirect(request.getContextPath() + "/seller.jsp#products");
    }
}