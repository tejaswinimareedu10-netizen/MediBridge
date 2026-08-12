<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Login - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container my-5 py-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card p-4 shadow-sm border-0 rounded-3">
                <h3 class="text-primary fw-bold text-center mb-3">Patient Login</h3>
                
                <% String error = request.getParameter("error"); %>
                <% if(error != null) { %>
                    <div class="alert alert-danger py-2 small text-center"><%= error %></div>
                <% } %>

                <form action="PatientLoginServlet" method="POST">
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Email Address</label>
                        <input type="email" name="email" class="form-control" required placeholder="name@example.com">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Password</label>
                        <input type="password" name="password" class="form-control" required placeholder="Enter password">
                    </div>
                    <button type="submit" class="btn btn-primary w-100 fw-bold py-2 mt-2">Login</button>
                </form>
                
                <div class="text-center mt-3">
                    <small class="text-muted">Don't have an account? <a href="register.jsp">Register Here</a></small>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>