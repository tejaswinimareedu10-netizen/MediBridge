<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.medibridge.model.Patient"%>

<%
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Patient Dashboard - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        .service-card { transition: transform 0.2s ease; border-radius: 14px; }
        .service-card:hover { transform: translateY(-5px); }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm py-2">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="patientDashboard.jsp">🏥 MediBridge</a>
        <div class="ms-auto d-flex align-items-center gap-3">
            <span class="text-white fw-bold"><i class="bi bi-person-circle text-warning me-1"></i> <%= patient.getFullName() %></span>
            <a href="LogoutServlet" class="btn btn-light text-danger btn-sm fw-bold">Logout</a>
        </div>
    </div>
</nav>

<div class="container my-5">
    <div class="p-4 bg-white rounded-3 shadow-sm mb-4 border-start border-primary border-5 d-flex align-items-center justify-content-between">
        <div>
            <h3 class="fw-bold mb-1">Welcome back, <%= patient.getFullName() %>! 👋</h3>
            <p class="text-muted mb-0">Select a service below to manage your healthcare requests.</p>
        </div>
        <span class="badge bg-primary fs-6 px-3 py-2">Patient ID: #<%= patient.getPatientId() %></span>
    </div>

    <div class="row g-4">
        <!-- Module 1: Generate Token -->
        <div class="col-md-6">
            <div class="card service-card p-4 shadow-sm border-0 h-100 text-center">
                <i class="bi bi-ticket-perforated-fill text-primary display-3 mb-3"></i>
                <h4 class="fw-bold">OP Tokens & Appointments</h4>
                <p class="text-muted">Generate instant OP consultation tokens or view past visit status.</p>
                <div class="d-flex justify-content-center gap-2 mt-auto">
                    <a href="generateOPToken.jsp" class="btn btn-primary fw-bold px-4">Generate Token</a>
                    <a href="myAppointments.jsp" class="btn btn-outline-primary fw-bold px-4">My Visits</a>
                </div>
            </div>
        </div>

        <!-- Module 2: Medical Records -->
        <div class="col-md-6">
            <div class="card service-card p-4 shadow-sm border-0 h-100 text-center">
                <i class="bi bi-journal-medical text-success display-3 mb-3"></i>
                <h4 class="fw-bold">Medical & OP Records</h4>
                <p class="text-muted">Access doctor prescriptions, treatment history, and OP visit logs.</p>
                <div class="d-flex justify-content-center gap-2 mt-auto">
                    <a href="myOpRecords.jsp" class="btn btn-success fw-bold px-4">OP Records</a>
                    <a href="medicalReports.jsp" class="btn btn-outline-success fw-bold px-4">Lab Reports</a>
                </div>
            </div>
        </div>

        <!-- Module 3: Medicine Reminders -->
        <div class="col-md-6">
            <div class="card service-card p-4 shadow-sm border-0 h-100 text-center">
                <i class="bi bi-alarm-fill text-warning display-3 mb-3"></i>
                <h4 class="fw-bold">Medicine Reminders</h4>
                <p class="text-muted">Set daily dosage timers so you never miss a daily pill.</p>
                <div class="d-flex justify-content-center mt-auto">
                    <a href="medicineReminder.jsp" class="btn btn-warning text-dark fw-bold px-5">Manage Pill Alarms</a>
                </div>
            </div>
        </div>

        <!-- Module 4: Blood Donor Hub -->
        <div class="col-md-6">
            <div class="card service-card p-4 shadow-sm border-0 h-100 text-center">
                <i class="bi bi-droplet-fill text-danger display-3 mb-3"></i>
                <h4 class="fw-bold">Blood Donor Hub</h4>
                <p class="text-muted">Search emergency blood donors by group or register yourself.</p>
                <div class="d-flex justify-content-center gap-2 mt-auto">
                    <a href="searchDonor.jsp" class="btn btn-danger fw-bold px-4">Search Donor</a>
                    <a href="donorRegister.jsp" class="btn btn-outline-danger fw-bold px-4">Register as Donor</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>