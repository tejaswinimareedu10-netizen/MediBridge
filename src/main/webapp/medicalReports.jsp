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
%>
<!DOCTYPE html>
<html>
<head>
    <title>Digital Prescriptions & Diagnostic Reports - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-primary mb-0">
            <i class="bi bi-file-earmark-medical me-2"></i>Digital Prescriptions & Diagnostic Reports
        </h3>
        <div>
            <!-- Button to open Upload Page -->
            <a href="uploadReport.jsp" class="btn btn-primary fw-bold me-2">
                <i class="bi bi-cloud-upload-fill me-1"></i> Upload New Report
            </a>
            <a href="patientDashboard.jsp" class="btn btn-outline-secondary fw-bold">Back to Dashboard</a>
        </div>
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

    <div class="card p-4 shadow-sm border-0 rounded-4">
        <h5 class="fw-bold mb-3">Your Uploaded Medical & Lab Reports</h5>

        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-primary">
                    <tr>
                        <th>Report Title</th>
                        <th>Uploaded Date</th>
                        <th>Actions (View / Delete)</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    boolean hasReports = false;
                    try (Connection con = DBConnection.getConnection()) {
                        if (con != null) {
                            String sql = "SELECT * FROM medical_reports WHERE patient_id = ? ORDER BY report_id DESC";
                            try (PreparedStatement ps = con.prepareStatement(sql)) {
                                ps.setInt(1, patient.getPatientId());
                                try (ResultSet rs = ps.executeQuery()) {
                                    while (rs.next()) {
                                        hasReports = true;
                                        int reportId = rs.getInt("report_id"); // Assuming primary key is report_id
                                        String fileName = rs.getString("file_name");
                %>
                                        <tr>
                                            <td class="fw-bold text-dark">
                                                <i class="bi bi-file-earmark-pdf text-danger me-2 fs-5"></i>
                                                <%= rs.getString("report_title") %>
                                            </td>
                                            <td><%= rs.getTimestamp("uploaded_at") %></td>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <!-- View Report Button -->
                                                    <a href="uploaded_reports/<%= fileName %>" target="_blank" class="btn btn-sm btn-outline-primary fw-bold">
                                                        <i class="bi bi-eye-fill me-1"></i> View
                                                    </a>
                                                    <!-- Delete Report Button -->
                                                    <a href="DeleteReportServlet?id=<%= reportId %>" class="btn btn-sm btn-outline-danger fw-bold" onclick="return confirm('Are you sure you want to delete this report?');">
                                                        <i class="bi bi-trash-fill me-1"></i> Delete
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                <%
                                    }
                                }
                            }
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='3' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                    }

                    if (!hasReports) {
                %>
                        <tr>
                            <td colspan="3" class="text-center py-5">
                                <i class="bi bi-folder-x display-4 text-muted mb-3 d-block"></i>
                                <h5 class="fw-bold text-dark mb-1">No Diagnostic Reports Uploaded Yet</h5>
                                <p class="text-muted small mb-3">Your lab reports and doctor digital prescriptions will appear here after consultation or self-upload.</p>
                                <a href="uploadReport.jsp" class="btn btn-sm btn-primary fw-bold">
                                    <i class="bi bi-plus-circle me-1"></i> Upload First Report
                                </a>
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