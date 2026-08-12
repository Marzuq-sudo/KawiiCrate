package com.kawaiicrate.service;

import com.kawaiicrate.dao.UserDAO;
import com.kawaiicrate.model.User;
import com.kawaiicrate.util.PasswordUtil;

public class UserService {

    private final UserDAO userDAO;

    public UserService() {
        userDAO = new UserDAO();
    }

    public User login(String email, String password) {

        User user = userDAO.findByEmail(email);

        if (user == null) {
            return null;
        }

        if (PasswordUtil.verifyPassword(password, user.getPassword())) {
            return user;
        }

        return null;
    }
}