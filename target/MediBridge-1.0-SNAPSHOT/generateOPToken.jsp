<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.medibridge.util.DBConnection"%>
<%@page import="com.medibridge.model.Patient"%>
<%
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String msg = null;
    String error = null;

    // Direct Form Processing in JSP
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        
        String patientName = request.getParameter("patientName");
        String ageStr = request.getParameter("age");
        String gender = request.getParameter("gender");
        String doctorIdStr = request.getParameter("doctorId");
        String symptoms = request.getParameter("symptoms");

        if (patientName != null && ageStr != null && doctorIdStr != null) {
            int doctorId = Integer.parseInt(doctorIdStr);
            int age = Integer.parseInt(ageStr);

            try (Connection con = DBConnection.getConnection()) {
                if (con != null) {
                    // Calculate Next Token Number
                    int nextTokenNo = 1;
                    String countSql = "SELECT COUNT(*) FROM op_tokens WHERE DATE(created_at) = CURDATE()";
                    try (PreparedStatement psCount = con.prepareStatement(countSql);
                         ResultSet rs = psCount.executeQuery()) {
                        if (rs.next()) {
                            nextTokenNo = rs.getInt(1) + 1;
                        }
                    }

                    String tokenNumber = "OP-" + nextTokenNo;

                    // Insert OP Token
                    String insertSql = "INSERT INTO op_tokens (patient_id, doctor_id, patient_name, age, gender, symptoms, token_number, status) VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')";
                    try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                        ps.setInt(1, patient.getPatientId());
                        ps.setInt(2, doctorId);
                        ps.setString(3, patientName.trim());
                        ps.setInt(4, age);
                        ps.setString(5, gender);
                        ps.setString(6, symptoms.trim());
                        ps.setString(7, tokenNumber);

                        int rows = ps.executeUpdate();
                        if (rows > 0) {
                            msg = "OP Token Generated Successfully! Token No: " + tokenNumber;
                        } else {
                            error = "Failed to generate token. Try again!";
                        }
                    }
                }
            } catch (Exception e) {
                error = "Database Error: " + e.getMessage();
            }
        } else {
            error = "Please fill all required fields!";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Generate OP Token - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card p-4 shadow-sm border-0 rounded-4">
                <div class="text-center mb-3">
                    <span class="display-5 text-primary"><i class="bi bi-ticket-detailed-fill"></i></span>
                    <h3 class="fw-bold text-primary mt-2">Generate OP Token</h3>
                    <p class="text-muted small">Book an Outpatient token for hospital consultation</p>
                </div>

                <% if (msg != null) { %>
                    <div class="alert alert-success alert-dismissible fade show fw-bold text-center py-2 mb-3" role="alert">
                        <i class="bi bi-check-circle-fill me-1"></i> <%= msg %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                
                <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show fw-bold text-center py-2 mb-3" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- Form posts back to generateOPToken.jsp directly -->
                <form action="generateOPToken.jsp" method="POST">
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Patient Full Name</label>
                        <input type="text" name="patientName" class="form-control" value="<%= patient.getFullName() %>" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold small">Age</label>
                            <input type="number" name="age" class="form-control" placeholder="e.g. 25" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold small">Gender</label>
                            <select name="gender" class="form-select" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                    </div>

                    <!-- Specialization / Department Dropdown -->
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Select Specialist / Department</label>
                        <select name="doctorId" class="form-select" required>
                            <option value="" disabled selected>-- Select Specialization --</option>
                            <option value="1">Gynecologist</option>
                            <option value="2">Dermatologist</option>
                            <option value="3">Psychiatrist</option>
                            <option value="4">General Physician</option>
                            <option value="5">Cardiologist</option>
                            <option value="6">Pediatrician</option>
                            <option value="7">Orthopedic Surgeon</option>
                            <option value="8">ENT Specialist</option>
                            <option value="9">Neurologist</option>
                            <option value="10">Dentist</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small">Symptoms / Reason for Visit</label>
                        <textarea name="symptoms" class="form-control" rows="2" placeholder="e.g. Skin rash, Fever, Headache" required></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 fw-bold py-2 mb-2">
                        <i class="bi bi-plus-circle me-1"></i> Generate OP Token
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