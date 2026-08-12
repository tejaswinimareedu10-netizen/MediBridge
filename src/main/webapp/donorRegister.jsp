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
    <title>Become Blood Donor - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card p-4 shadow-sm border-0 rounded-4">
                <div class="text-center mb-3">
                    <span class="display-4 text-danger"><i class="bi bi-droplet-fill"></i></span>
                    <h3 class="fw-bold text-danger mt-2">Register as Blood Donor</h3>
                    <p class="text-muted small">Save lives by registering in our MediBridge Blood Donor Hub</p>
                </div>

                <% if (request.getParameter("msg") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show fw-bold text-center py-2 mb-3" role="alert">
                        <i class="bi bi-check-circle-fill me-1"></i> <%= request.getParameter("msg") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                
                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show fw-bold text-center py-2 mb-3" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i> <%= request.getParameter("error") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                
                <form action="RegisterDonorServlet" method="POST">

                    <!-- Full Name (FULLY EDITABLE NOW - NO READONLY) -->
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Full Name</label>
                        <input type="text" name="fullName" class="form-control" value="<%= patient.getFullName() %>" placeholder="Type Donor Full Name" required>
                    </div>

                    <!-- Blood Group -->
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Blood Group</label>
                        <select name="bloodGroup" class="form-select" required>
                            <option value="" disabled selected>-- Select Blood Group --</option>
                            <option value="A+">A+</option>
                            <option value="A-">A-</option>
                            <option value="B+">B+</option>
                            <option value="B-">B-</option>
                            <option value="O+">O+</option>
                            <option value="O-">O-</option>
                            <option value="AB+">AB+</option>
                            <option value="AB-">AB-</option>
                        </select>
                    </div>

                    <!-- City / Location -->
                    <div class="mb-3">
                        <label class="form-label fw-bold small">City / Location</label>
                        <input type="text" name="city" class="form-control" placeholder="e.g. Vijayawada" required>
                    </div>

                    <!-- Phone Number -->
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Emergency Contact Phone</label>
                        <input type="text" name="phone" class="form-control" value="<%= patient.getPhone() != null ? patient.getPhone() : "" %>" placeholder="10-digit mobile number" required>
                    </div>

                    <button type="submit" class="btn btn-danger w-100 fw-bold py-2 mb-2">
                        <i class="bi bi-heart-fill me-1"></i> Submit Donor Details
                    </button>
                    <a href="patientDashboard.jsp" class="btn btn-outline-secondary w-100 fw-bold">Back to Dashboard</a>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>