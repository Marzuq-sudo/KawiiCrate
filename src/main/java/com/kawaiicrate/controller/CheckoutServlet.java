package com.kawaiicrate.controller;

import com.kawaiicrate.dao.CartDAO;
import com.kawaiicrate.dao.OrderDAO;
import com.kawaiicrate.model.CartItem;
import com.kawaiicrate.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<CartItem> items = cartDAO.getCartItems(user.getId());

        if (items.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
            return;
        }

        int orderId = orderDAO.placeOrder(user.getId(), items);

        if (orderId != -1) {
            cartDAO.clearCart(user.getId());
            response.sendRedirect(request.getContextPath() + "/orders.jsp?success=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/cart.jsp?error=1");
        }
    }
}