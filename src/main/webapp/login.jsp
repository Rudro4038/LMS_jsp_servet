<%@ include file="WEB-INF/views/common/header.jsp" %>

<div class="container">
  <div class="row">
    <div class="col-md-6 offset-md-3">
      <h2 class="text-center text-dark mt-5">Login</h2>
      <div class="card my-5">
        <form
          class="card-body cardbody-color p-lg-5"
          action="login"
          method="post"
        >
          <div class="text-center">
            <img
              src="https://cdn.pixabay.com/photo/2016/03/31/19/56/avatar-1295397__340.png"
              class="img-fluid profile-image-pic img-thumbnail rounded-circle my-3"
              width="200px"
              alt="profile"
            />
          </div>
          <div class="mb-3">
            <input
              type="email"
              class="form-control"
              name="email"
              placeholder="Email"
            />
          </div>
          <div class="mb-3">
            <input
              type="password"
              class="form-control"
              name="password"
              placeholder="Password"
            />
          </div>
          <div class="mb-3">
            <label for="role">Login as:</label>
            <select class="form-control" name="role" id="role">
              <option value="student">Student</option>
              <option value="teacher">Teacher</option>
              <option value="admin">Admin</option>
            </select>
          </div>
          <div class="text-center">
            <button type="submit" class="btn btn-color px-5 mb-5 w-100">
              📚 Login
            </button>
          </div>
          <div id="emailHelp" class="form-text text-center mb-5 text-dark">
            Don't have an account?
            <a href="register.jsp" class="text-dark fw-bold">
              Create an Account</a
            >
          </div>
          <% if (request.getAttribute("error") != null) { %>
          <p class="text-danger text-center">
            <%= request.getAttribute("error") %>
          </p>
          <% } %>
        </form>
      </div>
    </div>
  </div>
</div>

<%@ include file="WEB-INF/views/common/footer.jsp" %>
