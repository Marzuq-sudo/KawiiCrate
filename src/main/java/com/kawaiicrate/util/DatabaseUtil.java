package com.kawaiicrate.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

    private static final String URL =
            System.getenv().getOrDefault(
                    "DB_URL",
                    "jdbc:postgresql://localhost:5433/kawaiicrate"
            );

    private static final String USER =
            System.getenv().getOrDefault("DB_USER", "kawaii");

    private static final String PASSWORD =
            System.getenv().getOrDefault("DB_PASSWORD", "");

    public static Connection getConnection() throws Exception {
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
