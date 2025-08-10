<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*, com.dualaccess.db.DBConnection" %>

<%
if (session == null || session.getAttribute("username") == null) {
    response.sendRedirect("index.jsp");
    return;
}

String department = (String) session.getAttribute("department");
String username = (String) session.getAttribute("username");
String userIP = request.getRemoteAddr();
boolean canDownload = true;
Timestamp lastDownloadTime = null;

try (Connection conn = DBConnection.getConnection()) {
    PreparedStatement stmt = conn.prepareStatement(
        "SELECT download_time FROM download_log WHERE username=? ORDER BY download_time DESC LIMIT 1");
    stmt.setString(1, username);
    ResultSet rs = stmt.executeQuery();
    if (rs.next()) {
        lastDownloadTime = rs.getTimestamp("download_time");
        long timeSinceLastDownload = System.currentTimeMillis() - lastDownloadTime.getTime();
        canDownload = (timeSinceLastDownload > 10 * 60 * 1000); // 10 minutes in milliseconds
    }
} catch (Exception e) {
    canDownload = false; // fallback to prevent downloads if error occurs
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Download Files - <%= department %> Department</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --accent-color: #4895ef;
            --dark-color: #1a1a2e;
            --light-color: #f8f9fa;
            --success-color: #4cc9f0;
            --warning-color: #f8961e;
            --danger-color: #f72585;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            padding: 2rem 0;
        }

        .container-bg {
            background-color: rgba(255, 255, 255, 0.98);
            padding: 2.5rem;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header-section {
            margin-bottom: 2.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        }

        .file-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            text-align: center;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            height: 100%;
            border: none;
            position: relative;
            overflow: hidden;
        }

        .file-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 20px rgba(0, 0, 0, 0.15);
        }

        .file-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--primary-color);
            transition: all 0.3s ease;
        }

        .file-card:hover::before {
            width: 6px;
            background: var(--accent-color);
        }

        .file-preview {
            width: 100%;
            height: 160px;
            object-fit: contain;
            border-radius: 8px;
            margin-bottom: 1rem;
            background-color: #f8f9fa;
            padding: 0.5rem;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .file-name {
            font-weight: 600;
            font-size: 1.05rem;
            margin-bottom: 1rem;
            word-break: break-word;
            color: var(--dark-color);
        }

        .download-btn {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            border: none;
            padding: 0.5rem 1.25rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .download-btn:hover {
            background: linear-gradient(135deg, var(--accent-color) 0%, var(--primary-color) 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
            color: white;
        }

        .download-btn:disabled {
            background: #e9ecef;
            color: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .download-status {
            background-color: var(--light-color);
            border-radius: 50px;
            padding: 0.5rem 1rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .ip-display {
            font-size: 0.85rem;
            color: #6c757d;
            background-color: rgba(108, 117, 125, 0.1);
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }

        .file-icon {
            font-size: 4rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
            opacity: 0.8;
        }

        .back-btn {
            background-color: white;
            color: var(--dark-color);
            border: 1px solid rgba(0, 0, 0, 0.1);
            padding: 0.5rem 1.5rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .back-btn:hover {
            background-color: var(--light-color);
            border-color: rgba(0, 0, 0, 0.2);
            transform: translateY(-2px);
        }

        .department-badge {
            background-color: var(--primary-color);
            color: white;
            padding: 0.35rem 0.8rem;
            border-radius: 50px;
            font-weight: 500;
            font-size: 0.9rem;
        }

        .countdown-timer {
            font-weight: bold;
            color: var(--primary-color);
        }

        @media (max-width: 768px) {
            .container-bg {
                padding: 1.5rem;
            }
            
            .file-preview {
                height: 120px;
            }
        }
    </style>
</head>
<body>

<div class="container container-bg animate__animated animate__fadeIn">
    <% String downloadError = (String) session.getAttribute("downloadError"); %>
    <% if (downloadError != null) { %>
        <div class="alert alert-warning alert-dismissible fade show text-center animate__animated animate__shakeX" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= downloadError %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("downloadError"); %>
    <% } %>

    <div class="header-section text-center">
        <h3 class="mb-3 fw-bold">Department Files</h3>
        <span class="department-badge mb-3">
            <i class="bi bi-building"></i> <%= department %>
        </span>
        
        <div class="d-flex justify-content-center gap-3 flex-wrap mt-3">
            <div class="download-status">
                <% if (canDownload) { %>
                    <i class="bi bi-check-circle-fill text-success"></i> Downloads available
                <% } else { %>
                    <i class="bi bi-clock-history"></i> Try again in <span class="countdown-timer" id="countdown">10:00</span>
                <% } %>
            </div>
            
            <div class="ip-display">
                <i class="bi bi-pc-display"></i> <code><%= userIP %></code>
            </div>
        </div>
    </div>

    <div class="row g-4">
    <%
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement("SELECT filename FROM files WHERE department=?");
            ps.setString(1, department);
            rs = ps.executeQuery();

            while (rs.next()) {
                String file = rs.getString("filename");
                String displayName = file.contains("_") ? file.substring(file.indexOf("_") + 1) : file;
                String encodedFile = java.net.URLEncoder.encode(file, "UTF-8");
                String lower = file.toLowerCase();
                boolean isImage = lower.endsWith(".png") || lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".gif");
                boolean isPDF = lower.endsWith(".pdf");
                boolean isDoc = lower.endsWith(".doc") || lower.endsWith(".docx");
                boolean isExcel = lower.endsWith(".xls") || lower.endsWith(".xlsx");
                boolean isZip = lower.endsWith(".zip") || lower.endsWith(".rar");
                
                String previewSrc = isImage ? "DownloadServlet?file=" + encodedFile + "&mode=preview" : "images/file-icon.png";
                String tooltip = canDownload ? "Click to download this file" : "Please wait 10 minutes between downloads";
                String iconClass = "";
                
                if (isPDF) iconClass = "bi bi-file-earmark-pdf";
                else if (isDoc) iconClass = "bi bi-file-earmark-word";
                else if (isExcel) iconClass = "bi bi-file-earmark-excel";
                else if (isZip) iconClass = "bi bi-file-earmark-zip";
                else if (isImage) iconClass = "bi bi-file-earmark-image";
                else iconClass = "bi bi-file-earmark";
    %>
        <div class="col-xl-3 col-lg-4 col-md-6 col-sm-6 col-12">
            <div class="file-card">
                <% if (isImage) { %>
                    <img src="<%= previewSrc %>" class="file-preview" alt="<%= displayName %> preview" loading="lazy" />
                <% } else { %>
                    <i class="<%= iconClass %> file-icon"></i>
                <% } %>
                
                <div class="file-name"><%= displayName %></div>
                
                <a href="<%= canDownload ? "DownloadServlet?file=" + encodedFile : "#" %>"
                   class="download-btn"
                   title="<%= tooltip %>"
                   <%= !canDownload ? "disabled" : "" %>>
                    <i class="bi bi-cloud-arrow-down"></i> Download
                </a>
            </div>
        </div>
    <%
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger text-center'>Error loading files: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    %>
    </div>

    <div class="text-center mt-5">
        <a href="welcome.jsp" class="back-btn">
            <i class="bi bi-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    // Countdown timer implementation
    <% if (!canDownload && lastDownloadTime != null) { %>
        const lastDownloadTime = new Date("<%= lastDownloadTime %>").getTime();
        const countdownElement = document.getElementById('countdown');
        
        function updateCountdown() {
            const now = new Date().getTime();
            const timePassed = now - lastDownloadTime;
            const timeRemaining = (10 * 60 * 1000) - timePassed;
            
            if (timeRemaining <= 0) {
                countdownElement.textContent = "00:00";
                location.reload(); // Refresh the page when countdown completes
                return;
            }
            
            const minutes = Math.floor((timeRemaining % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((timeRemaining % (1000 * 60)) / 1000);
            
            countdownElement.textContent = 
                `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        }
        
        updateCountdown();
        setInterval(updateCountdown, 1000);
    <% } %>

    // Enhanced disabled button handling
    document.querySelectorAll('.download-btn').forEach(btn => {
        btn.addEventListener('click', function (e) {
            if (btn.hasAttribute('disabled')) {
                e.preventDefault();
                Swal.fire({
                    icon: 'warning',
                    title: 'Download Limit',
                    html: `You can download files only once every 10 minutes.<br><br>Please wait and try again.`,
                    confirmButtonColor: '#4361ee',
                    confirmButtonText: 'OK',
                    backdrop: 'rgba(0,0,0,0.4)'
                });
            }
        });
    });
    
    // Add animation to cards on hover
    document.querySelectorAll('.file-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.classList.add('animate__animated', 'animate__pulse');
        });
        
        card.addEventListener('mouseleave', function() {
            this.classList.remove('animate__animated', 'animate__pulse');
        });
    });
</script>
</body>
</html>