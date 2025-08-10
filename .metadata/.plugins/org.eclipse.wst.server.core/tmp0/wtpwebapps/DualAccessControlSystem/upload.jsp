<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.io.*" %>
<%
    // Enhanced session validation
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp?redirect=upload.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String message = (String) request.getAttribute("message");
    String fileType = (String) request.getAttribute("fileType");
    String fileSize = (String) request.getAttribute("fileSize");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload File | Secure Storage</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --success-color: #1cc88a;
            --danger-color: #e74a3b;
            --warning-color: #f6c23e;
        }
        
        body {
            font-family: 'Nunito', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #f8f9fc 0%, #e9ecef 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .upload-card {
            width: 100%;
            max-width: 500px;
            border: none;
            border-radius: 15px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            overflow: hidden;
            background-color: #fff;
        }
        
        .card-header {
            background: var(--primary-color);
            color: white;
            padding: 1.5rem;
            text-align: center;
            border-bottom: none;
        }
        
        .card-body {
            padding: 2rem;
        }
        
        .file-upload-wrapper {
            position: relative;
            margin-bottom: 1.5rem;
        }
        
        .file-upload-input {
            width: 100%;
            height: 46px;
            opacity: 0;
            position: absolute;
            top: 0;
            left: 0;
            z-index: 10;
            cursor: pointer;
        }
        
        .file-upload-label {
            display: block;
            padding: 1rem;
            border: 2px dashed #d1d3e2;
            border-radius: 8px;
            text-align: center;
            transition: all 0.3s;
        }
        
        .file-upload-label:hover {
            border-color: var(--primary-color);
            background-color: rgba(78, 115, 223, 0.05);
        }
        
        .file-upload-label i {
            font-size: 2rem;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
            display: block;
        }
        
        .file-info {
            margin-top: 1rem;
            padding: 0.75rem;
            background-color: #f8f9fc;
            border-radius: 5px;
            display: none;
        }
        
        .file-info.active {
            display: block;
        }
        
        .file-meta {
            display: flex;
            justify-content: space-between;
            margin-top: 0.5rem;
            font-size: 0.85rem;
            color: #6c757d;
        }
        
        .btn-upload {
            background-color: var(--primary-color);
            border: none;
            padding: 0.75rem;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-upload:hover {
            background-color: #2e59d9;
            transform: translateY(-1px);
        }
        
        .btn-upload:disabled {
            background-color: #b7c1e0;
            cursor: not-allowed;
        }
        
        #loader {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(255, 255, 255, 0.9);
            z-index: 9999;
            display: none;
            align-items: center;
            justify-content: center;
            flex-direction: column;
        }
        
        .spinner {
            width: 3rem;
            height: 3rem;
            border: 0.25rem solid rgba(78, 115, 223, 0.2);
            border-top-color: var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-bottom: 1rem;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .alert-message {
            margin-top: 1.5rem;
            border-radius: 8px;
            padding: 1rem;
            display: none;
        }
        
        .alert-message.show {
            display: block;
        }
        
        .back-link {
            text-align: center;
            margin-top: 1.5rem;
        }
        
        .back-link a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }
        
        .back-link a:hover {
            text-decoration: underline;
        }
        
        .progress {
            height: 8px;
            margin-top: 1rem;
            display: none;
        }
        
        .progress-bar {
            background-color: var(--primary-color);
            transition: width 0.3s ease;
        }
    </style>
</head>
<body>
    <!-- Loading Overlay -->
    <div id="loader">
        <div class="spinner"></div>
        <h4>Uploading your file...</h4>
        <p class="text-muted">Please wait while we process your file</p>
    </div>

    <div class="upload-card">
        <div class="card-header">
            <h2><i class="bi bi-cloud-arrow-up"></i> Upload File</h2>
            <p class="mb-0">Welcome, <%= username %></p>
        </div>
        
        <div class="card-body">
            <form id="uploadForm" action="UploadServlet" method="post" enctype="multipart/form-data">
                <div class="file-upload-wrapper">
                    <input type="file" name="file" id="fileInput" class="file-upload-input" required>
                    <label for="fileInput" class="file-upload-label">
                        <i class="bi bi-file-earmark-arrow-up"></i>
                        <span id="dropText">Choose a file or drag it here</span>
                        <div class="file-meta" id="fileMeta"></div>
                    </label>
                </div>
                
                <div class="file-info" id="fileInfo">
                    <strong>Selected File:</strong> <span id="fileName"></span>
                    <div class="file-meta">
                        <span id="fileTypeDisplay">Type: Not specified</span>
                        <span id="fileSizeDisplay">Size: 0 KB</span>
                    </div>
                </div>
                
                <div class="progress" id="progressBar">
                    <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                </div>
                
                <button type="submit" class="btn btn-primary btn-upload w-100" id="uploadBtn" enable>
                    <i class="bi bi-upload"></i> Upload File
                </button>
            </form>
            
            <% if (message != null) { %>
                <div class="alert-message show alert <%= message.toLowerCase().contains("success") ? "alert-success" : "alert-danger" %>">
                    <i class="bi <%= message.toLowerCase().contains("success") ? "bi-check-circle" : "bi-exclamation-triangle" %>"></i>
                    <%= message %>
                    <% if (fileType != null) { %>
                        <div class="file-meta mt-2">
                            <span>Type: <%= fileType %></span>
                            <% if (fileSize != null) { %>
                                <span>Size: <%= fileSize %></span>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            <% } %>
            
            <div class="back-link">
                <a href="welcome.jsp"><i class="bi bi-arrow-left"></i> Back to Dashboard</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // File input handling
        const fileInput = document.getElementById('fileInput');
        const fileName = document.getElementById('fileName');
        const fileInfo = document.getElementById('fileInfo');
        const fileTypeDisplay = document.getElementById('fileTypeDisplay');
        const fileSizeDisplay = document.getElementById('fileSizeDisplay');
        const uploadBtn = document.getElementById('uploadBtn');
        const dropText = document.getElementById('dropText');
        const progressBar = document.getElementById('progressBar');
        const progressBarInner = document.querySelector('.progress-bar');
        
        // Drag and drop functionality
        const uploadLabel = document.querySelector('.file-upload-label');
        
        uploadLabel.addEventListener('dragover', (e) => {
            e.preventDefault();
            uploadLabel.style.borderColor = 'var(--primary-color)';
            uploadLabel.style.backgroundColor = 'rgba(78, 115, 223, 0.1)';
            dropText.textContent = 'Drop file to upload';
        });
        
        uploadLabel.addEventListener('dragleave', () => {
            uploadLabel.style.borderColor = '#d1d3e2';
           