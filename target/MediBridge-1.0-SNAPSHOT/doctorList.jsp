<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.medibridge.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <title>Find Doctors - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-light">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="index.jsp">🏥 MediBridge</a>
        <a href="portal.jsp" class="btn btn-sm btn-outline-light">Back to Portal</a>
    </div>
</nav>

<div class="container mt-5 mb-5">
    <div class="text-center mb-4">
        <h2 class="text-primary fw-bold">🔎 Find a Medical Specialist</h2>
        <p class="text-muted">Search by doctor's name or filter by clinical specialization.</p>
    </div>

    <%
        // Retrieve search parameters from the request query string
        String searchName = request.getParameter("searchName");
        String filterSpecialty = request.getParameter("filterSpecialty");

        if (searchName == null) searchName = "";
        if (filterSpecialty == null) filterSpecialty = "";

        // Build a dynamic SQL query based on filters provided
        String sql = "SELECT * FROM doctor WHERE 1=1";
        if (!searchName.trim().isEmpty()) {
            sql += " AND full_name LIKE ?";
        }
        if (!filterSpecialty.trim().isEmpty()) {
            sql += " AND specialization = ?";
        }
        sql += " ORDER BY full_name ASC";
    %>

    <!-- SEARCH & FILTER FORM BAR -->
    <div class="card p-4 shadow-sm mb-4 bg-white border-0">
        <form method="GET" action="doctorList.jsp" class="row g-3">
            <!-- Name Search Input -->
            <div class="col-md-5">
                <label class="form-label fw-semibold text-secondary">Search by Name</label>
                <div class="input-group">
                    <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                    <input type="text" name="searchName" class="form-control" placeholder="Type doctor name..." value="<%= searchName %>">
                </div>
            </div>

            <!-- Specialization Dropdown -->
            <div class="col-md-4">
                <label class="form-label fw-semibold text-secondary">Filter by Specialty</label>
                <select name="filterSpecialty" class="form-select">
                    <option value="">-- All Specializations --</option>
                    <option value="Cardiology" <%= "Cardiology".equals(filterSpecialty) ? "selected" : "" %>>Cardiology</option>
                    <option value="Pediatrics" <%= "Pediatrics".equals(filterSpecialty) ? "selected" : "" %>>Pediatrics</option>
                    <option value="Dermatology" <%= "Dermatology".equals(filterSpecialty) ? "selected" : "" %>>Dermatology</option>
                    <option value="General Medicine" <%= "General Medicine".equals(filterSpecialty) ? "selected" : "" %>>General Medicine</option>
                    <option value="Neurology" <%= "Neurology".equals(filterSpecialty) ? "selected" : "" %>>Neurology</option>
                </select>
            </div>

            <!-- Action Buttons -->
            <div class="col-md-3 d-flex align-items-end gap-2">
                <button type="submit" class="btn btn-primary w-100 fw-bold">Filter</button>
                <a href="doctorList.jsp" class="btn btn-outline-secondary w-100">Reset</a>
            </div>
        </form>
    </div>

    <!-- DISPLAY TARGET RESULTS GRID -->
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <%
            try {
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                
                int paramIndex = 1;
                if (!searchName.trim().isEmpty()) {
                    ps.setString(paramIndex++, "%" + searchName + "%");
                }
                if (!filterSpecialty.trim().isEmpty()) {
                    ps.setString(paramIndex++, filterSpecialty);
                }

                ResultSet rs = ps.executeQuery();
                boolean hasData = false;

                while (rs.next()) {
                    hasData = true;
                    int docId = rs.getInt("doctor_id");
                    String name = rs.getString("full_name");
                    String specialty = rs.getString("specialization");
                    String phone = rs.getString("phone");
        %>
            <div class="col">
                <div class="card h-100 shadow-sm border-0 border-top border-primary border-3">
                    <div class="card-body p-4 text-center">
                        <div class="mb-3">
                            <i class="bi bi-person-bounding-box text-primary display-5"></i>
                        </div>
                        <h4 class="card-title fw-bold text-dark mb-1">Dr. <%= name %></h4>
                        <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-semibold mb-3">
                            <%= specialty %>
                        </span>
                        <p class="text-muted small mb-4">
                            <i class="bi bi-telephone-fill me-1"></i> Contact: <%= phone %>
                        </p>
                        <!-- Routes direct token identifier context forward to your booking script -->
                        <a href="bookAppointment.jsp?doctorId=<%= docId %>" class="btn btn-primary w-100 fw-bold">
                            📅 Schedule Consultation
                        </a>
                    </div>
                </div>
            </div>
        <%
                }
                if (!hasData) {
        %>
            <div class="col-12 w-100 text-center py-5">
                <div class="alert alert-secondary p-4">
                    <i class="bi bi-exclamation-circle text-muted display-6 d-block mb-2"></i>
                    <h4>No Matching Doctors Found</h4>
                    <p class="text-muted mb-0">Try adjusting your search criteria or resetting the filters.</p>
                </div>
            </div>
        <%
                }
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
        %>
            <div class="alert alert-danger w-100 text-center">
                An internal compilation database loading error occurred. Please verify your SQL column mappings.
            </div>
        <%
            }
        %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>