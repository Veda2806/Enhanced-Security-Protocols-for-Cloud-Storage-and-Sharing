<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = (String) request.getAttribute("message");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Create Account</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #4F46E5;
            --primary-light: #EEF2FF;
            --text: #111827;
            --text-light: #6B7280;
            --border: #E5E7EB;
            --success: #10B981;
            --error: #EF4444;
            --radius: 8px;
            --transition: all 0.2s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #F9FAFB;
            color: var(--text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .register-wrapper {
            width: 100%;
            max-width: 420px;
            margin: 0 auto;
        }

        .register-header {
            text-align: center;
            margin-bottom: 32px;
        }

        .register-header h1 {
            font-weight: 600;
            font-size: 28px;
            margin-bottom: 8px;
            color: var(--primary);
        }

        .register-header p {
            color: var(--text-light);
            font-size: 15px;
        }

        .register-form {
            background: white;
            padding: 32px;
            border-radius: var(--radius);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--border);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 500;
            color: var(--text);
        }

        .input-field {
            position: relative;
        }

        .input-field i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
            font-size: 16px;
        }

        input, select {
            width: 100%;
            padding: 12px 16px 12px 42px;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            font-size: 14px;
            transition: var(--transition);
            background-color: white;
        }

        select {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 14px center;
            background-size: 16px;
        }

        .role-select {
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%236B7280"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z"/></svg>'), 
                            url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-position: left 14px center, right 14px center;
            background-size: 16px, 16px;
            padding-left: 42px;
        }

        input:focus, select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-light);
        }

        .btn {
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: var(--radius);
            font-weight: 500;
            font-size: 15px;
            cursor: pointer;
            transition: var(--transition);
            margin-top: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn:hover {
            background: #4338CA;
        }

        .message {
            padding: 14px;
            border-radius: var(--radius);
            margin: 20px 0;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .message.success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .message.error {
            background: rgba(239, 68, 68, 0.1);
            color: var(--error);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .login-prompt {
            text-align: center;
            margin-top: 24px;
            font-size: 15px;
            color: var(--text-light);
        }

        .login-prompt a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .login-prompt a:hover {
            text-decoration: underline;
        }

        .spinner {
            display: none;
            margin: 16px auto;
            border: 3px solid rgba(79, 70, 229, 0.1);
            border-top: 3px solid var(--primary);
            border-radius: 50%;
            width: 24px;
            height: 24px;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @media (max-width: 480px) {
            .register-form {
                padding: 24px;
            }
            
            .register-header h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="register-wrapper">
        <div class="register-header">
            <h1>Get Started</h1>
            <p>Create your account in just a minute</p>
        </div>

        <div class="register-form">
            <form action="RegisterServlet" method="post" onsubmit="showSpinner()">
                <div class="form-group">
                    <label for="username">Username</label>
                    <div class="input-field">
                        <i class="fas fa-user"></i>
                        <input type="text" id="username" name="username" placeholder="Enter your username" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-field">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" name="password" placeholder="Create a password" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="role">Account Type</label>
                    <select id="role" name="role" class="role-select" required>
                        <option value="" disabled selected>Select your role</option>
                        <option value="user">Standard User</option>
                        <option value="admin">Administrator</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="department">Department</label>
                    <div class="input-field">
                        <i class="fas fa-building"></i>
                        <input type="text" id="department" name="department" placeholder="e.g. IT, Marketing" required>
                    </div>
                </div>

                <button type="submit" class="btn">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
                <div class="spinner" id="spinner"></div>
            </form>

            <% if (message != null) { %>
                <div class="message <%= message.toLowerCase().contains("success") ? "success" : "error" %>">
                    <i class="fas <%= message.toLowerCase().contains("success") ? "fa-check-circle" : "fa-exclamation-circle" %>"></i>
                    <%= message %>
                </div>
            <% } %>

            <div class="login-prompt">
                Already have an account? <a href="index.jsp">Sign in</a>
            </div>
        </div>
    </div>

    <script>
        function showSpinner() {
            document.getElementById("spinner").style.display = "block";
            document.querySelector('button[type="submit"]').disabled = true;
        }
        
        // Add real-time password validation if needed
        const passwordInput = document.getElementById('password');
        passwordInput.addEventListener('input', function() {
            // Password strength validation logic can go here
        });
    </script>
</body>
</html>