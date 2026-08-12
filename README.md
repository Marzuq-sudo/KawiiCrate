# Kawaii Crate 🎀

Kawaii Crate is a Java-based e-commerce web application built using JSP, Servlets, PostgreSQL, Docker, and Apache Tomcat.

## Current Features

- User Registration
- User Login & Logout
- BCrypt Password Hashing
- Role-based Login
- Buyer Dashboard
- Seller Dashboard
- Admin Dashboard
- PostgreSQL Database

### User Roles

- `BUYER`
- `SELLER`
- `ADMIN`

---

## 🚀 Run the Project

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

## 🔄 Restart Tomcat

Stop:

```bash
/opt/homebrew/opt/tomcat@9/libexec/bin/shutdown.sh
```

Start:

```bash
/opt/homebrew/opt/tomcat@9/libexec/bin/startup.sh
```

---

## 🗄️ Database

Kawaii Crate uses a separate PostgreSQL Docker database.

| Setting   | Value          |
|-----------|----------------|
| Container | `kawaiicrate-db` |
| Database  | `kawaiicrate`  |
| User      | `kawaii`       |
| Port      | `5433`         |

Database URL:

```
jdbc:postgresql://localhost:5433/kawaiicrate
```

### 🐘 Open PostgreSQL

```bash
docker exec -it kawaiicrate-db psql -U kawaii -d kawaiicrate
```

You should see:

```
kawaiicrate=#
```

### 🔎 Database Shortcuts

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

### 🛑 Stop Database

```bash
docker stop kawaiicrate-db
```

---

## 🔗 Main URLs

| Page     | URL |
|----------|-----|
| Login    | `http://localhost:8080/kawaiicrate/login.jsp` |
| Register | `http://localhost:8080/kawaiicrate/register.jsp` |
| Buyer    | `http://localhost:8080/kawaiicrate/buyer.jsp` |
| Seller   | `http://localhost:8080/kawaiicrate/seller.jsp` |
| Admin    | `http://localhost:8080/kawaiicrate/admin.jsp` |

---

## ⚡ Quick Start

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

💗 **Kawaii Crate** — Made with love for people who love cute things. ✦

<img width="1419" height="803" alt="Screenshot 2026-08-12 at 11 20 57 PM" src="https://github.com/user-attachments/assets/9e03139a-59b3-492e-8074-0861b1a4891a" />
<img width="1419" height="803" alt="Screenshot 2026-08-12 at 11 20 50 PM" src="https://github.com/user-attachments/assets/40260d30-2d1e-4f9f-ac75-4c204358b9a6" />
<img width="1419" height="803" alt="Screenshot 2026-08-12 at 11 20 37 PM" src="https://github.com/user-attachments/assets/35eaa3c9-dbb6-4338-8222-51243aa61ea8" />

<img width="1419" height="803" alt="Screenshot 2026-08-12 at 11 20 07 PM" src="https://github.com/user-attachments/assets/12186cf1-009a-490a-994c-0bdd5eec62d3" />
<img width="1419" height="803" alt="Screenshot 2026-08-12 at 11 19 50 PM" src="https://github.com/user-attachments/assets/0d508e4c-3663-4541-b96d-bb134250c328" />
<img width="1419" height="803" alt="Screenshot 2026-08-12 at 11 19 34 PM" src="https://github.com/user-attachments/assets/aed727f4-9d52-43b9-aa31-b6fb34033349" />
