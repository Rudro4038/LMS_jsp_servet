<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weblab.model.User, com.weblab.model.Course, com.weblab.model.Enrollment, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"teacher".equals(user.getRole())) {
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
        border-radius: 5px;
        margin-bottom: 30px;
    }
    .course-info {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 15px;
        margin-top: 20px;
    }
    .info-item {
        background: rgba(255, 255, 255, 0.1);
        padding: 15px;
        border-radius: 5px;
        text-align: center;
    }
    .student-table {
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        border-radius: 5px;
    }
    .student-row {
        transition: background-color 0.2s;
    }
    .student-row:hover {
        background-color: #f5f5f5;
    }
    .empty-state {
        text-align: center;
        padding: 50px 20px;
        background: #f9f9f9;
        border-radius: 5px;
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
        
        <% if (course != null) { %>
            <!-- Course Header -->
            <div class="course-header">
                <h2><%= course.getName() %></h2>
                <p class="lead"><%= course.getDescription() != null ? course.getDescription() : "No description available" %></p>
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

            <!-- Students List -->
            <div class="mb-4">
                <h3>(R-5: Registered Students in '<%= course.getName() %>')</h3>
            </div>

            <% if (enrollments != null && !enrollments.isEmpty()) { %>
                <div class="table-responsive student-table">
                    <table class="table table-hover mb-0">
                        <thead class="bg-success text-white">
                            <tr>
                                <th>Student ID</th>
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
                                        <span class="badge badge-primary">
                                            <%= enrollment.getStatus() %>
                                        </span>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <div class="mt-3 p-3 bg-light rounded">
                    <p class="mb-0">
                        <strong>Total Enrolled Students:</strong> <span class="badge badge-success"><%= enrollments.size() %></span>
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
        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/teacher/courses" class="btn btn-secondary">
                ← Back to Courses
            </a>
        </div>
    </div>

<%@ include file="../common/footer.jsp" %>
