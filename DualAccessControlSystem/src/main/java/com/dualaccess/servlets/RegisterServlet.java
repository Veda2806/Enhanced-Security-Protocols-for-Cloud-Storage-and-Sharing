package com.dualaccess.servlets;

import com.dualaccess.db.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class RegisterServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String role = request.getParameter("role");
		String department = request.getParameter("department");

		try (Connection conn = DBConnection.getConnection()) {

			// Check if username already exists
			PreparedStatement checkUser = conn.prepareStatement("SELECT username FROM users WHERE username = ?");
			checkUser.setString(1, username);
			ResultSet rs = checkUser.executeQuery();

			if (rs.next()) {
				request.setAttribute("message", "⚠️ Username already exists. Try another.");
			} else {
				// Proceed to insert user
				PreparedStatement ps = conn.prepareStatement(
					"INSERT INTO users (username, password, role, department) VALUES (?, ?, ?, ?)"
				);
				ps.setString(1, username);
				ps.setString(2, password);
				ps.setString(3, role);
				ps.setString(4, department);

				int rows = ps.executeUpdate();

				if (rows > 0) {
					request.setAttribute("message", "Registration successful!");
				} else {
					request.setAttribute("message", "❌ Registration failed. Please try again.");
				}
			}

		} catch (Exception e) {
			request.setAttribute("message", "❌ Error: " + e.getMessage());
		}

		// Forward back to the same page regardless of result
		request.getRequestDispatcher("register.jsp").forward(request, response);
	}
}
