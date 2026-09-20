# Kawaii Crate

Kawaii Crate is a Java-based multi-seller e-commerce web application built using JSP, Servlets, PostgreSQL, Docker, and Apache Tomcat, styled with an anime-inspired frontend aesthetic.

<img width="1399" height="796" alt="Screenshot 2026-09-20 at 10 35 24 PM" src="https://github.com/user-attachments/assets/d4cc5455-4737-459d-8cab-647d86873673" />
<img width="1399" height="796" alt="Screenshot 2026-09-20 at 10 36 12 PM" src="https://github.com/user-attachments/assets/eb0b6792-c2c9-41b6-a1e0-73138ec38644" />
<img width="1399" height="796" alt="Screenshot 2026-09-20 at 10 36 30 PM" src="https://github.com/user-attachments/assets/f5290605-6616-4919-8f96-20e3b729bb34" />

---

## Overview

Kawaii Crate supports three distinct user roles — buyers, sellers, and admins — each with their own dashboard and permissions. Authentication uses BCrypt password hashing, and role-based access is enforced through a servlet filter.

<img width="1399" height="881" alt="Screenshot 2026-09-20 at 10 37 34 PM" src="https://github.com/user-attachments/assets/c745d53c-af41-4941-b3de-209e017f97fa" />


---

## Current Features

- User Registration
  <img width="1399" height="804" alt="Screenshot 2026-09-20 at 10 38 39 PM" src="https://github.com/user-attachments/assets/0591ba0f-8b2d-4306-9f1d-847cbfd22871" />

- User Login and Logout
 <img width="1399" height="804" alt="Screenshot 2026-09-20 at 10 38 57 PM" src="https://github.com/user-attachments/assets/3fadf951-aa4c-4fb6-8582-14e5677ab8a1" />

- BCrypt Password Hashing
  <img width="1399" height="804" alt="Screenshot 2026-09-20 at 10 39 44 PM" src="https://github.com/user-attachments/assets/6eeb996b-8302-4bcc-ad8d-897769335d1d" />

- Role-based Access Control (Buyer, Seller, Admin)
- Admin Dashboard with User Management
  <img width="1399" height="804" alt="Screenshot 2026-09-20 at 10 40 31 PM" src="https://github.com/user-attachments/assets/62177df5-48b0-4e6b-95aa-e0f0496bd323" />

- Buyer Dashboard
  <img width="1399" height="804" alt="Screenshot 2026-09-20 at 10 41 11 PM" src="https://github.com/user-attachments/assets/aabd43df-1228-4d99-b76b-dbccf93519ed" />

- Seller Dashboard with Product Management
  <img width="1399" height="804" alt="Screenshot 2026-09-20 at 10 41 36 PM" src="https://github.com/user-attachments/assets/eb3c168f-8b05-4a2e-9cd9-a674777a8887" />
  <img width="1399" height="804" alt="Screenshot 2026-09-20 at 10 42 03 PM" src="https://github.com/user-attachments/assets/d5e900f3-4a17-4acc-a153-87862317eea8" />
  <img width="1399" height="804" alt="Screenshot 2026-09-20 at 10 42 28 PM" src="https://github.com/user-attachments/assets/3d700341-a6be-4a44-bb73-24eb2959f507" />

- Shopping Cart
  <img width="1399" height="804" alt="Screenshot 2026-09-20 at 10 44 28 PM" src="https://github.com/user-attachments/assets/49cae896-8762-41df-829f-3ae0e8675e4e" />

- Checkout Flow
- Order Management
  <img width="1399" height="804" alt="Screenshot 2026-09-20 at 10 44 45 PM" src="https://github.com/user-attachments/assets/65688419-3b5d-43a8-ba96-f738a41b8321" />

- PostgreSQL Database
- <img width="1424" height="900" alt="Screenshot 2026-09-20 at 10 46 00 PM" src="https://github.com/user-attachments/assets/da385083-946a-4b0f-897e-12a5c9c54cfa" />


<img width="1407" height="807" alt="Screenshot 2026-09-20 at 10 48 48 PM" src="https://github.com/user-attachments/assets/7f601013-4366-41b0-aa2b-fa7fcafc8945" />


---

## User Roles

- `BUYER`
- `SELLER`
- `ADMIN`

---

## Project Structure

```
src/main/java/com/kawaiicrate
├── controller
│   ├── AdminServlet.java
│   ├── CartServlet.java
│   ├── CheckoutServlet.java
│   ├── LoginServlet.java
│   ├── LogoutServlet.java
│   ├── ProductServlet.java
│   └── RegisterServlet.java
├── dao
│   ├── CartDAO.java
│   ├── OrderDAO.java
│   ├── ProductDAO.java
│   └── UserDAO.java
├── filter
│   └── AuthFilter.java
├── model
│   ├── CartItem.java
│   ├── Order.java
│   ├── Product.java
│   ├── SellerOrderItem.java
│   └── User.java
├── service
│   └── UserService.java
└── util
    ├── DatabaseUtil.java
    └── PasswordUtil.java

src/main/webapp
├── admin.jsp
├── buyer.jsp
├── cart.jsp
├── index.jsp
├── login.jsp
├── orders.jsp
├── register.jsp
└── seller.jsp
```


---

## Run the Project

### 1. Start Database

```bash
docker start kawaiicrate-db
```

Check if it is running:

```bash
docker ps
```

### 2. Build Project

From the KawaiiCrate project folder:

```bash
mvn clean package
```

This creates:

```
target/kawaiicrate.war
```

### 3. Copy WAR to Tomcat

```bash
cp target/kawaiicrate.war /opt/homebrew/opt/tomcat@9/libexec/webapps/kawaiicrate.war
```

### 4. Start Tomcat

```bash
/opt/homebrew/opt/tomcat@9/libexec/bin/startup.sh
```

Open:

```
http://localhost:8080/kawaiicrate/login.jsp
```

---

## Restart Tomcat

Stop:

```bash
/opt/homebrew/opt/tomcat@9/libexec/bin/shutdown.sh
```

Start:

```bash
/opt/homebrew/opt/tomcat@9/libexec/bin/startup.sh
```

---

## Database

Kawaii Crate uses a separate PostgreSQL Docker database.

| Setting   | Value            |
|-----------|------------------|
| Container | `kawaiicrate-db` |
| Database  | `kawaiicrate`    |
| User      | `kawaii`         |
| Port      | `5433`           |

Database URL:

```
jdbc:postgresql://localhost:5433/kawaiicrate
```

### Open PostgreSQL

```bash
docker exec -it kawaiicrate-db psql -U kawaii -d kawaiicrate
```

You should see:

```
kawaiicrate=#
```

### Database Shortcuts

**Show Tables**

```sql
\dt
```

**Show Users Table**

```sql
\d users
```

**Show All Users**

```sql
SELECT id, name, email, role FROM users;
```

**Show Admins**

```sql
SELECT id, name, email, role
FROM users
WHERE role = 'ADMIN';
```

**Show Sellers**

```sql
SELECT id, name, email, role
FROM users
WHERE role = 'SELLER';
```

**Show Buyers**

```sql
SELECT id, name, email, role
FROM users
WHERE role = 'BUYER';
```

**Change User to Admin**

```sql
UPDATE users
SET role = 'ADMIN'
WHERE email = 'email@example.com';
```

**Change User to Seller**

```sql
UPDATE users
SET role = 'SELLER'
WHERE email = 'email@example.com';
```

**Change User to Buyer**

```sql
UPDATE users
SET role = 'BUYER'
WHERE email = 'email@example.com';
```

**Verify Roles**

```sql
SELECT id, name, email, role FROM users;
```

**Exit PostgreSQL**

```sql
\q
```

### Stop Database

```bash
docker stop kawaiicrate-db
```

---

## Main URLs

| Page     | URL                                               |
|----------|----------------------------------------------------|
| Login    | `http://localhost:8080/kawaiicrate/login.jsp`      |
| Register | `http://localhost:8080/kawaiicrate/register.jsp`   |
| Buyer    | `http://localhost:8080/kawaiicrate/buyer.jsp`      |
| Seller   | `http://localhost:8080/kawaiicrate/seller.jsp`     |
| Admin    | `http://localhost:8080/kawaiicrate/admin.jsp`      |

---

## Quick Start

For normal development:

```bash
docker start kawaiicrate-db
mvn clean package
cp target/kawaiicrate.war /opt/homebrew/opt/tomcat@9/libexec/webapps/kawaiicrate.war
/opt/homebrew/opt/tomcat@9/libexec/bin/startup.sh
```

Then open:

```
http://localhost:8080/kawaiicrate/login.jsp
```

---

Kawaii Crate — Made with love for people who love cute things.
