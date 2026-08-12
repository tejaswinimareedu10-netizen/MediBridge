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

    String patientIdStr = request.getParameter("patientId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Medical History - MediBridge</title>
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
                <i class="bi bi-file-earmark-medical-fill me-2"></i>Clinical Medical History Logs
            </h3>
            <p class="text-muted small mb-0">Previous consultations, diagnostic reports, and medical logs</p>
        </div>
        <a href="patientList.jsp" class="btn btn-outline-secondary fw-bold">
            <i class="bi bi-arrow-left me-1"></i> Patient Directory
        </a>
    </div>

    <!-- Past Visits & OP Records Card -->
    <div class="card p-4 shadow-sm border-0 rounded-4 mb-4">
        <h5 class="fw-bold text-dark mb-3"><i class="bi bi-journal-text me-2 text-primary"></i>Past Consultation Records</h5>
        
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-primary">
                    <tr>
                        <th>Visit Date</th>
                        <th>Patient Name</th>
                        <th>Token No</th>
                        <th>Symptoms Reported</th>
                        <th>Visit Status</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    boolean hasLogs = false;
                    try (Connection con = DBConnection.getConnection()) {
                        if (con != null) {
                            String sql = "SELECT * FROM op_tokens";
                            if (patientIdStr != null && !patientIdStr.trim().isEmpty()) {
                                sql += " WHERE patient_id = " + Integer.parseInt(patientIdStr);
                            }
                            sql += " ORDER BY token_id DESC";

                            try (PreparedStatement ps = con.prepareStatement(sql);
                                 ResultSet rs = ps.executeQuery()) {
                                while (rs.next()) {
                                    hasLogs = true;
                %>
                                    <tr>
                                        <td><%= rs.getTimestamp("created_at") %></td>
                                        <td class="fw-bold"><%= rs.getString("patient_name") %></td>
                                        <td><span class="badge bg-secondary"><%= rs.getString("token_number") %></span></td>
                                        <td><%= rs.getString("symptoms") %></td>
                                        <td><span class="badge bg-success"><%= rs.getString("status") %></span></td>
                                    </tr>
                <%
                                }
                            }
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='5' class='text-danger fw-bold'>Error loading history: " + e.getMessage() + "</td></tr>");
                    }

                    if (!hasLogs) {
                %>
                        <tr>
                            <td colspan="5" class="text-center text-muted fw-bold py-4">
                                No past clinical visit history logs recorded for this patient.
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