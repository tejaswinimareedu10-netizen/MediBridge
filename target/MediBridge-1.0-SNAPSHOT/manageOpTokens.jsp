<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.medibridge.util.DBConnection"%>
<%@page import="com.medibridge.model.Doctor"%>

<%
    Doctor doctor = (Doctor) session.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }

    String msg = null;

    // Direct Hospital Counter Walk-In Token Generation
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String patientName = request.getParameter("walkinName");
        String ageStr = request.getParameter("walkinAge");
        String gender = request.getParameter("walkinGender");
        String symptoms = request.getParameter("walkinSymptoms");

        if (patientName != null && ageStr != null) {
            try (Connection con = DBConnection.getConnection()) {
                if (con != null) {
                    int nextTokenNo = 1;
                    String countSql = "SELECT COUNT(*) FROM op_tokens WHERE booking_type = 'WALK_IN' AND DATE(created_at) = CURDATE()";
                    try (PreparedStatement psCount = con.prepareStatement(countSql);
                         ResultSet rs = psCount.executeQuery()) {
                        if (rs.next()) {
                            nextTokenNo = rs.getInt(1) + 1;
                        }
                    }

                    String tokenNumber = "W-OP-" + nextTokenNo;

                    String insertSql = "INSERT INTO op_tokens (patient_id, doctor_id, patient_name, age, gender, symptoms, token_number, status, booking_type) VALUES (0, ?, ?, ?, ?, ?, ?, 'WAITING', 'WALK_IN')";
                    try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                        ps.setInt(1, doctor.getDoctorId());
                        ps.setString(2, patientName.trim());
                        ps.setInt(3, Integer.parseInt(ageStr));
                        ps.setString(4, gender);
                        ps.setString(5, symptoms.trim());
                        ps.setString(6, tokenNumber);

                        ps.executeUpdate();
                        msg = "Walk-in Counter Token Issued: " + tokenNumber;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // Handle Status Updates
    String action = request.getParameter("action");
    String tokenIdStr = request.getParameter("tokenId");

    if ("complete".equalsIgnoreCase(action) && tokenIdStr != null) {
        try (Connection con = DBConnection.getConnection()) {
            if (con != null) {
                String updateSql = "UPDATE op_tokens SET status = 'COMPLETED' WHERE token_id = ?";
                try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                    ps.setInt(1, Integer.parseInt(tokenIdStr));
                    ps.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>OP Queue Desk - MediBridge</title>
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
            <h3 class="fw-bold text-success mb-0">
                <i class="bi bi-building me-2"></i>Physical Walk-In OP Queue Desk
            </h3>
            <p class="text-muted small mb-0">Live reception counter tokens for on-spot hospital patients</p>
        </div>
        <a href="doctorDashboard.jsp" class="btn btn-outline-secondary fw-bold">
            <i class="bi bi-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <% if (msg != null) { %>
        <div class="alert alert-success alert-dismissible fade show fw-bold text-center py-2 mb-3" role="alert">
            <i class="bi bi-check-circle-fill me-1"></i> <%= msg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- Counter Walk-In Token Generator Form -->
    <div class="card p-3 shadow-sm border-0 rounded-4 mb-4 bg-white">
        <h6 class="fw-bold text-success mb-2"><i class="bi bi-ticket-perforated me-1"></i> Issue Spot Reception Counter Token</h6>
        <form action="manageOpTokens.jsp" method="POST" class="row g-2 align-items-center">
            <div class="col-md-3">
                <input type="text" name="walkinName" class="form-control form-control-sm" placeholder="Patient Name" required>
            </div>
            <div class="col-md-2">
                <input type="number" name="walkinAge" class="form-control form-control-sm" placeholder="Age" required>
            </div>
            <div class="col-md-2">
                <select name="walkinGender" class="form-select form-select-sm">
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                </select>
            </div>
            <div class="col-md-3">
                <input type="text" name="walkinSymptoms" class="form-control form-control-sm" placeholder="Symptoms / Checkup" required>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-sm btn-success w-100 fw-bold">
                    <i class="bi bi-plus-lg"></i> Issue Token
                </button>
            </div>
        </form>
    </div>

    <!-- Live Physical Queue Table -->
    <div class="card p-4 shadow-sm border-0 rounded-4">
        <h5 class="fw-bold mb-3 text-secondary">Physical Reception Waiting Line</h5>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-success">
                    <tr>
                        <th>Token No</th>
                        <th>Patient Name</th>
                        <th>Age / Gender</th>
                        <th>Symptoms</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    boolean hasTokens = false;
                    try (Connection con = DBConnection.getConnection()) {
                        if (con != null) {
                            String sql = "SELECT * FROM op_tokens WHERE booking_type = 'WALK_IN' ORDER BY token_id DESC";
                            try (PreparedStatement ps = con.prepareStatement(sql);
                                 ResultSet rs = ps.executeQuery()) {
                                while (rs.next()) {
                                    hasTokens = true;
                                    String status = rs.getString("status");
                                    String badgeClass = "COMPLETED".equalsIgnoreCase(status) ? "bg-success" : "bg-warning text-dark";
                %>
                                    <tr>
                                        <td class="fw-bold text-success fs-5"><%= rs.getString("token_number") %></td>
                                        <td class="fw-bold text-dark"><%= rs.getString("patient_name") %></td>
                                        <td><%= rs.getInt("age") %> Yrs / <%= rs.getString("gender") %></td>
                                        <td><%= rs.getString("symptoms") %></td>
                                        <td><span class="badge <%= badgeClass %> px-3 py-2"><%= status %></span></td>
                                        <td>
                                            <% if (!"COMPLETED".equalsIgnoreCase(status)) { %>
                                                <a href="manageOpTokens.jsp?action=complete&tokenId=<%= rs.getInt("token_id") %>" class="btn btn-sm btn-outline-success fw-bold me-1">
                                                    <i class="bi bi-check-circle-fill me-1"></i> Complete Visit
                                                </a>
                                            <% } else { %>
                                                <span class="text-muted small fw-bold"><i class="bi bi-check-all text-success fs-5"></i> Completed</span>
                                            <% } %>
                                        </td>
                                    </tr>
                <%
                                }
                            }
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6' class='text-danger fw-bold'>Error loading queue: " + e.getMessage() + "</td></tr>");
                    }

                    if (!hasTokens) {
                %>
                        <tr>
                            <td colspan="6" class="text-center text-muted fw-bold py-4">
                                <i class="bi bi-inbox display-6 d-block mb-2 text-secondary"></i>
                                No active walk-in counter tokens in physical queue.
                            </td>
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