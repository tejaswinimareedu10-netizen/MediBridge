<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor Registration - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card p-4 shadow-sm border-0 rounded-4">
                <h3 class="fw-bold text-success text-center mb-3">👨‍⚕️ Doctor Registration</h3>

                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger py-2 small text-center fw-bold">
                        <%= request.getParameter("error") %>
                    </div>
                <% } %>

                <form action="DoctorRegisterServlet" method="POST">
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Full Name</label>
                        <input type="text" name="fullName" class="form-control" placeholder="Dr. Full Name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Email Address</label>
                        <input type="email" name="email" class="form-control" placeholder="doctor@gmail.com" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Password</label>
                        <input type="password" name="password" class="form-control" placeholder="Set Password" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Specialization</label>
                        <select name="specialization" class="form-select" required>
                            <option value="cardiology">cardiology</option>
                            <option value="gynic">gynic</option>
                            <option value="dermtalogist">dermtalogist</option>
                            <option value="General Medicine">General Medicine</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Phone Number</label>
                        <input type="text" name="phone" class="form-control" placeholder="10 Digit Mobile Number" required>
                    </div>
                    <button type="submit" class="btn btn-success w-100 fw-bold py-2 mb-2">Register Doctor Account</button>
                    <a href="doctorLogin.jsp" class="btn btn-outline-secondary w-100 fw-bold">Already Registered? Login</a>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>