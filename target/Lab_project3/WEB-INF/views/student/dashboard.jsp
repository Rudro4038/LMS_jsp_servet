<%@ page import="com.weblab.model.User" %> <% User user = (User)
session.getAttribute("user"); if (user == null ||
!"student".equals(user.getRole())) {
response.sendRedirect(request.getContextPath() + "/login.jsp"); return; } %> <%@
include file="../common/header.jsp" %>

<style>
  .dashboard-header {
    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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
    border-left: 4px solid #00f2fe;
  }
  .stat-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
  }
  .stat-number {
    font-size: 32px;
    font-weight: bold;
    color: #00f2fe;
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
    background: #00f2fe;
    color: #333;
    border-radius: 5px;
    text-decoration: none;
    transition: background 0.3s;
    font-weight: bold;
  }
  .btn-feature:hover {
    background: #4facfe;
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
    <a class="navbar-brand" href="${pageContext.request.contextPath}/"
      >WebLab</a
    >
    <div class="navbar-collapse">
      <ul class="navbar-nav ml-auto">
        <li class="nav-item">
          <span class="nav-link">Student: <%= user.getUsername() %></span>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/logout"
            >Logout</a
          >
        </li>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-5">
  <!-- Dashboard Header -->
  <div class="dashboard-header">
    <h1> Student Dashboard</h1>
    <p class="mb-0">
      Welcome, <%= user.getUsername() %>! Manage your courses and learning here.
    </p>
  </div>

  <!-- Quick Stats -->
  <div class="row mb-4">
    <div class="col-md-4">
      <div class="stat-card">
        <div class="stat-number"></div>
        <div class="stat-label">My Courses</div>
        <p style="margin-top: 10px; font-size: 12px; color: #999">
          View and manage enrolled courses
        </p>
      </div>
    </div>
    <div class="col-md-4">
      <div class="stat-card">
        <div class="stat-number"></div>
        <div class="stat-label">My Progress</div>
        <p style="margin-top: 10px; font-size: 12px; color: #999">
          Track your learning progress
        </p>
      </div>
    </div>
    <div class="col-md-4">
      <div class="stat-card">
        <div class="stat-number"></div>
        <div class="stat-label">My Grades</div>
        <p style="margin-top: 10px; font-size: 12px; color: #999">
          View your academic performance
        </p>
      </div>
    </div>
  </div>

  <!-- Main Features -->
  <div class="row">
    <div class="col-md-6 col-lg-4">
      <div class="feature-card">
        <div class="feature-icon"></div>
        <h5>Browse Courses</h5>
        <p>Explore available courses and enroll in ones that interest you</p>
        <a
          href="${pageContext.request.contextPath}/student/courses"
          class="btn-feature"
          >Browse Courses</a
        >
      </div>
    </div>

    <div class="col-md-6 col-lg-4">
      <div class="feature-card">
        <div class="feature-icon"></div>
        <h5>My Enrollments</h5>
        <p>View all courses you are currently enrolled in</p>
        <a
          href="${pageContext.request.contextPath}/student/courses?view=enrolled"
          class="btn-feature"
          >My Courses</a
        >
      </div>
    </div>

    <div class="col-md-6 col-lg-4">
      <div class="feature-card">
        <div class="feature-icon"></div>
        <h5>Course Materials</h5>
        <p>Access lecture notes, assignments, and study materials</p>
        <a href="#" class="btn-feature">View Materials</a>
      </div>
    </div>

    <div class="col-md-6 col-lg-4">
      <div class="feature-card">
        <div class="feature-icon"></div>
        <h5>Messages</h5>
        <p>Communicate with your teachers and classmates</p>
        <a href="#" class="btn-feature">Messages</a>
      </div>
    </div>

    <div class="col-md-6 col-lg-4">
      <div class="feature-card">
        <div class="feature-icon"></div>
        <h5>Assignments</h5>
        <p>Submit assignments and view feedback from instructors</p>
        <a href="#" class="btn-feature">View Assignments</a>
      </div>
    </div>

    <div class="col-md-6 col-lg-4">
      <div class="feature-card">
        <div class="feature-icon"></div>
        <h5>My Performance</h5>
        <p>Track grades, scores, and overall academic progress</p>
        <a href="#" class="btn-feature">View Performance</a>
      </div>
    </div>
  </div>

  <!-- Quick Actions -->
  <div class="quick-actions">
    <h5 class="mb-3">Quick Actions</h5>
    <div class="row">
      <div class="col-md-6 col-lg-3 mb-3">
        <a
          href="${pageContext.request.contextPath}/student/courses"
          class="btn btn-primary btn-block"
        >
          Browse Courses
        </a>
      </div>
      <div class="col-md-6 col-lg-3 mb-3">
        <a
          href="${pageContext.request.contextPath}/student/courses?view=enrolled"
          class="btn btn-info btn-block"
        >
          My Courses
        </a>
      </div>
      <div class="col-md-6 col-lg-3 mb-3">
        <a href="#" class="btn btn-warning btn-block">  Messages </a>
      </div>
      <div class="col-md-6 col-lg-3 mb-3">
        <a
          href="${pageContext.request.contextPath}/home"
          class="btn btn-secondary btn-block"
        >
          Back to Home
        </a>
      </div>
    </div>
  </div>
</div>

<%@ include file="../common/footer.jsp" %>
