package com.dualaccess.servlets;

import com.dualaccess.db.DBConnection;
import com.dualaccess.util.FileEncryptionUtil;

import javax.crypto.SecretKey;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Files;
import java.sql.*;

public class DownloadServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String filename = request.getParameter("file");
        if (filename == null || filename.trim().isEmpty()) {
            session.setAttribute("downloadError", "❌ Invalid file request.");
            response.sendRedirect("download.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");
        String department = (String) session.getAttribute("department");
        String mode = request.getParameter("mode"); // preview or null

        try (Connection conn = DBConnection.getConnection()) {

            // ✅ User-based download rate limiting
            if (!"preview".equalsIgnoreCase(mode)) {
                try (PreparedStatement userLimit = conn.prepareStatement(
                        "SELECT COUNT(*) FROM download_log WHERE username=? AND download_time > NOW() - INTERVAL 10 MINUTE")) {
                    userLimit.setString(1, username);
                    try (ResultSet rs = userLimit.executeQuery()) {
                        if (rs.next() && rs.getInt(1) >= 5) {
                            session.setAttribute("downloadError", "❌ You have exceeded 5 downloads in 10 minutes. Please try again later.");
                            response.sendRedirect("download.jsp");
                            return;
                        }
                    }
                }
            }

            // ✅ Check file access permissions
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT filepath, department FROM files WHERE filename=?")) {
                ps.setString(1, filename);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String filePath = rs.getString("filepath");
                        String fileDept = rs.getString("department");

                        if (!department.equalsIgnoreCase(fileDept) && !"admin".equalsIgnoreCase(role)) {
                            session.setAttribute("downloadError", "❌ Access denied: You are not authorized to download this file.");
                            response.sendRedirect("download.jsp");
                            return;
                        }

                        File file = new File(filePath);
                        if (!file.exists()) {
                            session.setAttribute("downloadError", "❌ File not found on the server.");
                            response.sendRedirect("download.jsp");
                            return;
                        }

                        // ✅ Decrypt the file
                        byte[] encryptedBytes = Files.readAllBytes(file.toPath());
                        SecretKey key = FileEncryptionUtil.getMasterKeyFromEnv();
                        byte[] decryptedBytes = FileEncryptionUtil.decrypt(encryptedBytes, key);

                        // ✅ Log the download
                        if (!"preview".equalsIgnoreCase(mode)) {
                            try (PreparedStatement logStmt = conn.prepareStatement(
                                    "INSERT INTO download_log (username, file_name, download_time) VALUES (?, ?, NOW())")) {
                                logStmt.setString(1, username);
                                logStmt.setString(2, filename);
                                logStmt.executeUpdate();
                            }
                        }

                        // ✅ Set headers
                        String mimeType = getServletContext().getMimeType(filename);
                        if (mimeType == null) mimeType = "application/octet-stream";
                        response.setContentType(mimeType);

                        if (!"preview".equalsIgnoreCase(mode)) {
                            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
                        }

                        // ✅ Stream decrypted file to client
                        try (OutputStream os = response.getOutputStream()) {
                            os.write(decryptedBytes);
                        }

                    } else {
                        session.setAttribute("downloadError", "❌ File not found in the database.");
                        response.sendRedirect("download.jsp");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("downloadError", "❌ Error during download: " + e.getMessage());
            response.sendRedirect("download.jsp");
        }
    }
}
