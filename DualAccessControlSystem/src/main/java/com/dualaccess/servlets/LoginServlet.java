package com.dualaccess.servlets;

import com.dualaccess.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("role");

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT role, department FROM users WHERE username=? AND password=?"
            );
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String actualRole = rs.getString("role");

                if (!selectedRole.equalsIgnoreCase(actualRole)) {
                    request.setAttribute("errorMessage", "Incorrect role selected.");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                    return;
                }

                // ✅ Role matches – proceed
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", actualRole);
                session.setAttribute("department", rs.getString("department"));

                response.sendRedirect("welcome.jsp");

            } else {
                request.setAttribute("errorMessage", "Invalid credentials.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Login failed: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
