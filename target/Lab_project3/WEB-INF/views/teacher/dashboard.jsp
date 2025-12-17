<%@ page import="com.weblab.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"teacher".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<%@ include file="../common/header.jsp" %>

<style>
    .dashboard-header {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
        border-left: 4px solid #f5576c;
    }
    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    }
    .stat-number {
        font-size: 32px;
        font-weight: bold;
        color: #f5576c;
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
        background: #f5576c;
        color: white;
        border-radius: 5px;
        text-decoration: none;
        transition: background 0.3s;
    }
    .btn-feature:hover {
        background: #f093fb;
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
                    <span class="nav-link">Teacher: <%= user.getUsername() %></span>
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
        <h1> Teacher Dashboard</h1>
        <p class="mb-0">Welcome, <%= user.getUsername() %>! Manage your courses and students here.</p>
    </div>

    <!-- Quick Stats -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-number"></div>
                <div class="stat-label">Your Courses</div>
                <p style="margin-top: 10px; font-size: 12px; color: #999;">View and manage all your assigned courses</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-number"></div>
                <div class="stat-label">Total Students</div>
                <p style="margin-top: 10px; font-size: 12px; color: #999;">Monitor student enrollments across courses</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-number"></div>
                <div class="stat-label">Course Stats</div>
                <p style="margin-top: 10px; font-size: 12px; color: #999;">View enrollment statistics and reports</p>
            </div>
        </div>
    </div>

    <!-- Main Features -->
    <div class="row">
        <div class="col-md-6 col-lg-4">
            <div class="feature-card">
                <div class="feature-icon"></div>
                <h5>My Courses </h5>
                <p>View all courses assigned to you and manage enrollments</p>
                <a href="${pageContext.request.contextPath}/teacher/courses" class="btn-feature">View Courses</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="feature-card">
                <div class="feature-icon"></div>
                <h5>Student List</h5>
                <p>Select a course and view all enrolled students</p>
                <a href="${pageContext.request.contextPath}/teacher/courses" class="btn-feature">View Students</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="feature-card">
                <div class="feature-icon"></div>
                <h5>Course Materials</h5>
                <p>Upload and manage course materials for your students</p>
                <a href="#" class="btn-feature">Manage Materials</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="feature-card">
                <div class="feature-icon"></div>
                <h5>Performance Reports</h5>
                <p>View student performance and engagement metrics</p>
                <a href="#" class="btn-feature">View Reports</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="feature-card">
                <div class="feature-icon"></div>   
                <h5>Messages & Announcements</h5>
                <p>Communicate with students and make announcements</p>
                <a href="#" class="btn-feature">Send Message</a>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="feature-card">
                <div class="feature-icon"></div>
                <h5>Course Settings</h5>
                <p>Configure course details and enrollment policies</p>
                <a href="#" class="btn-feature">Settings</a>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
        <h5 class="mb-3">Quick Actions</h5>
        <div class="row">
            <div class="col-md-6 col-lg-3 mb-3">
                <a href="${pageContext.request.contextPath}/teacher/courses" class="btn btn-primary btn-block">
                 My Courses
                </a>
            </div>
            <div class="col-md-6 col-lg-3 mb-3">
                <a href="${pageContext.request.contextPath}/teacher/courses" class="btn btn-info btn-block">
                 View Students
                </a>
            </div>
            <div class="col-md-6 col-lg-3 mb-3">
                <a href="#" class="btn btn-warning btn-block">
                 Make Announcement
                </a>
            </div>
            <div class="col-md-6 col-lg-3 mb-3">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary btn-block">
                    Back to Home
                </a>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
