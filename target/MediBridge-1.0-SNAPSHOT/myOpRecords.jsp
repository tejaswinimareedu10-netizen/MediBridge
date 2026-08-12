<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.medibridge.model.Patient"%>
<%@page import="com.medibridge.util.DBConnection"%>
<%@page import="java.sql.*"%>
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
    <title>My OP Records - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-success">📋 My OP Records History</h3>
        <a href="patientDashboard.jsp" class="btn btn-outline-secondary fw-bold">Back to Dashboard</a>
    </div>

    <div class="card p-4 shadow-sm border-0">
        <table class="table table-hover align-middle">
            <thead class="table-success">
                <tr>
                    <th>Token No</th>
                    <th>Department</th>
                    <th>Symptoms / Reason</th>
                    <th>Generated Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Connection con = DBConnection.getConnection();
                        String sql = "SELECT * FROM op_tokens WHERE patient_id = ? ORDER BY token_id DESC";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ps.setInt(1, patient.getPatientId());
                        ResultSet rs = ps.executeQuery();
                        boolean hasRecords = false;

                        while(rs.next()) {
                            hasRecords = true;
                %>
                <tr>
                    <td><span class="badge bg-primary fs-6">#<%= rs.getInt("token_number") %></span></td>
                    <td class="fw-bold"><%= rs.getString("department") %></td>
                    <td><%= rs.getString("symptoms") %></td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                    <td><span class="badge bg-success">Active Token</span></td>
                </tr>
                <% 
                        }
                        if(!hasRecords) {
                %>
                <tr>
                    <td colspan="5" class="text-center text-muted py-4">No OP Tokens generated yet. <a href="generateOPToken.jsp">Generate Token Now</a></td>
                </tr>
                <%
                        }
                        con.close();
                    } catch(Exception e) {
                %>
                <tr>
                    <td colspan="5" class="text-center text-muted py-4">No OP records found in history.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>