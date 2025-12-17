<%@ page import="com.weblab.model.User, com.weblab.model.Course, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"student".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    String viewType = (String) request.getAttribute("viewType");
    @SuppressWarnings("unchecked")
    List<Course> courses = (List<Course>) request.getAttribute("courses");
%>
<%@ include file="../common/header.jsp" %>

<style>
    .page-header {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        color: white;
        padding: 30px 20px;
        margin-bottom: 30px;
        border-radius: 5px;
    }
    .page-header h2 {
        margin-bottom: 5px;
        font-weight: bold;
    }
    .tab-buttons {
        margin-bottom: 25px;
    }
    .tab-buttons .btn {
        margin-right: 10px;
        margin-bottom: 10px;
        padding: 10px 20px;
    }
    .course-card {
        border-left: 4px solid #007bff;
        transition: transform 0.2s, box-shadow 0.2s;
        height: 100%;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    .course-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    }
    .course-card.enrolled {
        border-left-color: #28a745;
    }
    .course-card.available {
        border-left-color: #ffc107;
    }
    .empty-state {
        text-align: center;
        padding: 60px 20px;
        background: #f9f9f9;
        border-radius: 8px;
    }
    .empty-state h4 {
        color: #333;
        margin-bottom: 10px;
    }
    .empty-state p {
        color: #666;
    }
    .course-status {
        position: absolute;
        top: 10px;
        right: 10px;
    }
    .progress-bar {
        background-color: #00f2fe;
    }
    .back-button {
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
                    <span class="nav-link">Student: <%= user.getUsername() %></span>
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
        <h2> Course Registration & Enrollment</h2>
        <p class="mb-0"><%= "enrolled".equals(viewType) ? "Your enrolled courses" : "Browse available courses" %></p>
    </div>

    <!-- Tab Buttons -->
    <div class="tab-buttons">
        <a href="${pageContext.request.contextPath}/student/courses" 
           class="btn <%= !"enrolled".equals(viewType) ? "btn-primary" : "btn-outline-primary" %>">
             Available Courses
        </a>
        <a href="${pageContext.request.contextPath}/student/courses?action=enrolled" 
           class="btn <%= "enrolled".equals(viewType) ? "btn-primary" : "btn-outline-primary" %>">
             My Enrolled Courses
        </a>
    </div>

    <!-- Alert Messages -->
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
             <%= request.getAttribute("error") %>
            <button type="button" class="close" data-dismiss="alert">
                <span>&times;</span>
            </button>
        </div>
    <% } %>

    <% if (request.getAttribute("message") != null) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
             <%= request.getAttribute("message") %>
            <button type="button" class="close" data-dismiss="alert">
                <span>&times;</span>
            </button>
        </div>
    <% } %>

    <!-- Courses Display -->
    <% if (courses != null && !courses.isEmpty()) { %>
        <div class="row">
            <% for (Course course : courses) { %>
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card course-card <%= "enrolled".equals(viewType) ? "enrolled" : "available" %>">
                        <div class="card-body">
                            <div class="course-status">
                                <% if ("enrolled".equals(viewType)) { %>
                                    <span class="badge badge-success"> Enrolled</span>
                                <% } else { %>
                                    <% if (course.hasAvailableSeats()) { %>
                                        <span class="badge badge-warning">Available</span>
                                    <% } else { %>
                                        <span class="badge badge-danger">Full</span>
                                    <% } %>
                                <% } %>
                            </div>

                            <h5 class="card-title"><%= course.getName() %></h5>
                            <p class="card-text text-muted small">
                                <%= course.getDescription() != null ? 
                                    (course.getDescription().length() > 60 ? 
                                        course.getDescription().substring(0, 60) + "..." : 
                                        course.getDescription()) : "No description" %>
                            </p>
                            <hr>
                            <div class="mb-2">
                                <small>
                                    <strong> Teacher:</strong> <%= course.getTeacherName() != null ? course.getTeacherName() : "N/A" %>
                                </small>
                            </div>
                            <div class="mb-3">
                                <small class="text-muted">
                                    <strong> Enrollment:</strong> <%= course.getEnrolledCount() %> / <%= course.getCapacity() %>
                                </small>
                            </div>

                            <!-- Progress Bar -->
                            <div class="mb-3">
                                <div class="progress" style="height: 22px;">
                                    <% int percentage = course.getCapacity() > 0 ? (course.getEnrolledCount() * 100) / course.getCapacity() : 0; %>
                                    <div class="progress-bar" role="progressbar" 
                                         style="width: <%= percentage %>%;"
                                         aria-valuenow="<%= course.getEnrolledCount() %>" 
                                         aria-valuemin="0" 
                                         aria-valuemax="<%= course.getCapacity() %>">
                                        <%= percentage %>%
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <% if ("enrolled".equals(viewType)) { %>
                                <form action="${pageContext.request.contextPath}/student/courses" method="post" style="margin: 0;">
                                    <input type="hidden" name="action" value="drop">
                                    <input type="hidden" name="courseId" value="<%= course.getId() %>">
                                    <button type="submit" class="btn btn-sm btn-danger w-100" 
                                            onclick="return confirm('Are you sure you want to drop this course?');">
                                         Drop Course
                                    </button>
                                </form>
                            <% } else { %>
                                <form action="${pageContext.request.contextPath}/student/courses" method="post" style="margin: 0;">
                                    <input type="hidden" name="action" value="enroll">
                                    <input type="hidden" name="courseId" value="<%= course.getId() %>">
                                    <button type="submit" class="btn btn-sm btn-success w-100" 
                                            <%= !course.hasAvailableSeats() ? "disabled" : "" %>>
                                         Enroll Now
                                    </button>
                                </form>
                            <% } %>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>

    <% } else { %>
        <div class="empty-state">
            <h4>
                <% if ("enrolled".equals(viewType)) { %>
                     No Courses Enrolled
                <% } else { %>
                     No Courses Available
                <% } %>
            </h4>
            <p class="text-muted">
                <% if ("enrolled".equals(viewType)) { %>
                    You are not enrolled in any courses yet. 
                    <a href="${pageContext.request.contextPath}/student/courses">Browse available courses</a> to get started!
                <% } else { %>
                    All available courses are currently full or no courses have been added yet.
                <% } %>
            </p>
        </div>
    <% } %>

    <!-- Back Button -->
    <div class="back-button">
        <a href="${pageContext.request.contextPath}/home/student" class="btn btn-secondary btn-lg">
             Back to Dashboard
        </a>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
