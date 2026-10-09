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

/**
 * Handles EDIT and DELETE for a seller's own products.
 * (Adding a product stays in ProductServlet at /addProduct.)
 */
@WebServlet("/manageProduct")
public class ManageProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // ---------- must be logged in ----------

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // ---------- must be a seller ----------

        String userRole = (String) session.getAttribute("userRole");

        if (userRole == null || !"SELLER".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/buyer.jsp");
            return;
        }

        User seller = (User) session.getAttribute("user");

        String action = request.getParameter("action");

        int productId;

        try {
            productId = Integer.parseInt(request.getParameter("productId"));
        } catch (NumberFormatException | NullPointerException e) {
            session.setAttribute("productError", "That product could not be found.");
            response.sendRedirect(request.getContextPath() + "/seller.jsp#products");
            return;
        }

        // =====================================================
        // DELETE
        // =====================================================

        if ("delete".equals(action)) {

            // Products that were already ordered must stay, or old
            // order history would break.
            if (productDAO.hasOrders(productId)) {

                session.setAttribute(
                        "productError",
                        "This product has past orders, so it can't be deleted. " +
                        "Edit it and set the stock to 0 to stop selling it."
                );

            } else if (productDAO.deleteProduct(productId, seller.getId())) {

                session.setAttribute("productSuccess", "Product deleted.");

            } else {

                session.setAttribute(
                        "productError",
                        "Could not delete that product. It may not be yours."
                );
            }

            response.sendRedirect(request.getContextPath() + "/seller.jsp#products");
            return;
        }

        // =====================================================
        // UPDATE (edit)
        // =====================================================

        if ("update".equals(action)) {

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stockQty");
            String category = request.getParameter("category");
            String imageUrl = request.getParameter("imageUrl");

            if (name == null || name.trim().isEmpty()
                    || priceStr == null || priceStr.trim().isEmpty()
                    || stockStr == null || stockStr.trim().isEmpty()) {

                session.setAttribute(
                        "productError",
                        "Name, price, and stock quantity are required."
                );

                response.sendRedirect(request.getContextPath() + "/edit-product.jsp?id=" + productId);
                return;
            }

            try {

                BigDecimal price = new BigDecimal(priceStr.trim());
                int stockQty = Integer.parseInt(stockStr.trim());

                if (price.compareTo(BigDecimal.ZERO) < 0 || stockQty < 0) {

                    session.setAttribute(
                            "productError",
                            "Price and stock cannot be negative."
                    );

                    response.sendRedirect(request.getContextPath() + "/edit-product.jsp?id=" + productId);
                    return;
                }

                Product product = new Product();
                product.setId(productId);
                product.setSellerId(seller.getId());   // ownership is checked again in the SQL
                product.setName(name.trim());
                product.setDescription(description == null ? "" : description.trim());
                product.setPrice(price);
                product.setStockQty(stockQty);
                product.setCategory(category == null ? "" : category.trim());
                product.setImageUrl(imageUrl == null ? "" : imageUrl.trim());

                if (productDAO.updateProduct(product)) {
                    session.setAttribute("productSuccess", "Product updated.");
                } else {
                    session.setAttribute(
                            "productError",
                            "Could not update that product. It may not be yours."
                    );
                }

            } catch (NumberFormatException e) {

                session.setAttribute(
                        "productError",
                        "Price and stock quantity must be valid numbers."
                );

                response.sendRedirect(request.getContextPath() + "/edit-product.jsp?id=" + productId);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/seller.jsp#products");
            return;
        }

        // unknown action
        response.sendRedirect(request.getContextPath() + "/seller.jsp#products");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(request.getContextPath() + "/seller.jsp");
    }
}
