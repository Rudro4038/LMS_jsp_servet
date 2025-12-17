<%@ page contentType="text/html; charset=UTF-8" %> <%@ page
import="com.weblab.model.User, com.weblab.model.Course, java.util.List" %> <%
User user = (User) session.getAttribute("user"); if (user == null ||
!"admin".equals(user.getRole())) {
response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
@SuppressWarnings("unchecked") List<Course>
  courses = (List<Course
    >) request.getAttribute("courses"); %> <%@ include
    file="../common/header.jsp" %>

    <style>
      .page-container {
        min-height: 100vh;
        display: flex;
        flex-direction: column;
      }
      .content {
        flex: 1;
      }
      .course-card {
        border-left: 4px solid #007bff;
        transition: transform 0.2s;
      }
      .course-card:hover {
        transform: translateX(5px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      }
      .badge-capacity {
        background-color: #28a745;
      }
      .empty-state {
        text-align: center;
        padding: 50px 20px;
      }
      .go-dashboard-btn {
        display: inline-block;
        padding: 12px 24px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        margin-right: 10px;
      }
      .go-dashboard-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        color: white;
        text-decoration: none;
      }
      .go-dashboard-btn:active {
        transform: translateY(-1px);
      }
      .btn-action-group {
        display: flex;
        gap: 12px;
        align-items: center;
      }
      .btn-action-group .btn {
        padding: 12px 24px;
        font-weight: 600;
        border-radius: 8px;
        transition: all 0.3s ease;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        white-space: nowrap;
      }
      .btn-action-group .btn:hover {
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      }
      .btn-action-group .btn-primary {
        background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
        border: none;
      }
      .btn-action-group .btn-primary:hover {
        transform: translateY(-2px);
        background: linear-gradient(135deg, #0056b3 0%, #004085 100%);
        color: white;
      }
      .course-actions {
        display: flex;
        gap: 8px;
        margin-top: 10px;
      }
      .course-actions .btn {
        flex: 1;
        padding: 8px 12px;
        font-size: 13px;
        border-radius: 6px;
        transition: all 0.3s ease;
        border: none;
      }
      .course-actions .btn-info {
        background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
        color: white;
      }
      .course-actions .btn-info:hover {
        background: linear-gradient(135deg, #138496 0%, #0c5460 100%);
        transform: translateY(-2px);
        color: white;
      }
      .course-actions .btn-danger {
        background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        color: white;
      }
      .course-actions .btn-danger:hover {
        background: linear-gradient(135deg, #c82333 0%, #bd2130 100%);
        transform: translateY(-2px);
        color: white;
      }
    </style>

    <div class="page-container">
      <!-- Navigation -->
      <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
          <a class="navbar-brand" href="${pageContext.request.contextPath}/"
            >WebLab</a
          >
          <div class="navbar-collapse">
            <ul class="navbar-nav ml-auto">
              <li class="nav-item">
                <span class="nav-link">Admin: <%= user.getUsername() %></span>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link"
                  href="${pageContext.request.contextPath}/logout"
                  >Logout</a
                >
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <!-- Content -->
      <div class="content">
        <div class="container mt-5">
          <div class="row mb-4">
            <div class="col-md-8">
              <h2>All Courses</h2>
            </div>
            <div class="col-md-4 text-right">
              <div class="btn-action-group justify-content-end">
                <a
                  href="${pageContext.request.contextPath}/admin/dashboard"
                  class="go-dashboard-btn"
                >
                  ← Back to Dashboard
                </a>
                <a
                  href="${pageContext.request.contextPath}/admin/courses"
                  class="btn btn-primary"
                >
                  Add New Course
                </a>
              </div>
            </div>
          </div>

          <% if (courses != null && !courses.isEmpty()) { %>
          <div class="row">
            <% for (Course course : courses) { %>
            <div class="col-md-6 col-lg-4 mb-4">
              <div class="card course-card h-100">
                <div class="card-body">
                  <h5 class="card-title"><%= course.getName() %></h5>
                  <p class="card-text text-muted small">
                    <%= course.getDescription() != null ?
                    (course.getDescription().length() > 60 ?
                    course.getDescription().substring(0, 60) + "..." :
                    course.getDescription()) : "No description" %>
                  </p>
                  <hr />
                  <div class="mb-2">
                    <small
                      ><strong>Teacher:</strong> <%= course.getTeacherName()
                      %></small
                    >
                  </div>
                  <div class="mb-2">
                    <span class="badge badge-capacity">
                      Enrolled: <%= course.getEnrolledCount() %> / <%=
                      course.getCapacity() %>
                    </span>
                  </div>
                  <div class="mb-2">
                    <small class="text-muted">ID: <%= course.getId() %></small>
                  </div>
                </div>
                <div class="card-footer bg-white">
                  <small class="text-muted">
                    Status:
                    <span class="badge badge-success"
                      ><%= course.getStatus() %></span
                    >
                  </small>
                  <div class="course-actions">
                    <a href="${pageContext.request.contextPath}/admin/courses?action=viewStudents&courseId=<%= course.getId() %>" class="btn btn-info btn-sm">
                      View Students
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/courses?action=delete&courseId=<%= course.getId() %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this course?');">
                      Delete
                    </a>
                  </div>
                </div>
              </div>
            </div>
            <% } %>
          </div>
          <% } else { %>
          <div class="empty-state">
            <h4>No Courses Found</h4>
            <p class="text-muted">Get started by creating a new course.</p>
            <a
              href="${pageContext.request.contextPath}/admin/courses"
              class="btn btn-primary"
            >
              Add First Course
            </a>
          </div>
          <% } %>
        </div>
      </div>
    </div>

    <%@ include file="../common/footer.jsp" %>
  </Course></Course
>
