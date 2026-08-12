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
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Directory - MediBridge</title>
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
            <h3 class="fw-bold text-primary mb-0">
                <i class="bi bi-people-fill me-2"></i>Registered Patient Directory
            </h3>
            <p class="text-muted small mb-0">Search registered patients and view clinical history logs</p>
        </div>
        <a href="doctorDashboard.jsp" class="btn btn-outline-secondary fw-bold">
            <i class="bi bi-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <!-- Patients List Table -->
    <div class="card p-4 shadow-sm border-0 rounded-4">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-primary">
                    <tr>
                        <th>Patient ID / Token</th>
                        <th>Full Name</th>
                        <th>Age / Gender</th>
                        <th>Symptoms / Category</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    boolean hasPatients = false;
                    try (Connection con = DBConnection.getConnection()) {
                        if (con != null) {
                            // First priority: Try fetching from patients table
                            boolean mainTableFound = false;
                            try {
                                String sql = "SELECT * FROM patients ORDER BY 1 DESC";
                                try (PreparedStatement ps = con.prepareStatement(sql);
                                     ResultSet rs = ps.executeQuery()) {
                                    while (rs.next()) {
                                        mainTableFound = true;
                                        hasPatients = true;
                                        int pid = rs.getInt(1);
                                        String name = rs.getString("full_name");
                                        String email = rs.getString("email");
                                        String phone = "N/A";
                                        try { phone = rs.getString("phone"); } catch(Exception e){}
                %>
                                        <tr>
                                            <td class="fw-bold text-primary">#P-100<%= pid %></td>
                                            <td class="fw-bold text-dark"><%= name %></td>
                                            <td><%= email %></td>
                                            <td><%= phone %></td>
                                            <td><span class="badge bg-success">REGISTERED</span></td>
                                            <td>
                                                <a href="patientHistory.jsp?patientId=<%= pid %>" class="btn btn-sm btn-outline-primary fw-bold">
                                                    <i class="bi bi-clock-history me-1"></i> Medical History
                                                </a>
                                            </td>
                                        </tr>
                <%
                                    }
                                }
                            } catch (Exception e) {
                                // Ignore if patients table has missing columns
                            }

                            // Fallback: Fetch unique OP tokens patients (e.g. Bhargavi and others)
                            if (!mainTableFound || !hasPatients) {
                                String sqlTokens = "SELECT DISTINCT patient_name, age, gender, symptoms, token_number, patient_id FROM op_tokens ORDER BY token_id DESC";
                                try (PreparedStatement psTokens = con.prepareStatement(sqlTokens);
                                     ResultSet rsT = psTokens.executeQuery()) {
                                    while (rsT.next()) {
                                        hasPatients = true;
                                        int pId = rsT.getInt("patient_id");
                %>
                                        <tr>
                                            <td class="fw-bold text-primary"><%= rsT.getString("token_number") %></td>
                                            <td class="fw-bold text-dark"><%= rsT.getString("patient_name") %></td>
                                            <td><%= rsT.getInt("age") %> Yrs / <%= rsT.getString("gender") %></td>
                                            <td><%= rsT.getString("symptoms") %></td>
                                            <td><span class="badge bg-info text-dark">OP CONSULTATION</span></td>
                                            <td>
                                                <a href="patientHistory.jsp?patientId=<%= pId %>" class="btn btn-sm btn-outline-primary fw-bold">
                                                    <i class="bi bi-clock-history me-1"></i> Medical History
                                                </a>
                                            </td>
                                        </tr>
                <%
                                    }
                                }
                            }
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6' class='text-danger fw-bold'>Error loading patients: " + e.getMessage() + "</td></tr>");
                    }

                    if (!hasPatients) {
                %>
                        <tr>
                            <td colspan="6" class="text-center text-muted fw-bold py-5">
                                <i class="bi bi-person-x display-5 d-block mb-2 text-secondary"></i>
                                No registered patients or OP consultation records found in database.
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