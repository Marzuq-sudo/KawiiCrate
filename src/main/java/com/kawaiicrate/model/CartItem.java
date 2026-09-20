package com.kawaiicrate.model;

import java.math.BigDecimal;

public class CartItem {
    private int id;
    private int userId;
    private int productId;
    private String productName;
    private BigDecimal price;
    private int quantity;

    public CartItem() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getSubtotal() { return price.multiply(BigDecimal.valueOf(quantity)); }
}