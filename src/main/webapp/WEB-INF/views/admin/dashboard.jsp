<%@ page import="com.weblab.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<%@ include file="../common/header.jsp" %>

<style>
    .dashboard-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 40px 20px;
        border-radius: 10px;
        margin-bottom: 30px;
    }
    .dashboard-header h1 {
        margin-bottom: 10px;
        font-weight: bold;
    }
    .stat-card {
        background: white;
        border-radius: 10px;
        padding: 25px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s, box-shadow 0.3s;
        margin-bottom: 20px;
        border-left: 4px solid #667eea;
    }
    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    }
    .stat-number {
        font-size: 32px;
        font-weight: bold;
        color: #667eea;
    }
    .stat-label {
        color: #666;
        font-size: 14px;
        margin-top: 5px;
    }
    .feature-card {
        background: white;
        border-radius: 10px;
        padding: 30px;
        text-align: center;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s, box-shadow 0.3s;
        margin-bottom: 20px;
        height: 100%;
    }
    .feature-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    }
    .feature-icon {
        font-size: 48px;
        margin-bottom: 15px;
    }
    .feature-card h5 {
        color: #333;
        margin-bottom: 10px;
        font-weight: bold;
    }
    .feature-card p {
        color: #666;
        font-size: 14px;
        margin-bottom: 15px;
    }
    .btn-feature {
        display: inline-block;
        padding: 10px 20px;
        background: #667eea;
        color: white;
        border-radius: 5px;
        text-decoration: none;
        transition: background 0.3s;
    }
    .btn-feature:hover {
        background: #764ba2;
        color: white;
        text-decoration: none;
    }
    .quick-actions {
        background: #f8f9fa;
        padding: 30px;
        border-radius: 10px;
        margin-top: 30px;
    }
</style>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">WebLab</a>
        <div class="navbar-collapse">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <span class="nav-link">Admin: <%= user.getUsername() %></span>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <!-- Dashboard Header -->
    <div class="dashboard-header">
        <h1>👨‍💼 Admin Dashboard</h1>
        <p class="mb-0">Welcome back, <%= user.getUsername() %>! Manage your system from here.</p>
    </div>

    <!-- Quick Stats -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-number">📚</div>
                <div class="stat-label">Manage Courses (R-3)</div>
                <p style="margin-top: 10px; font-size: 12px; color: #999;">Add, edit, and remove courses from the system</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-number">👥</div>
                <div class="stat-label">User Management</div>
                <p style="margin-top: 10px; font-size: 12px; color: #999;">Monitor students, teachers, and admins</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-number">⚙️</div>
                <div class="stat-label">System Settings</div>
                <p style="margin-top: 10px; font-size: 12px; color: #999;">Configure system parameters and policies</p>
            </div>
        </div>
    </div>

    <!-- Main Features -->
    <div class="row">
        <div class="col-md-6 col-lg-4">
            <div class="feature-card">
                <div class="feature-icon">📖</div>
                <h5>Course Management (R-3)</h5>
                <p>Create new courses, assign teachers, and manage course details</p>
                <a href="${pageContext.request.contextPath}/admin/courses" class="btn-feature">Manage Courses</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="feature-card">
                <div class="feature-icon">👨‍🎓</div>
                <h5>Student Management</h5>
                <p>View all students, track enrollments, and monitor progress</p>
                <a href="#" class="btn-feature">View Students</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="feature-card">
                <div class="feature-icon">🏫</div>
                <h5>Teacher Management</h5>
                <p>Manage teacher accounts and their course assignments</p>
                <a href="#" class="btn-feature">View Teachers</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="feature-card">
                <div class="feature-icon">📊</div>
                <h5>System Analytics</h5>
                <p>View detailed system statistics and enrollment reports</p>
                <a href="#" class="btn-feature">View Analytics</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="feature-card">
                <div class="feature-icon">🔐</div>
                <h5>Access Control</h5>
                <p>Manage user roles, permissions, and system security</p>
                <a href="#" class="btn-feature">Manage Roles</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="feature-card">
                <div class="feature-icon">⚡</div>
                <h5>System Status</h5>
                <p>Monitor system health, logs, and performance metrics</p>
                <a href="#" class="btn-feature">View Status</a>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
        <h5 class="mb-3">⚡ Quick Actions</h5>
        <div class="row">
            <div class="col-md-6 col-lg-3 mb-3">
                <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-primary btn-block">
                    ➕ Add New Course
                </a>
            </div>
            <div class="col-md-6 col-lg-3 mb-3">
                <a href="${pageContext.request.contextPath}/admin/courses?action=view" class="btn btn-info btn-block">
                    📋 View All Courses
                </a>
            </div>
            <div class="col-md-6 col-lg-3 mb-3">
                <a href="#" class="btn btn-warning btn-block">
                    🔔 System Notifications
                </a>
            </div>
            <div class="col-md-6 col-lg-3 mb-3">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary btn-block">
                    ← Back to Home
                </a>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
