package com.kawaiicrate.dao;

import com.kawaiicrate.model.User;
import com.kawaiicrate.util.DatabaseUtil;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

// FIND USER BY EMAIL
public User findByEmail(String email) {

    String sql =
            "SELECT id, name, email, password_hash, role " +
            "FROM users " +
            "WHERE LOWER(email) = LOWER(?)";

    try (
            Connection connection = DatabaseUtil.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
    ) {

        statement.setString(1, email.trim());

        try (ResultSet result = statement.executeQuery()) {

            if (result.next()) {

                User user = new User();

                user.setId(result.getInt("id"));
                user.setName(result.getString("name"));
                user.setEmail(result.getString("email"));
                user.setPassword(result.getString("password_hash"));
                user.setRole(result.getString("role"));

                return user;
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}

// LOGIN
public User login(String email, String password) {

    User user = findByEmail(email);

    if (user == null) {
        return null;
    }

    String storedPassword = user.getPassword();

    if (storedPassword == null || storedPassword.trim().isEmpty()) {
        return null;
    }

    try {
        if (BCrypt.checkpw(password, storedPassword)) {
            return user;
        }
    } catch (IllegalArgumentException e) {
        e.printStackTrace();
    }

    return null;
}

}
