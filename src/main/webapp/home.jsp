<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weblab.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Home - WebLab</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .welcome-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 40px;
            margin: 20px 0;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }
        .role-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            background-color: rgba(255, 255, 255, 0.3);
            margin-top: 10px;
        }
        .info-card {
            border-left: 4px solid #667eea;
            margin-bottom: 15px;
        }
        .dashboard-link {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">WebLab</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <span class="nav-link">Welcome, <strong><%= user.getUsername() %></strong></span>
                    </li>
                    <li class="nav-item">
                        <span class="nav-link badge badge-primary"><%= user.getRole().toUpperCase() %></span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="welcome-card text-center">
                    <h1>Welcome, <%= user.getUsername() %>!</h1>
                    <p class="lead">You are logged in as a <strong><%= user.getRole().toUpperCase() %></strong></p>
                    <div class="role-badge">
                        Role: <span class="badge badge-light"><%= user.getRole() %></span>
                    </div>
                    <div class="dashboard-link">
                        <a href="${pageContext.request.contextPath}/home/<%= user.getRole() %>" class="btn btn-light btn-lg">
                            Go to Dashboard
                        </a>
                    </div>
                </div>

                <div class="card mt-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Account Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="info-card p-3">
                            <p><strong>User ID:</strong> <%= user.getId() %></p>
                        </div>
                        <div class="info-card p-3">
                            <p><strong>Email:</strong> <%= user.getUsername() %></p>
                        </div>
                        <div class="info-card p-3">
                            <p><strong>Role:</strong> <span class="badge badge-info"><%= user.getRole() %></span></p>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Logout</a>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-dark text-white text-center py-3 mt-5">
        <p>&copy; 2025 WebLab. All rights reserved.</p>
    </footer>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
