<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.medibridge.model.Patient"%>
<%@page import="com.medibridge.model.Doctor"%>

<%
    Patient patient = (Patient) session.getAttribute("patient");
    Doctor doctor = (Doctor) session.getAttribute("doctor");
    boolean isLoggedIn = (patient != null || doctor != null);
    
    String userName = "";
    String userRole = "";

    if (patient != null) {
        try { userName = patient.getFullName(); } catch(Exception e) { userName = "Patient"; }
        userRole = "Patient";
    } else if (doctor != null) {
        try { userName = "Dr. " + doctor.getFullName(); } catch(Exception e) { userName = "Doctor"; }
        userRole = "Doctor";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>MediBridge - Smart Healthcare System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        .hero-banner {
            background: linear-gradient(rgba(0, 0, 0, 0.35), rgba(0, 0, 0, 0.35)), 
                        url('images/hospital.jpg') no-repeat center center;
            background-size: 100% 100%;
            min-height: calc(100vh - 70px);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }
        .account-btn {
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 6px 16px;
            border-radius: 30px;
        }
        .dropdown-menu-custom {
            min-width: 260px;
            border-radius: 12px;
            border: none;
        }
        .service-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-radius: 12px;
        }
        .service-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.15) !important;
        }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark sticky-top" style="background-color: #0d6efd;">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold fs-3 d-flex align-items-center text-white" href="index.jsp">
            <span class="me-2">🏥</span> MediBridge
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center gap-3">
                <li class="nav-item">
                    <a class="nav-link active text-white fw-bold" href="index.jsp">Home</a>
                </li>
               
                
                <% if (!isLoggedIn) { %>
                    <li class="nav-item">
                        <a class="btn btn-light text-primary fw-bold px-4 py-2 rounded-pill shadow-sm" href="portal.jsp">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Access Portal
                        </a>
                    </li>
                <% } else { %>
                    <li class="nav-item dropdown">
                        <button class="btn account-btn dropdown-toggle d-flex align-items-center gap-2 fw-semibold" 
                                type="button" id="accountMenu" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-person-circle fs-5 text-warning"></i>
                            <span><%= userName %></span>
                        </button>
                        
                        <ul class="dropdown-menu dropdown-menu-end dropdown-menu-custom shadow-lg p-2 mt-2" aria-labelledby="accountMenu">
                            <li class="px-3 py-2 bg-light rounded-3 mb-2">
                                <div class="fw-bold text-dark"><%= userName %></div>
                                <small class="badge bg-primary text-uppercase mt-1"><%= userRole %></small>
                            </li>

                            <% if ("Patient".equals(userRole)) { %>
                                <li>
                                    <a class="dropdown-item py-2 fw-semibold" href="patientDashboard.jsp">
                                        <i class="bi bi-speedometer2 text-primary me-2"></i> Dashboard
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2 fw-semibold" href="myAppointments.jsp">
                                        <i class="bi bi-calendar-check text-success me-2"></i> My Appointments
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2 fw-semibold" href="medicineReminder.jsp">
                                        <i class="bi bi-alarm text-danger me-2"></i> Medicine Reminders
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2 fw-semibold" href="searchDonor.jsp">
                                        <i class="bi bi-droplet-fill text-danger me-2"></i> Blood Donors
                                    </a>
                                </li>
                            <% } else if ("Doctor".equals(userRole)) { %>
                                <li>
                                    <a class="dropdown-item py-2 fw-semibold" href="doctorDashboard.jsp">
                                        <i class="bi bi-speedometer2 text-primary me-2"></i> Dashboard
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2 fw-semibold" href="doctorAppointments.jsp">
                                        <i class="bi bi-journal-medical text-info me-2"></i> Patient Consultations
                                    </a>
                                </li>
                            <% } %>

                            <li><hr class="dropdown-divider my-2"></li>

                            <li>
                                <a class="dropdown-item py-2 fw-semibold text-danger" href="LogoutServlet">
                                    <i class="bi bi-box-arrow-right me-2"></i> Logout
                                </a>
                            </li>
                        </ul>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<div class="hero-banner">
    <div class="container">
        <h1 class="display-2 fw-bold text-white mb-3">Your Health, Our Priority</h1>
        <p class="fs-4 text-light mb-4">Book appointments with trusted specialists, track OP tokens, and access diagnostic care anytime.</p>
        
        <div class="d-flex justify-content-center">
            <% if (!isLoggedIn) { %>
                <a href="portal.jsp" class="btn btn-primary btn-lg px-5 py-3 rounded-pill fw-bold shadow">
                    Enter Portal Gateway
                </a>
            <% } else if ("Patient".equals(userRole)) { %>
                <a href="patientDashboard.jsp" class="btn btn-warning text-dark btn-lg px-5 py-3 rounded-pill fw-bold shadow">
                    <i class="bi bi-heart-pulse-fill me-2"></i>Manage My Health
                </a>
            <% } else if ("Doctor".equals(userRole)) { %>
                <a href="doctorDashboard.jsp" class="btn btn-warning text-dark btn-lg px-5 py-3 rounded-pill fw-bold shadow">
                    <i class="bi bi-journal-medical me-2"></i>Doctor Console
                </a>
            <% } %>
        </div>
    </div>
</div>

<section id="services" class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <h6 class="text-primary fw-bold text-uppercase">Healthcare Offerings</h6>
            <h2 class="fw-bold text-dark">Comprehensive Clinical Services</h2>
            <p class="text-muted">Modern medical care delivered by certified specialist doctors.</p>
        </div>

        <div class="row g-4">
            <div class="col-md-3">
                <div class="card service-card border-0 shadow-sm p-4 text-center h-100">
                    <i class="bi bi-calendar-check-fill text-primary display-4 mb-3"></i>
                    <h5 class="fw-bold">Outpatient Consultations</h5>
                    <p class="text-muted small">Instant token booking with General Physicians, Cardiologists & Orthopedics.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card service-card border-0 shadow-sm p-4 text-center h-100">
                    <i class="bi bi-hospital-fill text-danger display-4 mb-3"></i>
                    <h5 class="fw-bold">24x7 Emergency Care</h5>
                    <p class="text-muted small">Round-the-clock emergency ICU readiness, trauma units, and advanced ambulance dispatch.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card service-card border-0 shadow-sm p-4 text-center h-100">
                    <i class="bi bi-file-earmark-medical-fill text-success display-4 mb-3"></i>
                    <h5 class="fw-bold">Digital Diagnostics</h5>
                    <p class="text-muted small">Online prescription records, lab test reports, and complete clinical session history.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card service-card border-0 shadow-sm p-4 text-center h-100">
                    <i class="bi bi-droplet-fill text-danger display-4 mb-3"></i>
                    <h5 class="fw-bold">Blood Donor Directory</h5>
                    <p class="text-muted small">Connect directly with active voluntary blood donors or register as a blood donor today.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="bg-primary text-white py-4 my-3">
    <div class="container d-flex flex-column flex-md-row align-items-center justify-content-between gap-3 text-center text-md-start">
        <div>
            <h4 class="fw-bold mb-1"><i class="bi bi-telephone-inbound-fill me-2"></i> Need Medical Emergency Help?</h4>
            <p class="mb-0 text-white-50">Our trauma desk and ambulance units are active 24 Hours a day.</p>
        </div>
        <a href="tel:108" class="btn btn-warning text-dark fw-bold px-4 py-2 rounded-pill shadow">
            Call Emergency 108
        </a>
    </div>
</section>

<footer id="contact" class="bg-dark text-white pt-5 pb-3">
    <div class="container text-center text-secondary small">
        &copy; 2026 MediBridge Healthcare System. All rights reserved.
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>