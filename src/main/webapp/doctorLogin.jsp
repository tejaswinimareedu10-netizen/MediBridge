<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Login - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="container my-5 py-4">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
            <div class="card p-4 shadow-sm border-0 rounded-4">
                <div class="text-center mb-3">
                    <span class="display-4 text-success"><i class="bi bi-person-badge"></i></span>
                    <h3 class="fw-bold text-success mt-2">Doctor Portal</h3>
                    <p class="text-muted small">MediBridge Medical System</p>
                </div>

                <% 
                    String error = request.getParameter("error");
                    String msg = request.getParameter("msg");
                    if (error != null) { 
                %>
                    <div class="alert alert-danger py-2 small text-center fw-bold">
                        <i class="bi bi-exclamation-circle-fill me-1"></i> <%= error %>
                    </div>
                <% } else if (msg != null) { %>
                    <div class="alert alert-success py-2 small text-center fw-bold">
                        <i class="bi bi-check-circle-fill me-1"></i> <%= msg %>
                    </div>
                <% } %>

                <form action="DoctorLoginServlet" method="POST">
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Doctor Email</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-envelope"></i></span>
                            <input type="email" name="email" class="form-control" placeholder="doctor@gmail.com" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-lock"></i></span>
                            <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-success w-100 fw-bold py-2 mb-2">Doctor Login</button>
                    <a href="doctorRegister.jsp" class="btn btn-outline-success w-100 fw-bold mb-2">New Doctor? Register Here</a>
                    <a href="index.jsp" class="btn btn-link text-decoration-none text-muted w-100 text-center small">Back to Home</a>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>