package com.dualaccess.servlets;

import com.dualaccess.db.DBConnection;
import com.dualaccess.util.FileEncryptionUtil;
import org.apache.tika.Tika;

import javax.crypto.SecretKey;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.security.MessageDigest;
import java.sql.*;

@MultipartConfig
public class UploadServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploaded_files";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");
        String department = (String) session.getAttribute("department");

        try {
            Part filePart = request.getPart("file");
            String fileName = getFileName(filePart);
            long fileSize = filePart.getSize();

            if (fileSize > MAX_FILE_SIZE) {
                request.setAttribute("message", "Upload failed: File size exceeds 5MB limit.");
                request.getRequestDispatcher("upload.jsp").forward(request, response);
                return;
            }

            String fileExt = getFileExtension(fileName);
            File tempFile = File.createTempFile("upload_", "_" + fileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, tempFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            // Detect MIME
            Tika tika = new Tika();
            String detectedMime = tika.detect(tempFile);

            if (!isAllowed(fileExt, detectedMime)) {
                request.setAttribute("message", "Upload failed: Unsupported file type.");
                tempFile.delete();
                request.getRequestDispatcher("upload.jsp").forward(request, response);
                return;
            }

            byte[] fileBytes = Files.readAllBytes(tempFile.toPath());
            String fileHash = sha256(fileBytes);

            try (Connection conn = DBConnection.getConnection()) {

                // Check for duplicates
                PreparedStatement check = conn.prepareStatement("SELECT COUNT(*) FROM files WHERE filehash = ?");
                check.setString(1, fileHash);
                ResultSet rs = check.executeQuery();

                if (rs.next() && rs.getInt(1) > 0) {
                    request.setAttribute("message", "Upload failed: Duplicate file already exists.");
                    tempFile.delete();
                    request.getRequestDispatcher("upload.jsp").forward(request, response);
                    return;
                }

                // Setup upload path
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String newFileName = System.currentTimeMillis() + "_" + fileName;
                String filePath = uploadPath + File.separator + newFileName;

                // Encrypt and save
                SecretKey masterKey = FileEncryptionUtil.getMasterKeyFromEnv();
                byte[] encrypted = FileEncryptionUtil.encrypt(fileBytes, masterKey);
                Files.write(Paths.get(filePath), encrypted);

                // Store metadata
                PreparedStatement insert = conn.prepareStatement(
                        "INSERT INTO files (filename, owner, department, filepath, filehash) VALUES (?, ?, ?, ?, ?)");
                insert.setString(1, newFileName);
                insert.setString(2, username);
                insert.setString(3, department);
                insert.setString(4, filePath);
                insert.setString(5, fileHash);
                insert.executeUpdate();

                // Log upload
                PreparedStatement log = conn.prepareStatement(
                        "INSERT INTO upload_log (username, filename) VALUES (?, ?)");
                log.setString(1, username);
                log.setString(2, newFileName);
                log.executeUpdate();
            }

            request.setAttribute("message", "✅ File encrypted and uploaded successfully.");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Upload failed: " + e.getMessage());
        }

        request.getRequestDispatcher("upload.jsp").forward(request, response);
    }

    private boolean isAllowed(String ext, String mime) {
        return (
            ext.matches("jpg|jpeg|png|pdf") &&
            (mime != null && (mime.equals("application/pdf") ||
                              mime.equals("image/jpeg") ||
                              mime.equals("image/png")))
        );
    }

    private String getFileExtension(String filename) {
        int dot = filename.lastIndexOf('.');
        return (dot >= 0) ? filename.substring(dot + 1).toLowerCase() : "";
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 2).replace("\"", "");
            }
        }
        return "unknown";
    }

    private String sha256(byte[] data) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(data);
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) sb.append(String.format("%02x", b));
        return sb.toString();
    }
}
