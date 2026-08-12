<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Access Portal - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand fw-bold" href="index.jsp">🏥 MediBridge Hub</a>
        <a href="index.jsp" class="btn btn-sm btn-outline-light">Back to Home</a>
    </div>
</nav>

<div class="container mt-5 py-4">
    <div class="text-center mb-5">
        <h2 class="fw-bold text-dark">🔐 Select Your Gateway</h2>
        <p class="text-muted">Please log in or register to access specialized clinical services.</p>
    </div>

    <div class="row g-4 justify-content-center">
        <div class="col-md-5">
            <div class="card p-4 shadow-sm border-0 border-top border-primary border-4 h-100 text-center">
                <div class="mb-3">
                    <i class="bi bi-person-circle text-primary display-3"></i>
                </div>
                <h4 class="text-primary fw-bold">Patient Portal</h4>
                <p class="text-muted small">Access your personal health profile, schedule consultations, view active prescriptions, and check medication reminders.</p>
                <div class="d-grid gap-2 mt-auto">
                    <a href="login.jsp" class="btn btn-primary fw-bold">Patient Login</a>
                    <a href="register.jsp" class="btn btn-outline-primary">New Patient? Register</a>
                </div>
            </div>
        </div>

        <div class="col-md-5">
            <div class="card p-4 shadow-sm border-0 border-top border-info border-4 h-100 text-center">
                <div class="mb-3">
                    <i class="bi bi-heart-pulse-fill text-info display-3"></i>
                </div>
                <h4 class="text-info fw-bold">Doctor Portal</h4>
                <p class="text-muted small">Review incoming patient checkup requests, approve schedules, write digital diagnostic prescriptions, and update treatment histories.</p>
                <div class="d-grid gap-2 mt-auto">
                    <a href="doctorLogin.jsp" class="btn btn-info text-white fw-bold">Doctor Login</a>
                    <a href="doctorRegister.jsp" class="btn btn-outline-info">New Doctor? Register</a>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="text-center p-3 text-muted bg-white border-top fixed-bottom">
    MediBridge Secure Gateway &copy; 2026
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>