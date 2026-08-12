<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.medibridge.model.Doctor"%>

<%
    Doctor doctor = (Doctor) session.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }

    String msg = null;

    // Load OT Schedule list from Session memory (or initialize defaults)
    List<Map<String, String>> otList = (List<Map<String, String>>) session.getAttribute("otScheduleList");
    if (otList == null) {
        otList = new ArrayList<>();
        
        // Initial Sample Data
        Map<String, String> ot1 = new HashMap<>();
        ot1.put("room", "OT-01 (Major)");
        ot1.put("patient", "Ramesh Kumar");
        ot1.put("procedure", "Laparoscopic Cholecystectomy");
        ot1.put("time", "Tomorrow - 10:30 AM");
        ot1.put("lead", "Dr. Anitha (MD Anesthesia)");
        ot1.put("status", "SCHEDULED");
        otList.add(ot1);

        session.setAttribute("otScheduleList", otList);
    }

    // Dynamic Form Submission Handler to Schedule New Operation
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String otRoom = request.getParameter("otRoom");
        String patientName = request.getParameter("patientName");
        String procedure = request.getParameter("procedure");
        String scheduleTime = request.getParameter("scheduleTime");
        String leadDoctor = request.getParameter("leadDoctor");

        if (patientName != null && procedure != null) {
            Map<String, String> newOt = new HashMap<>();
            newOt.put("room", otRoom);
            newOt.put("patient", patientName.trim());
            newOt.put("procedure", procedure.trim());
            newOt.put("time", scheduleTime);
            newOt.put("lead", leadDoctor.trim());
            newOt.put("status", "SCHEDULED");

            otList.add(0, newOt); // Add top to list
            session.setAttribute("otScheduleList", otList);

            msg = "Surgical Operation successfully scheduled for " + patientName + " in " + otRoom;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>OT Schedule - MediBridge</title>
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
                <i class="bi bi-hospital-fill me-2"></i>Operation Theatre (OT) Surgical Schedule
            </h3>
            <p class="text-muted small mb-0">Schedule and monitor upcoming surgical procedures & OT availability</p>
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

    <!-- Schedule New OT Form Card -->
    <div class="card p-4 shadow-sm border-0 rounded-4 mb-4 bg-white">
        <h5 class="fw-bold text-danger mb-3"><i class="bi bi-plus-circle-fill me-2"></i>Schedule New Surgical Operation</h5>
        <form action="operationSchedule.jsp" method="POST" class="row g-3">
            <div class="col-md-3">
                <label class="form-label fw-bold small">Select OT Room</label>
                <select name="otRoom" class="form-select" required>
                    <option value="OT-01 (Major)">OT-01 (Major)</option>
                    <option value="OT-02 (Cardiac)">OT-02 (Cardiac)</option>
                    <option value="OT-03 (Minor)">OT-03 (Minor)</option>
                    <option value="OT-04 (Emergency)">OT-04 (Emergency)</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-bold small">Patient Name</label>
                <input type="text" name="patientName" class="form-control" placeholder="e.g. Bhargavi / Suresh" required>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-bold small">Surgery / Procedure Name</label>
                <input type="text" name="procedure" class="form-control" placeholder="e.g. Appendectomy" required>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-bold small">Scheduled Date & Time</label>
                <input type="text" name="scheduleTime" class="form-control" placeholder="e.g. Today - 04:00 PM" required>
            </div>
            <div class="col-md-9">
                <label class="form-label fw-bold small">Lead Surgeon / Anesthetist</label>
                <input type="text" name="leadDoctor" class="form-control" value="Dr. <%= doctor.getFullName() %> (Lead Surgeon)" required>
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <button type="submit" class="btn btn-danger w-100 fw-bold py-2">
                    <i class="bi bi-calendar-plus me-1"></i> Confirm OT Booking
                </button>
            </div>
        </form>
    </div>

    <!-- Scheduled OT Operations Table (Dynamic List) -->
    <div class="card p-4 shadow-sm border-0 rounded-4">
        <h5 class="fw-bold text-dark mb-3"><i class="bi bi-activity me-2 text-danger"></i>Active OT Surgical Schedule Log</h5>
        
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-danger">
                    <tr>
                        <th>OT Room No</th>
                        <th>Patient Name</th>
                        <th>Surgery Type / Procedure</th>
                        <th>Scheduled Date & Time</th>
                        <th>Anesthetist / Lead</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    for (Map<String, String> ot : otList) {
                %>
                        <tr>
                            <td class="fw-bold text-danger"><%= ot.get("room") %></td>
                            <td class="fw-bold text-dark"><%= ot.get("patient") %></td>
                            <td><%= ot.get("procedure") %></td>
                            <td><%= ot.get("time") %></td>
                            <td><%= ot.get("lead") %></td>
                            <td><span class="badge bg-warning text-dark"><%= ot.get("status") %></span></td>
                        </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>