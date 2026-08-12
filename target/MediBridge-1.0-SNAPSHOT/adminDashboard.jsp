<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.medibridge.util.DBConnection"%>
<%@page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Portal - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="adminDashboard.jsp">⚙️ MediBridge Admin Portal</a>
        <a href="LogoutServlet" class="btn btn-outline-light btn-sm fw-bold">Logout</a>
    </div>
</nav>

<div class="container my-4">

    <!-- Fetch System Analytics safely -->
    <%
        int totalDoctors = 0;
        int pendingDoctors = 0;
        int totalAppointments = 0;

        try (Connection conStats = DBConnection.getConnection()) {
            if (conStats != null) {
                // Total Doctors
                try (Statement stmt1 = conStats.createStatement();
                     ResultSet rs1 = stmt1.executeQuery("SELECT COUNT(*) FROM doctor")) {
                    if (rs1.next()) totalDoctors = rs1.getInt(1);
                }

                // Pending Approvals
                try (Statement stmt2 = conStats.createStatement();
                     ResultSet rs2 = stmt2.executeQuery("SELECT COUNT(*) FROM doctor WHERE approval_status='PENDING'")) {
                    if (rs2.next()) pendingDoctors = rs2.getInt(1);
                }

                // Total Appointments
                try (Statement stmt3 = conStats.createStatement();
                     ResultSet rs3 = stmt3.executeQuery("SELECT COUNT(*) FROM appointment")) {
                    if (rs3.next()) totalAppointments = rs3.getInt(1);
                }
            }
        } catch (Exception e) {
            // Stats load avvakapoina page break avvakunda clean fallback
        }
    %>

    <!-- Analytics Cards Header -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card bg-white p-3 shadow-sm border-start border-4 border-primary">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-1">Total Registered Doctors</h6>
                        <h3 class="fw-bold mb-0 text-dark"><%= totalDoctors %></h3>
                    </div>
                    <i class="bi bi-people-fill fs-1 text-primary"></i>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card bg-white p-3 shadow-sm border-start border-4 border-warning">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-1">Pending Doctor Approvals</h6>
                        <h3 class="fw-bold mb-0 text-warning"><%= pendingDoctors %></h3>
                    </div>
                    <i class="bi bi-clock-history fs-1 text-warning"></i>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card bg-white p-3 shadow-sm border-start border-4 border-success">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-1">Total Appointments</h6>
                        <h3 class="fw-bold mb-0 text-success"><%= totalAppointments %></h3>
                    </div>
                    <i class="bi bi-calendar-check-fill fs-1 text-success"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Doctor Approvals & Management Table -->
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-header bg-white py-3">
            <h5 class="fw-bold text-dark mb-0">
                <i class="bi bi-person-check me-2 text-primary"></i>Doctor Accounts & Approvals
            </h5>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Doctor Name</th>
                        <th>Email</th>
                        <th>Specialization</th>
                        <th>Status</th>
                        <th class="text-center">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection conTable = DBConnection.getConnection()) {
                            if (conTable != null) {
                                String sql = "SELECT * FROM doctor ORDER BY doctor_id DESC";
                                try (PreparedStatement ps = conTable.prepareStatement(sql);
                                     ResultSet rs = ps.executeQuery()) {

                                    boolean found = false;

                                    while (rs.next()) {
                                        found = true;
                                        int docId = rs.getInt("doctor_id");
                                        String name = rs.getString("full_name");
                                        String email = rs.getString("email");
                                        String spec = rs.getString("specialization");
                                        String status = "PENDING";
                                        
                                        try { 
                                            if (rs.getString("approval_status") != null) {
                                                status = rs.getString("approval_status"); 
                                            }
                                        } catch (Exception ignored) {}
                    %>
                    <tr>
                        <td><strong>#<%= docId %></strong></td>
                        <td>👨‍⚕️ Dr. <%= name %></td>
                        <td><%= email %></td>
                        <td><%= spec %></td>
                        <td>
                            <% if ("APPROVED".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-success">APPROVED</span>
                            <% } else { %>
                                <span class="badge bg-warning text-dark">PENDING</span>
                            <% } %>
                        </td>
                        <td class="text-center">
                            <% if (!"APPROVED".equalsIgnoreCase(status)) { %>
                                <a href="ApproveDoctorServlet?doctorId=<%= docId %>&action=APPROVE" class="btn btn-sm btn-success fw-bold">
                                    <i class="bi bi-check-lg me-1"></i> Approve Doctor
                                </a>
                            <% } else { %>
                                <span class="text-muted small"><i class="bi bi-shield-check text-success"></i> Verified</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                                    }
                                    if (!found) {
                    %>
                    <tr>
                        <td colspan="6" class="text-center py-4 text-muted">No doctor registrations found.</td>
                    </tr>
                    <%
                                    }
                                }
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6' class='text-danger p-3'>Error: " + e.getMessage() + "</td></tr>");
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