<%@ page contentType="text/html; charset=UTF-8" %> <%@ page
import="com.weblab.model.User" %> <% User user = (User)
session.getAttribute("user"); if (user == null ||
!"admin".equals(user.getRole())) {
response.sendRedirect(request.getContextPath() + "/login.jsp"); return; } %> <%@
include file="../common/header.jsp" %>

<style>
  .form-container {
    max-width: 600px;
    margin: 50px auto;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    background: white;
  }
  .btn-group-custom {
    display: flex;
    gap: 10px;
    margin-top: 20px;
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
    margin-bottom: 20px;
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
          <span class="nav-link">Admin: <%= user.getUsername() %></span>
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

<div class="container">
  <div class="form-container">
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px;">
      <h2 class="mb-0">Add New Course</h2>
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="go-dashboard-btn">
        ← Back to Dashboard
      </a>
    </div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger" role="alert">
      <%= request.getAttribute("error") %>
    </div>
    <% } %> <% if (request.getAttribute("message") != null) { %>
    <div class="alert alert-success" role="alert">
      <%= request.getAttribute("message") %>
    </div>
    <% } %>

    <form
      action="${pageContext.request.contextPath}/admin/courses"
      method="post"
    >
      <input type="hidden" name="action" value="addCourse" />

      <div class="form-group">
        <label for="courseName"><strong>Course Name *</strong></label>
        <input
          type="text"
          class="form-control"
          id="courseName"
          name="courseName"
          placeholder="e.g., Web Development 101"
          required
          maxlength="255"
        />
      </div>

      <div class="form-group">
        <label for="description"><strong>Description</strong></label>
        <textarea
          class="form-control"
          id="description"
          name="description"
          rows="4"
          placeholder="Enter course description"
        ></textarea>
      </div>

      <div class="form-group">
        <label for="teacherId"><strong>Assign Teacher *</strong></label>
        <input
          type="number"
          class="form-control"
          id="teacherId"
          name="teacherId"
          placeholder="Enter Teacher ID"
          required
          min="1"
        />
        <small class="form-text text-muted">
          Note: Make sure the user ID exists and has teacher role
        </small>
      </div>

      <div class="form-group">
        <label for="capacity"
          ><strong>Course Capacity (Max Students) *</strong></label
        >
        <input
          type="number"
          class="form-control"
          id="capacity"
          name="capacity"
          placeholder="e.g., 30"
          required
          min="1"
          max="500"
          value="30"
        />
        <small class="form-text text-muted"> Between 1 and 500 students </small>
      </div>

      <div class="btn-group-custom">
        <button type="submit" class="btn btn-primary flex-grow-1">
          Add Course
        </button>
        <a
          href="${pageContext.request.contextPath}/admin/courses?action=view"
          class="btn btn-secondary flex-grow-1"
          >View All Courses</a
        >
      </div>
    </form>
  </div>
</div>

<%@ include file="../common/footer.jsp" %>
