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
    <title>Today's Patient Visits - MediBridge</title>
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
                <i class="bi bi-laptop me-2"></i>Online Consultations & Today's Visits
            </h3>
            <p class="text-muted small mb-0">Scheduled appointments booked online by patients</p>
        </div>
        <a href="doctorDashboard.jsp" class="btn btn-outline-secondary fw-bold">
            <i class="bi bi-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <!-- Online Bookings Table -->
    <div class="card p-4 shadow-sm border-0 rounded-4">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-success">
                    <tr>
                        <th>Token No</th>
                        <th>Patient Name</th>
                        <th>Age / Gender</th>
                        <th>Symptoms</th>
                        <th>Booking Mode</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    boolean hasVisits = false;
                    try (Connection con = DBConnection.getConnection()) {
                        if (con != null) {
                            // Fetch ONLINE booked tokens only
                            String sql = "SELECT * FROM op_tokens WHERE (booking_type = 'ONLINE' OR booking_type IS NULL) ORDER BY token_id DESC";
                            try (PreparedStatement ps = con.prepareStatement(sql);
                                 ResultSet rs = ps.executeQuery()) {
                                while (rs.next()) {
                                    hasVisits = true;
                %>
                                    <tr>
                                        <td class="fw-bold text-primary"><%= rs.getString("token_number") %></td>
                                        <td class="fw-bold"><%= rs.getString("patient_name") %></td>
                                        <td><%= rs.getInt("age") %> Yrs / <%= rs.getString("gender") %></td>
                                        <td><%= rs.getString("symptoms") %></td>
                                        <td><span class="badge bg-info text-dark"><i class="bi bi-globe me-1"></i>Online</span></td>
                                        <td><span class="badge bg-warning text-dark"><%= rs.getString("status") %></span></td>
                                        <td>
                                            <a href="addPrescription.jsp?patientId=<%= rs.getInt("patient_id") %>&tokenId=<%= rs.getInt("token_id") %>" class="btn btn-sm btn-success fw-bold">
                                                <i class="bi bi-file-earmark-medical me-1"></i> Write Prescription
                                            </a>
                                        </td>
                                    </tr>
                <%
                                }
                            }
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7' class='text-danger fw-bold'>Error: " + e.getMessage() + "</td></tr>");
                    }

                    if (!hasVisits) {
                %>
                        <tr>
                            <td colspan="7" class="text-center text-muted fw-bold py-5">
                                <i class="bi bi-inbox display-5 d-block mb-2 text-secondary"></i>
                                No online scheduled visits recorded for today.
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