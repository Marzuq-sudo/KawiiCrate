package com.kawaiicrate.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

    private static final String URL =
            "jdbc:postgresql://localhost:5432/kawaiicrate";

    private static final String USER =
            "postgres";

    private static final String PASSWORD =
            "apple2023";

    public static Connection getConnection() throws Exception {

        Class.forName("org.postgresql.Driver");

        return DriverManager.getConnection(
                URL,
                USER,
                PASSWORD
        );
    }
}