<%@ page import="com.weblab.model.User, com.weblab.model.Course, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"teacher".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Course> courses = (List<Course>) request.getAttribute("courses");
%>
<%@ include file="../common/header.jsp" %>

<style>
    .page-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 30px 20px;
        margin-bottom: 30px;
        border-radius: 5px;
    }
    .page-header h2 {
        margin-bottom: 5px;
        font-weight: bold;
        font-size: 28px;
    }
    .page-header p {
        margin: 0;
        font-size: 14px;
        opacity: 0.95;
    }
    .course-table {
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
        overflow: hidden;
        background: white;
    }
    .course-row {
        transition: background-color 0.2s, box-shadow 0.2s;
        border-bottom: 1px solid #eee;
    }
    .course-row:hover {
        background-color: #f8f9fa;
        box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
    }
    .course-row:last-child {
        border-bottom: none;
    }
    table thead {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
        color: white;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 13px;
        letter-spacing: 0.5px;
    }
    .btn-view-students {
        white-space: nowrap;
        transition: all 0.2s;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        color: white;
        font-weight: 500;
    }
    .btn-view-students:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        color: white;
        text-decoration: none;
    }
    .empty-state {
        text-align: center;
        padding: 60px 20px;
        background: #f9f9f9;
        border-radius: 8px;
        border: 2px dashed #ddd;
    }
    .empty-state h4 {
        color: #333;
        margin-bottom: 10px;
        font-weight: 600;
    }
    .empty-state p {
        color: #666;
        font-size: 14px;
    }
    .stat-badge {
        font-size: 13px;
        padding: 6px 12px;
        font-weight: 500;
        letter-spacing: 0.5px;
    }
    .badge-info {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }
    .badge-secondary {
        background: #6c757d;
        color: white;
    }
    .badge-success {
        background: #28a745;
        color: white;
    }
    .mt-4.p-3 {
        background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
        border-left: 4px solid #667eea;
        border-radius: 5px;
    }
    .mt-4.p-3 p {
        margin: 0;
        color: #333;
        font-weight: 500;
    }
    .back-button {
        margin-top: 30px;
    }
    .back-button .btn-secondary {
        background: #6c757d;
        border: none;
        padding: 10px 30px;
        font-weight: 500;
        transition: all 0.2s;
    }
    .back-button .btn-secondary:hover {
        background: #5a6268;
        transform: translateX(-3px);
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
        <!-- Page Header -->
        <div class="page-header">
            <h2>👨‍🏫 My Courses</h2>
            <p>View your taught courses and enrolled students</p>
        </div>

        <% if (courses != null && !courses.isEmpty()) { %>
            <div class="table-responsive course-table">
                <table class="table table-hover mb-0">
                    <thead class="bg-primary text-white">
                        <tr>
                            <th>Course Name</th>
                            <th>Description</th>
                            <th class="text-center">Enrolled</th>
                            <th class="text-center">Capacity</th>
                            <th class="text-center">Status</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Course course : courses) { %>
                            <tr class="course-row">
                                <td><strong><%= course.getName() %></strong></td>
                                <td>
                                    <small class="text-muted">
                                        <%= course.getDescription() != null ? 
                                            (course.getDescription().length() > 40 ? 
                                                course.getDescription().substring(0, 40) + "..." : 
                                                course.getDescription()) : "No description" %>
                                    </small>
                                </td>
                                <td class="text-center">
                                    <span class="badge badge-info stat-badge">
                                        <%= course.getEnrolledCount() %>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <span class="badge badge-secondary stat-badge">
                                        <%= course.getCapacity() %>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <span class="badge badge-success">
                                        <%= course.getStatus() %>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/teacher/courses?action=viewStudents&courseId=<%= course.getId() %>" 
                                       class="btn btn-sm btn-info btn-view-students">
                                        👥 View Students
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div class="mt-4 p-3 bg-light rounded">
                <p class="mb-0 text-muted">
                    <strong><%= courses.size() %></strong> active course(s) assigned to you
                </p>
            </div>

        <% } else { %>
            <div class="empty-state card">
                <div class="card-body">
                    <h4>No Courses Assigned</h4>
                    <p class="text-muted">You don't have any courses assigned yet. Contact your administrator.</p>
                </div>
            </div>
        <% } %>

        <!-- Back Button -->
        <div class="back-button">
            <a href="${pageContext.request.contextPath}/home/teacher" class="btn btn-secondary btn-lg">
                ← Back to Dashboard
            </a>
        </div>
    </div>

<%@ include file="../common/footer.jsp" %>
