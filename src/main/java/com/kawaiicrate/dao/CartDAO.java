package com.kawaiicrate.dao;

import com.kawaiicrate.model.CartItem;
import com.kawaiicrate.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public boolean addToCart(int userId, int productId, int quantity) {
        String checkSql = "SELECT id, quantity FROM cart_items WHERE user_id = ? AND product_id = ?";
        String insertSql = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)";
        String updateSql = "UPDATE cart_items SET quantity = ? WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection()) {
            try (PreparedStatement check = conn.prepareStatement(checkSql)) {
                check.setInt(1, userId);
                check.setInt(2, productId);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        int existingId = rs.getInt("id");
                        int newQty = rs.getInt("quantity") + quantity;
                        try (PreparedStatement update = conn.prepareStatement(updateSql)) {
                            update.setInt(1, newQty);
                            update.setInt(2, existingId);
                            return update.executeUpdate() > 0;
                        }
                    }
                }
            }
            try (PreparedStatement insert = conn.prepareStatement(insertSql)) {
                insert.setInt(1, userId);
                insert.setInt(2, productId);
                insert.setInt(3, quantity);
                return insert.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<CartItem> getCartItems(int userId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT c.id, c.product_id, c.quantity, p.name, p.price " +
                "FROM cart_items c JOIN products p ON c.product_id = p.id " +
                "WHERE c.user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setId(rs.getInt("id"));
                    item.setUserId(userId);
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("name"));
                    item.setPrice(rs.getBigDecimal("price"));
                    item.setQuantity(rs.getInt("quantity"));
                    items.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    public boolean removeItem(int cartItemId, int userId) {
        String sql = "DELETE FROM cart_items WHERE id = ? AND user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartItemId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart_items WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}