<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weblab.model.User, com.weblab.model.Course, com.weblab.model.Enrollment, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Course course = (Course) request.getAttribute("course");
    @SuppressWarnings("unchecked")
    List<Enrollment> enrollments = (List<Enrollment>) request.getAttribute("enrollments");
%>
<%@ include file="../common/header.jsp" %>

<style>
    .course-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 30px;
        border-radius: 8px;
        margin-bottom: 30px;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
    }
    .course-header h2 {
        font-weight: bold;
        margin-bottom: 10px;
    }
    .course-info {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 15px;
        margin-top: 20px;
    }
    .info-item {
        background: rgba(255, 255, 255, 0.15);
        padding: 15px;
        border-radius: 8px;
        text-align: center;
        backdrop-filter: blur(10px);
    }
    .info-item h5 {
        font-size: 12px;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-bottom: 8px;
        opacity: 0.9;
    }
    .info-item p {
        font-size: 24px;
        font-weight: bold;
        margin: 0;
    }
    .student-table {
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
        overflow: hidden;
    }
    .student-table table {
        margin-bottom: 0;
    }
    .student-row {
        transition: background-color 0.2s ease;
    }
    .student-row:hover {
        background-color: #f0f0f0;
    }
    .table thead {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }
    .empty-state {
        text-align: center;
        padding: 60px 20px;
        background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
        border-radius: 8px;
        margin: 30px 0;
    }
    .empty-state h4 {
        color: #333;
        font-weight: bold;
    }
    .empty-state p {
        color: #666;
    }
    .go-back-btn {
        display: inline-block;
        padding: 12px 24px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
    }
    .go-back-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        color: white;
        text-decoration: none;
    }
    .stats-box {
        background: #f8f9fa;
        padding: 15px;
        border-radius: 8px;
        border-left: 4px solid #667eea;
        margin-top: 20px;
    }
</style>

<div class="container mt-5">
    
    <% if (course != null) { %>
        <!-- Course Header -->
        <div class="course-header">
            <h2><%= course.getName() %></h2>
            <p class="lead mb-0"><%= course.getDescription() != null ? course.getDescription() : "No description available" %></p>
            <div class="course-info">
                <div class="info-item">
                    <h5>Course ID</h5>
                    <p><%= course.getId() %></p>
                </div>
                <div class="info-item">
                    <h5>Total Capacity</h5>
                    <p><%= course.getCapacity() %></p>
                </div>
                <div class="info-item">
                    <h5>Enrolled Students</h5>
                    <p><%= course.getEnrolledCount() %></p>
                </div>
            </div>
        </div>

        <!-- Students List Header -->
        <div class="mb-4">
            <h3>Registered Students in '<%= course.getName() %>'</h3>
        </div>

        <% if (enrollments != null && !enrollments.isEmpty()) { %>
            <div class="table-responsive student-table">
                <table class="table table-hover mb-0">
                    <thead class="text-white">
                        <tr>
                            <th style="width: 60px;">S.No</th>
                            <th>Student Name</th>
                            <th>Email</th>
                            <th>Enrollment Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int sno = 1;
                           for (Enrollment enrollment : enrollments) { %>
                            <tr class="student-row">
                                <td><strong><%= sno++ %></strong></td>
                                <td><%= enrollment.getStudentName() %></td>
                                <td><%= enrollment.getStudentEmail() %></td>
                                <td>
                                    <small class="text-muted">
                                        <%= enrollment.getEnrollmentDate() %>
                                    </small>
                                </td>
                                <td>
                                    <span class="badge badge-success">
                                        <%= enrollment.getStatus() %>
                                    </span>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div class="stats-box">
                <p class="mb-0">
                    <strong>Total Enrolled Students:</strong> <span class="badge badge-info" style="font-size: 14px;"><%= enrollments.size() %></span>
                </p>
            </div>

        <% } else { %>
            <div class="empty-state">
                <h4>No Students Enrolled</h4>
                <p class="text-muted">No students have enrolled in this course yet.</p>
            </div>
        <% } %>

    <% } else { %>
        <div class="alert alert-danger" role="alert">
            <strong>Error:</strong> Course not found or you don't have access to this course.
        </div>
    <% } %>

    <!-- Back Button -->
    <div class="mt-4 mb-5">
        <a href="${pageContext.request.contextPath}/admin/courses?action=view" class="go-back-btn">
            ← Back to Courses
        </a>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
