package com.kawaiicrate.dao;

import com.kawaiicrate.model.Product;
import com.kawaiicrate.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (seller_id, name, description, price, stock_qty, category, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, product.getSellerId());
            stmt.setString(2, product.getName());
            stmt.setString(3, product.getDescription());
            stmt.setBigDecimal(4, product.getPrice());
            stmt.setInt(5, product.getStockQty());
            stmt.setString(6, product.getCategory());
            stmt.setString(7, product.getImageUrl());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Product> getProductsBySeller(int sellerId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE seller_id = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sellerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) products.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) products.add(mapRow(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<Product> searchProducts(String keyword, String category) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) sql.append(" AND LOWER(name) LIKE LOWER(?)");
        if (category != null && !category.trim().isEmpty()) sql.append(" AND category = ?");
        sql.append(" ORDER BY created_at DESC");
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int i = 1;
            if (keyword != null && !keyword.trim().isEmpty()) stmt.setString(i++, "%" + keyword.trim() + "%");
            if (category != null && !category.trim().isEmpty()) stmt.setString(i++, category.trim());
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) products.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    // ---------------------------------------------------
    // NEW: one product by id (used by the edit page)
    // ---------------------------------------------------

    public Product getProductById(int productId) {
        String sql = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ---------------------------------------------------
    // NEW: update a product. The seller_id check means a
    // seller can only ever change THEIR OWN products.
    // ---------------------------------------------------

    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET name = ?, description = ?, price = ?, " +
                "stock_qty = ?, category = ?, image_url = ? " +
                "WHERE id = ? AND seller_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setInt(4, product.getStockQty());
            stmt.setString(5, product.getCategory());
            stmt.setString(6, product.getImageUrl());
            stmt.setInt(7, product.getId());
            stmt.setInt(8, product.getSellerId());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ---------------------------------------------------
    // NEW: has anyone ever ordered this product?
    // Past orders reference the product, so those products
    // can't be deleted without breaking order history.
    // ---------------------------------------------------

    public boolean hasOrders(int productId) {
        String sql = "SELECT 1 FROM order_items WHERE product_id = ? LIMIT 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return true; // if unsure, play safe and don't allow the delete
        }
    }

    // ---------------------------------------------------
    // UPDATED: delete a product (owner only). Removes the
    // product from any carts and its reviews first, because
    // those tables point at it. All three deletes happen in
    // ONE transaction: either everything goes or nothing does.
    // ---------------------------------------------------

    public boolean deleteProduct(int productId, int sellerId) {

        String ownerSql = "SELECT 1 FROM products WHERE id = ? AND seller_id = ?";
        String cartSql = "DELETE FROM cart_items WHERE product_id = ?";
        String reviewSql = "DELETE FROM reviews WHERE product_id = ?";
        String productSql = "DELETE FROM products WHERE id = ? AND seller_id = ?";

        try (Connection conn = DatabaseUtil.getConnection()) {

            conn.setAutoCommit(false);

            try {

                try (PreparedStatement owner = conn.prepareStatement(ownerSql)) {
                    owner.setInt(1, productId);
                    owner.setInt(2, sellerId);
                    try (ResultSet rs = owner.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return false; // not found, or not this seller's product
                        }
                    }
                }

                try (PreparedStatement cart = conn.prepareStatement(cartSql)) {
                    cart.setInt(1, productId);
                    cart.executeUpdate();
                }

                try (PreparedStatement review = conn.prepareStatement(reviewSql)) {
                    review.setInt(1, productId);
                    review.executeUpdate();
                }

                int deleted;
                try (PreparedStatement product = conn.prepareStatement(productSql)) {
                    product.setInt(1, productId);
                    product.setInt(2, sellerId);
                    deleted = product.executeUpdate();
                }

                conn.commit();
                return deleted > 0;

            } catch (Exception inner) {
                conn.rollback();
                throw inner;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Product mapRow(ResultSet rs) throws Exception {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setSellerId(rs.getInt("seller_id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setStockQty(rs.getInt("stock_qty"));
        product.setCategory(rs.getString("category"));
        product.setImageUrl(rs.getString("image_url"));
        return product;
    }
}