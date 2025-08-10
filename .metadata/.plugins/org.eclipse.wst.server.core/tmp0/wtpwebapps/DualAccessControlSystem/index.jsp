<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dual Access Control | Secure Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />

    <style>
        :root {
            --primary-color: #2b5876;
            --secondary-color: #4e4376;
            --admin-color: #8E2DE2;
            --user-color: #00B4DB;
            --error-color: #f72585;
            --light-color: #f8f9fa;
            --dark-color: #212529;
            --border-radius: 8px;
            --box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Poppins', sans-serif;
            display: flex;
            min-height: 100vh;
            color: var(--dark-color);
        }

        .split-container { display: flex; width: 100%; height: 100vh; }

        .left-side {
            flex: 1;
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)),
                        url('images/background.jpg') center/cover no-repeat;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 3rem;
        }

        .left-content { max-width: 500px; }

        .security-badge {
            background-color: rgba(255, 255, 255, 0.1);
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            display: inline-block;
        }

        .left-side h1 { font-size: 2.5rem; margin-bottom: 1rem; }
        .left-side p { font-size: 1.1rem; opacity: 0.9; }

        .security-feature {
            display: flex;
            align-items: center;
            margin-top: 1rem;
        }

        .security-feature i {
            margin-right: 10px;
            color: var(--user-color);
        }

        .right-side {
            flex: 1;
            background-color: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }

        .login-container {
            width: 100%;
            max-width: 400px;
        }

        .access-toggle {
            display: flex;
            margin-bottom: 2rem;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--box-shadow);
        }

        .access-btn {
            flex: 1;
            padding: 12px;
            text-align: center;
            cursor: pointer;
            font-weight: 500;
            transition: var(--transition);
        }

        .access-btn.active {
            background: linear-gradient(to right, var(--admin-color), var(--user-color));
            color: white;
        }

        .access-btn:not(.active) {
            background-color: #f8f9fa;
            color: #6c757d;
        }

        .access-btn:first-child {
            border-right: 1px solid #e9ecef;
        }

        .welcome-message { margin-bottom: 2rem; }
        .welcome-message h2 { color: var(--primary-color); }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: var(--border-radius);
            font-size: 1rem;
        }

        .btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(to right, var(--admin-color), var(--user-color));
            border: none;
            color: #fff;
            font-size: 1rem;
            border-radius: var(--border-radius);
            cursor: pointer;
        }

        .error {
            color: var(--error-color);
            font-weight: bold;
            text-align: center;
            margin-top: 15px;
        }

        .forgot-password, .register-link {
            text-align: center;
            margin-top: 10px;
            font-size: 0.9rem;
        }

        .forgot-password a, .register-link a {
            color: var(--primary-color);
            text-decoration: none;
        }

        .forgot-password a:hover, .register-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .split-container { flex-direction: column; }
            .left-side { text-align: center; padding: 2rem; }
        }
    </style>
</head>
<body>
    <div class="split-container">
        <div class="left-side">
            <div class="left-content">
                <div class="security-badge">
                    <i class="fas fa-shield-alt"></i> Dual Access Control System
                </div>
                <h1>Secure Authentication Portal</h1>
                <p>Dual-level access for administrators and standard users.</p>
                <div class="security-feature">
                    <i class="fas fa-user-shield"></i> Role-based Access Control
                </div>
                <div class="security-feature">
                    <i class="fas fa-lock"></i> AES File Encryption
                </div>
                <div class="security-feature">
                    <i class="fas fa-database"></i> Cloud-Hosted Security
                </div>
            </div>
        </div>

        <div class="right-side">
            <div class="login-container">
                <div class="access-toggle">
                    <div class="access-btn active" id="adminBtn"><i class="fas fa-user-cog"></i> Admin</div>
                    <div class="access-btn" id="userBtn"><i class="fas fa-user"></i> User</div>
                </div>

                <div class="welcome-message">
                    <h2>Admin Login</h2>
                    <p>Secure credentials required</p>
                </div>

                <form action="LoginServlet" method="POST">
                    <input type="hidden" name="role" value="admin">

                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" name="username" id="username" placeholder="Enter your username" required>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" name="password" id="password" placeholder="Enter your password" required>
                    </div>

                    <button type="submit" class="btn">Log In</button>
                </form>

                <% String errorMessage = (String) request.getAttribute("errorMessage");
                   if (errorMessage != null) {
                %>
                    <p class="error"><%= errorMessage %></p>
                <% } %>

                <div class="forgot-password">
                    <a href="#">Forgot password?</a>
                </div>

                <div class="register-link">
                    Don't have an account? <a href="register.jsp">Register here</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById("adminBtn").addEventListener("click", function () {
            this.classList.add("active");
            document.getElementById("userBtn").classList.remove("active");
            document.querySelector("input[name='role']").value = "admin";
            document.querySelector(".welcome-message h2").textContent = "Admin Login";
            document.querySelector(".welcome-message p").textContent = "Secure credentials required";
        });

        document.getElementById("userBtn").addEventListener("click", function () {
            this.classList.add("active");
            document.getElementById("adminBtn").classList.remove("active");
            document.querySelector("input[name='role']").value = "user";
            document.querySelector(".welcome-message h2").textContent = "User Login";
            document.querySelector(".welcome-message p").textContent = "Access your files securely";
        });
    </script>
</body>
</html>
