<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="WEB-INF/views/common/header.jsp" %>
    <div class="container">
        <div class="row">
            <div class="col-md-6 offset-md-3">
                <h2 class="text-center text-dark mt-5">Register</h2>
                <div class="card my-5">
                    <form class="card-body cardbody-color p-lg-5" action="register" method="post">
                        <div class="mb-3">
                            <input type="text" class="form-control" name="name" placeholder="Full Name" required>
                        </div>
                        <div class="mb-3">
                            <input type="email" class="form-control" name="email" placeholder="Email" required>
                        </div>
                        <div class="mb-3">
                            <input type="password" class="form-control" name="password" placeholder="Password" required>
                        </div>
                        <div class="mb-3">
                            <label for="role">Register as:</label>
                            <select class="form-control" name="role" id="role">
                                <option value="student">Student</option>
                                <option value="teacher">Teacher</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>
                        <div class="text-center">
                            <button type="submit" class="btn btn-color px-5 mb-5 w-100">Register</button>
                        </div>
                        <div id="emailHelp" class="form-text text-center mb-5 text-dark">
                            Already have an account? <a href="login.jsp" class="text-dark fw-bold"> Login here</a>
                        </div>
                        <% if (request.getAttribute("error") != null) { %>
                            <p class="text-danger text-center"><%= request.getAttribute("error") %></p>
                        <% } %>
                    </form>
                </div>
            </div>
        </div>
    </div>

<%@ include file="WEB-INF/views/common/footer.jsp" %>
