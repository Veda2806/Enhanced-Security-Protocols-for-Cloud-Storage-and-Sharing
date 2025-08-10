<%@ page session="true"%>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    String department = (String) session.getAttribute("department");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard | <%= username %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #ebf0ff;
            --secondary: #3f37c9;
            --success: #4cc9f0;
            --danger: #f72585;
            --dark: #1a1a1a;
            --light: #f8f9fa;
            --gray: #6c757d;
            --border-radius: 10px;
            --shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f5f7fa;
            color: var(--dark);
            min-height: 100vh;
        }

        .dashboard-container {
            display: grid;
            grid-template-columns: 280px 1fr;
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .sidebar {
            background: white;
            box-shadow: var(--shadow);
            padding: 2rem 1.5rem;
            position: sticky;
            top: 0;
            height: 100vh;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 2.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .brand-icon {
            width: 36px;
            height: 36px;
            background: var(--primary);
            color: white;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .brand-name {
            font-weight: 600;
            font-size: 1.1rem;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 2rem;
        }

        .avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid <%= "admin".equalsIgnoreCase(role) ? "var(--primary)" : "var(--success)" %>;
        }

        .user-info {
            line-height: 1.4;
        }

        .user-name {
            font-weight: 600;
            font-size: 1rem;
        }

        .user-role {
            font-size: 0.8rem;
            color: var(--gray);
            background: <%= "admin".equalsIgnoreCase(role) ? "var(--primary-light)" : "#e6f7ff" %>;
            padding: 2px 8px;
            border-radius: 20px;
            display: inline-block;
        }

        .nav-menu {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 0.75rem 1rem;
            border-radius: var(--border-radius);
            color: var(--gray);
            text-decoration: none;
            transition: var(--transition);
            font-weight: 500;
        }

        .nav-item:hover, .nav-item.active {
            background: var(--primary-light);
            color: var(--primary);
        }

        .nav-item i {
            font-size: 1.1rem;
        }

        /* Main Content Styles */
        .main-content {
            padding: 2rem 3rem;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-title h1 {
            font-weight: 600;
            font-size: 1.8rem;
        }

        .page-title p {
            color: var(--gray);
            font-size: 0.9rem;
        }

        .logout-btn {
            background: white;
            border: 1px solid rgba(0, 0, 0, 0.1);
            padding: 0.5rem 1rem;
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            transition: var(--transition);
        }

        .logout-btn:hover {
            background: #f8f9fa;
            color: var(--danger);
        }

        /* Dashboard Cards */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            padding: 1.5rem;
            transition: var(--transition);
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .card-icon {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            font-size: 1.2rem;
        }

        .card-icon.primary {
            background: var(--primary-light);
            color: var(--primary);
        }

        .card-icon.success {
            background: #e6f7ff;
            color: var(--success);
        }

        .card-icon.danger {
            background: #ffebf1;
            color: var(--danger);
        }

        .card-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .card-desc {
            color: var(--gray);
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
        }

        .card-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 0.5rem 1rem;
            background: white;
            border: 1px solid rgba(0, 0, 0, 0.1);
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            transition: var(--transition);
            text-decoration: none;
            color: var(--dark);
        }

        .card-btn:hover {
            background: #f8f9fa;
            color: var(--primary);
        }

        /* Recent Activity */
        .section-title {
            font-weight: 600;
            margin-bottom: 1.5rem;
            font-size: 1.2rem;
        }

        .activity-list {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .activity-item {
            display: flex;
            align-items: center;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            background: var(--primary-light);
            color: var(--primary);
            font-size: 1rem;
        }

        .activity-details {
            flex: 1;
        }

        .activity-title {
            font-weight: 500;
            margin-bottom: 0.25rem;
        }

        .activity-time {
            font-size: 0.8rem;
            color: var(--gray);
        }

        /* Responsive Styles */
        @media (max-width: 992px) {
            .dashboard-container {
                grid-template-columns: 1fr;
            }
            
            .sidebar {
                height: auto;
                position: relative;
                padding: 1.5rem;
            }
            
            .main-content {
                padding: 1.5rem;
            }
            
            .card-grid {
                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            }
        }

        @media (max-width: 576px) {
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            
            .card-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="brand">
                <div class="brand-icon">
                    <i class="bi bi-shield-lock"></i>
                </div>
                <div class="brand-name">SecureAccess</div>
            </div>
            
            <div class="user-profile">
                <img src="images/profile.png" class="avatar" alt="<%= username %>">
                <div class="user-info">
                    <div class="user-name"><%= username %></div>
                    <div class="user-role"><%= role %></div>
                </div>
            </div>
            
            <nav class="nav-menu">
                <a href="#" class="nav-item active">
                    <i class="bi bi-speedometer2"></i>
                    Dashboard
                </a>
                <a href="download.jsp" class="nav-item">
                    <i class="bi bi-download"></i>
                    Download Files
                </a>
                <% if ("admin".equalsIgnoreCase(role)) { %>
                    <a href="upload.jsp" class="nav-item">
                        <i class="bi bi-cloud-upload"></i>
                        Upload Files
                    </a>
                
                    
                <% } %>
                
            </nav>
        </aside>
        
        <!-- Main Content Area -->
        <main class="main-content">
            <div class="header">
                <div class="page-title">
                    <h1>Dashboard</h1>
                    <p>Welcome back, <%= username %>! Here's what's happening today.</p>
                </div>
                <a href="logout.jsp" class="logout-btn">
                    <i class="bi bi-box-arrow-right"></i>
                    Logout
                </a>
            </div>
            
            <!-- Quick Actions Cards -->
            <div class="card-grid">
                <div class="card">
                    <div class="card-icon success">
                        <i class="bi bi-download"></i>
                    </div>
                    <h3 class="card-title">Download Files</h3>
                    <p class="card-desc">Access all available files in the secure repository</p>
                    <a href="download.jsp" class="card-btn">
                        Go to Downloads
                        <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
                
                <% if ("admin".equalsIgnoreCase(role)) { %>
                    <div class="card">
                        <div class="card-icon primary">
                            <i class="bi bi-cloud-upload"></i>
                        </div>
                        <h3 class="card-title">Upload Files</h3>
                        <p class="card-desc">Add new files to the secure repository</p>
                        <a href="upload.jsp" class="card-btn">
                            Upload Now
                            <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                    
       
                <% } %>
                
                
            </div>
            
            <!-- Recent Activity Section -->
            <h3 class="section-title">Recent Activity</h3>
            <div class="activity-list">
                <div class="activity-item">
                    <div class="activity-icon">
                        <i class="bi bi-download"></i>
                    </div>
                    <div class="activity-details">
                        <div class="activity-title">File downloaded: Quarterly_Report.pdf</div>
                        <div class="activity-time">Today, 10:45 AM</div>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon">
                        <i class="bi bi-person-check"></i>
                    </div>
                    <div class="activity-details">
                        <div class="activity-title">Successful login from Chrome on Windows</div>
                        <div class="activity-time">Today, 10:30 AM</div>
                    </div>
                </div>
                <% if ("admin".equalsIgnoreCase(role)) { %>
                    <div class="activity-item">
                        <div class="activity-icon">
                            <i class="bi bi-cloud-upload"></i>
                        </div>
                        <div class="activity-details">
                            <div class="activity-title">File uploaded: Project_Proposal.docx</div>
                            <div class="activity-time">Yesterday, 4:22 PM</div>
                        </div>
                    </div>
                <% } %>
                <div class="activity-item">
                    <div class="activity-icon">
                        <i class="bi bi-shield-lock"></i>
                    </div>
                    <div class="activity-details">
                        <div class="activity-title">Password changed successfully</div>
                        <div class="activity-time">2 days ago</div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>