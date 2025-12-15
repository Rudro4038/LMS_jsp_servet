<%@ include file="WEB-INF/views/common/header.jsp" %>

<style>
    .welcome-container {
        min-height: calc(100vh - 200px);
        display: flex;
        align-items: center;
    }
    .welcome-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 15px;
        padding: 60px 40px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        text-align: center;
    }
    .welcome-card h1 {
        font-size: 48px;
        font-weight: bold;
        margin-bottom: 15px;
    }
    .welcome-card p {
        font-size: 18px;
        margin-bottom: 30px;
    }
    .btn-lg {
        padding: 12px 30px;
        font-size: 16px;
        margin: 10px;
    }
</style>

<div class="welcome-container">
    <div class="container">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="welcome-card">
                    <h1>Welcome to WebLab</h1>
                    <p class="lead">Course Management System</p>
                    <hr class="my-4" style="border-color: rgba(255,255,255,0.3);">
                    <p>Manage courses, track enrollments, and enhance your learning experience.</p>
                    <div class="mt-4">
                        <a class="btn btn-light btn-lg" href="${pageContext.request.contextPath}/login.jsp" role="button">
                            🔐 Login
                        </a>
                        <a class="btn btn-outline-light btn-lg" href="${pageContext.request.contextPath}/register.jsp" role="button">
                            ✍️ Register
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="WEB-INF/views/common/footer.jsp" %>
