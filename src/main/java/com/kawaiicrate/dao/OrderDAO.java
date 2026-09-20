package com.kawaiicrate.dao;

import com.kawaiicrate.model.CartItem;
import com.kawaiicrate.model.Order;
import com.kawaiicrate.model.SellerOrderItem;
import com.kawaiicrate.util.DatabaseUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int placeOrder(int buyerId, List<CartItem> items) {
        String orderSql = "INSERT INTO orders (buyer_id, status, total_amount) VALUES (?, 'PENDING', ?) RETURNING id";
        String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";

        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) {
            total = total.add(item.getSubtotal());
        }

        try (Connection conn = DatabaseUtil.getConnection()) {
            int orderId;
            try (PreparedStatement orderStmt = conn.prepareStatement(orderSql)) {
                orderStmt.setInt(1, buyerId);
                orderStmt.setBigDecimal(2, total);
                try (ResultSet rs = orderStmt.executeQuery()) {
                    rs.next();
                    orderId = rs.getInt("id");
                }
            }

            try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
                for (CartItem item : items) {
                    itemStmt.setInt(1, orderId);
                    itemStmt.setInt(2, item.getProductId());
                    itemStmt.setInt(3, item.getQuantity());
                    itemStmt.setBigDecimal(4, item.getPrice());
                    itemStmt.addBatch();
                }
                itemStmt.executeBatch();
            }

            return orderId;

        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public List<Order> getOrdersByBuyer(int buyerId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE buyer_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, buyerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("id"));
                    o.setBuyerId(rs.getInt("buyer_id"));
                    o.setStatus(rs.getString("status"));
                    o.setTotalAmount(rs.getBigDecimal("total_amount"));
                    orders.add(o);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Every line item ever sold by this seller, across all buyers/orders.
     * Powers the seller dashboard's "Recent Orders" table and stats.
     */
    public List<SellerOrderItem> getSalesBySeller(int sellerId) {
        List<SellerOrderItem> sales = new ArrayList<>();

        String sql = "SELECT o.id AS order_id, u.name AS buyer_name, p.name AS product_name, " +
                "oi.quantity, oi.unit_price, o.status " +
                "FROM order_items oi " +
                "JOIN orders o ON oi.order_id = o.id " +
                "JOIN products p ON oi.product_id = p.id " +
                "JOIN users u ON o.buyer_id = u.id " +
                "WHERE p.seller_id = ? " +
                "ORDER BY o.created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sellerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SellerOrderItem item = new SellerOrderItem();
                    item.setOrderId(rs.getInt("order_id"));
                    item.setBuyerName(rs.getString("buyer_name"));
                    item.setProductName(rs.getString("product_name"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    item.setStatus(rs.getString("status"));
                    sales.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sales;
    }
}
