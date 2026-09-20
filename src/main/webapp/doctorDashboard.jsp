<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.medibridge.model.Doctor"%>

<%
    Doctor doctor = (Doctor) session.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Dashboard - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        .service-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border-radius: 14px;
        }
        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important;
        }
    </style>
</head>
<body class="bg-light">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success shadow-sm py-2">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="doctorDashboard.jsp">
            <span class="me-2">👨‍⚕️</span> MediBridge Doctor Desk
        </a>
        <div class="ms-auto d-flex align-items-center gap-3">
            <span class="text-white fw-bold">
                <i class="bi bi-person-badge-fill text-warning me-1"></i> <%= doctor.getFullName() %> (<%= doctor.getSpecialization() %>)
            </span>
            <a href="LogoutServlet" class="btn btn-light text-danger btn-sm fw-bold">Logout</a>
        </div>
    </div>
</nav>

<div class="container my-5">
    
    <!-- Welcome Header Banner -->
    <div class="p-4 bg-white rounded-3 shadow-sm mb-4 border-start border-success border-5 d-flex justify-content-between align-items-center">
        <div>
            <h3 class="fw-bold mb-1">Welcome, Dr. <%= doctor.getFullName() %>! 👋</h3>
            <p class="text-muted mb-0">Select a service below to manage your daily consultations, appointments, and patient care.</p>
        </div>
        <span class="badge bg-success px-3 py-2 fs-6">
            <i class="bi bi-patch-check-fill me-1"></i> APPROVED DOCTOR
        </span>
    </div>

    <!-- 4 Structured Doctor Modules -->
    <div class="row g-4">

        <!-- 1. Appointments & OP Queue -->
        <div class="col-md-6">
            <div class="card service-card p-4 shadow-sm border-0 h-100 text-center">
                <i class="bi bi-calendar2-check-fill text-success display-3 mb-3"></i>
                <h4 class="fw-bold">Appointments & OP Queue</h4>
                <p class="text-muted">Manage today's scheduled patient visits and monitor the live outpatient token queue.</p>
                <div class="d-flex justify-content-center gap-2 mt-auto">
                    <a href="todayAppointments.jsp" class="btn btn-success fw-bold px-4">Today's Visits</a>
                    <a href="manageOpTokens.jsp" class="btn btn-outline-success fw-bold px-4">OP Queue Desk</a>
                </div>
            </div>
        </div>

        <!-- 2. Patient Desk & Medical History -->
        <div class="col-md-6">
            <div class="card service-card p-4 shadow-sm border-0 h-100 text-center">
                <i class="bi bi-people-fill text-primary display-3 mb-3"></i>
                <h4 class="fw-bold">Patient Directory & History</h4>
                <p class="text-muted">Search registered patients, review past clinical treatment history, and access patient logs.</p>
                <div class="d-flex justify-content-center gap-2 mt-auto">
                    <a href="patientList.jsp" class="btn btn-primary fw-bold px-4">Patient List</a>
                    <a href="patientHistory.jsp" class="btn btn-outline-primary fw-bold px-4">Medical History</a>
                </div>
            </div>
        </div>

        <!-- 3. Prescriptions & Lab Reports -->
        <div class="col-md-6">
            <div class="card service-card p-4 shadow-sm border-0 h-100 text-center">
                <i class="bi bi-prescription2 text-warning display-3 mb-3"></i>
                <h4 class="fw-bold">Prescriptions & Lab Reports</h4>
                <p class="text-muted">Generate digital prescriptions with dosage instructions and upload diagnostic lab test results.</p>
                <div class="d-flex justify-content-center gap-2 mt-auto">
                    <a href="addPrescription.jsp" class="btn btn-warning text-dark fw-bold px-4">Add Prescription</a>
                    <a href="uploadReport.jsp" class="btn btn-outline-warning text-dark fw-bold px-4">Upload Reports</a>
                </div>
            </div>
        </div>

        <!-- 4. Schedule & Operations Desk -->
        <div class="col-md-6">
            <div class="card service-card p-4 shadow-sm border-0 h-100 text-center">
                <i class="bi bi-hospital-fill text-danger display-3 mb-3"></i>
                <h4 class="fw-bold">Schedule & OT Operations</h4>
                <p class="text-muted">Set up consultation availability calendars and schedule surgical procedures / OT bookings.</p>
                <div class="d-flex justify-content-center gap-2 mt-auto">
                    <a href="sessionCalendar.jsp" class="btn btn-danger fw-bold px-4">Session Calendar</a>
                    <a href="operationSchedule.jsp" class="btn btn-outline-danger fw-bold px-4">OT Schedule</a>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>