<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.medibridge.util.DBConnection"%>
<!DOCTYPE html>
<html>
<head>
    <title>Search Blood Donors - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-9">
            
            <!-- Search Filter Form -->
            <div class="card p-4 shadow-sm border-0 rounded-4 mb-4">
                <h3 class="fw-bold text-danger mb-3"><i class="bi bi-search me-2"></i>Find Blood Donors</h3>
                
                <form action="searchDonor.jsp" method="GET" class="row g-3">
                    <div class="col-md-5">
                        <label class="form-label fw-bold small">Blood Group</label>
                        <select name="bloodGroup" class="form-select">
                            <option value="ALL">All Blood Groups</option>
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
                    <div class="col-md-5">
                        <label class="form-label fw-bold small">City / Location</label>
                        <input type="text" name="city" class="form-control" placeholder="e.g. Vijayawada" value="<%= request.getParameter("city") != null ? request.getParameter("city") : "" %>">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-danger w-100 fw-bold py-2">
                            <i class="bi bi-search"></i> Search
                        </button>
                    </div>
                </form>
            </div>

            <!-- Direct DB Search Results -->
            <div class="card p-4 shadow-sm border-0 rounded-4">
                <h5 class="fw-bold mb-3">Available Blood Donors</h5>
                
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-danger">
                            <tr>
                                <th>Donor Name</th>
                                <th>Blood Group</th>
                                <th>City</th>
                                <th>Contact Phone</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            String bloodGroup = request.getParameter("bloodGroup");
                            String city = request.getParameter("city");

                            try (Connection con = DBConnection.getConnection()) {
                                if (con != null) {
                                    StringBuilder sql = new StringBuilder("SELECT * FROM blood_donors WHERE 1=1");

                                    if (bloodGroup != null && !bloodGroup.trim().isEmpty() && !bloodGroup.equalsIgnoreCase("ALL")) {
                                        sql.append(" AND blood_group = ?");
                                    }
                                    if (city != null && !city.trim().isEmpty()) {
                                        sql.append(" AND LOWER(city) LIKE LOWER(?)");
                                    }

                                    try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
                                        int paramIndex = 1;

                                        if (bloodGroup != null && !bloodGroup.trim().isEmpty() && !bloodGroup.equalsIgnoreCase("ALL")) {
                                            ps.setString(paramIndex++, bloodGroup.trim());
                                        }
                                        if (city != null && !city.trim().isEmpty()) {
                                            ps.setString(paramIndex++, "%" + city.trim() + "%");
                                        }

                                        try (ResultSet rs = ps.executeQuery()) {
                                            boolean hasDonors = false;
                                            while (rs.next()) {
                                                hasDonors = true;
                                %>
                                                <tr>
                                                    <td class="fw-bold"><%= rs.getString("full_name") %></td>
                                                    <td><span class="badge bg-danger"><%= rs.getString("blood_group") %></span></td>
                                                    <td><%= rs.getString("city") %></td>
                                                    <td>
                                                        <a href="tel:<%= rs.getString("phone") %>" class="btn btn-sm btn-outline-success fw-bold">
                                                            <i class="bi bi-telephone-fill me-1"></i> <%= rs.getString("phone") %>
                                                        </a>
                                                    </td>
                                                </tr>
                                <%
                                            }
                                            if (!hasDonors) {
                                %>
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted fw-bold py-3">No donors found matching your criteria.</td>
                                                </tr>
                                <%
                                            }
                                        }
                                    }
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='4' class='text-danger'>Error loading donors: " + e.getMessage() + "</td></tr>");
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="text-center mt-3">
                <a href="patientDashboard.jsp" class="btn btn-link text-secondary fw-bold text-decoration-none">Back to Dashboard</a>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>