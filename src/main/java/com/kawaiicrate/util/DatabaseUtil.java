package com.kawaiicrate.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

    private static final String URL =
            "jdbc:postgresql://localhost:5433/kawaiicrate";

    private static final String USER =
            "kawaii";

    private static final String PASSWORD =
            "kawaii123";

    public static Connection getConnection() throws Exception {
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}