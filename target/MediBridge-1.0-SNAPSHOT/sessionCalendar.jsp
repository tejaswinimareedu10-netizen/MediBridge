<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.medibridge.model.Doctor"%>

<%
    Doctor doctor = (Doctor) session.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }

    String msg = null;

    // Load existing statuses from session (or set default baseline)
    String monFriStatus = (session.getAttribute("monFriStatus") != null) ? (String) session.getAttribute("monFriStatus") : "ACTIVE";
    String satStatus = (session.getAttribute("satStatus") != null) ? (String) session.getAttribute("satStatus") : "LIMITED";
    String sunStatus = (session.getAttribute("sunStatus") != null) ? (String) session.getAttribute("sunStatus") : "OFFDAY";

    // Dynamic Form POST Handler
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String selectedDay = request.getParameter("selectedDay");
        String sessionStatus = request.getParameter("sessionStatus");

        if (selectedDay != null && sessionStatus != null) {
            if ("Monday - Friday".equals(selectedDay)) {
                monFriStatus = sessionStatus;
                session.setAttribute("monFriStatus", monFriStatus);
            } else if ("Saturday".equals(selectedDay)) {
                satStatus = sessionStatus;
                session.setAttribute("satStatus", satStatus);
            } else if ("Sunday".equals(selectedDay)) {
                sunStatus = sessionStatus;
                session.setAttribute("sunStatus", sunStatus);
            }
            msg = "Schedule for " + selectedDay + " successfully updated to: " + sessionStatus;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Session Calendar - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
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
                <i class="bi bi-person-badge-fill text-warning me-1"></i> Dr. <%= doctor.getFullName() %>
            </span>
            <a href="doctorDashboard.jsp" class="btn btn-light text-success btn-sm fw-bold">Back to Dashboard</a>
        </div>
    </div>
</nav>

<div class="container my-5">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold text-danger mb-0">
                <i class="bi bi-calendar3 me-2"></i>Consultation Session Calendar
            </h3>
            <p class="text-muted small mb-0">Set and manage weekly OPD consultation slots & availability</p>
        </div>
        <a href="doctorDashboard.jsp" class="btn btn-outline-secondary fw-bold">
            <i class="bi bi-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <% if (msg != null) { %>
        <div class="alert alert-success alert-dismissible fade show fw-bold text-center py-2 mb-4" role="alert">
            <i class="bi bi-check-circle-fill me-1"></i> <%= msg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <div class="row g-4">
        <!-- Weekly Slots Display Table (Now Dynamic) -->
        <div class="col-md-8">
            <div class="card p-4 shadow-sm border-0 rounded-4">
                <h5 class="fw-bold text-dark mb-3"><i class="bi bi-clock-history me-2 text-danger"></i>Active Consultation Sessions</h5>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-danger">
                            <tr>
                                <th>Day</th>
                                <th>Session Time</th>
                                <th>Max Tokens</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="fw-bold">Monday - Friday</td>
                                <td>09:00 AM - 01:00 PM (Morning OP)</td>
                                <td><span class="badge bg-secondary">30 Tokens</span></td>
                                <td>
                                    <% if ("ACTIVE".equalsIgnoreCase(monFriStatus)) { %>
                                        <span class="badge bg-success">ACTIVE</span>
                                    <% } else if ("LIMITED".equalsIgnoreCase(monFriStatus)) { %>
                                        <span class="badge bg-warning text-dark">LIMITED</span>
                                    <% } else { %>
                                        <span class="badge bg-danger">OFFDAY / LEAVE</span>
                                    <% } %>
                                </td>
                            </tr>
                            <tr>
                                <td class="fw-bold">Monday - Friday</td>
                                <td>05:00 PM - 08:00 PM (Evening OP)</td>
                                <td><span class="badge bg-secondary">20 Tokens</span></td>
                                <td>
                                    <% if ("ACTIVE".equalsIgnoreCase(monFriStatus)) { %>
                                        <span class="badge bg-success">ACTIVE</span>
                                    <% } else if ("LIMITED".equalsIgnoreCase(monFriStatus)) { %>
                                        <span class="badge bg-warning text-dark">LIMITED</span>
                                    <% } else { %>
                                        <span class="badge bg-danger">OFFDAY / LEAVE</span>
                                    <% } %>
                                </td>
                            </tr>
                            <tr>
                                <td class="fw-bold">Saturday</td>
                                <td>10:00 AM - 02:00 PM (Special OP)</td>
                                <td><span class="badge bg-secondary">15 Tokens</span></td>
                                <td>
                                    <% if ("ACTIVE".equalsIgnoreCase(satStatus)) { %>
                                        <span class="badge bg-success">ACTIVE</span>
                                    <% } else if ("LIMITED".equalsIgnoreCase(satStatus)) { %>
                                        <span class="badge bg-warning text-dark">LIMITED</span>
                                    <% } else { %>
                                        <span class="badge bg-danger">OFFDAY / LEAVE</span>
                                    <% } %>
                                </td>
                            </tr>
                            <tr>
                                <td class="fw-bold">Sunday</td>
                                <td>Emergency / Call Only</td>
                                <td><span class="badge bg-secondary">0 Tokens</span></td>
                                <td>
                                    <% if ("ACTIVE".equalsIgnoreCase(sunStatus)) { %>
                                        <span class="badge bg-success">ACTIVE</span>
                                    <% } else if ("LIMITED".equalsIgnoreCase(sunStatus)) { %>
                                        <span class="badge bg-warning text-dark">LIMITED</span>
                                    <% } else { %>
                                        <span class="badge bg-danger">OFFDAY / LEAVE</span>
                                    <% } %>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Active Update Availability Form -->
        <div class="col-md-4">
            <div class="card p-4 shadow-sm border-0 rounded-4">
                <h5 class="fw-bold text-dark mb-3"><i class="bi bi-gear-fill me-2 text-danger"></i>Update Availability</h5>
                <form action="sessionCalendar.jsp" method="POST">
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Select Day</label>
                        <select name="selectedDay" class="form-select" required>
                            <option value="Monday - Friday">Monday - Friday</option>
                            <option value="Saturday">Saturday</option>
                            <option value="Sunday">Sunday</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Session Status</label>
                        <select name="sessionStatus" class="form-select" required>
                            <option value="ACTIVE">ACTIVE</option>
                            <option value="LIMITED">LIMITED</option>
                            <option value="OFFDAY / LEAVE">OFFDAY / LEAVE</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-danger w-100 fw-bold py-2">
                        <i class="bi bi-check-circle me-1"></i> Update Schedule
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>