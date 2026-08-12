<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.medibridge.model.Patient"%>
<%@page import="com.medibridge.util.DBConnection"%>
<%@page import="java.sql.*"%>

<%
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) {
        response.sendRedirect("patientLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Book Appointment - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="patientDashboard.jsp">🏥 MediBridge Portal</a>
        <a href="patientDashboard.jsp" class="btn btn-outline-light btn-sm">Back to Dashboard</a>
    </div>
</nav>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">

            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="fw-bold mb-0 text-center"><i class="bi bi-calendar-plus me-2"></i>Book a Medical Appointment</h5>
                </div>

                <div class="card-body p-4">

                    <%-- Alert Notifications --%>
                    <%
                        String error = request.getParameter("error");
                        if ("failed".equals(error)) {
                    %>
                        <div class="alert alert-danger text-center">Failed to book appointment. Please try again.</div>
                    <%
                        }
                    %>

                    <form action="BookAppointmentServlet" method="post">

                        <!-- Patient Name (Auto-filled) -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Patient Name</label>
                            <input type="text" name="patientName" class="form-control" 
                                   value="<%= patient.getFields("full_name") != null ? patient.getFields("full_name") : "" %>" required>
                            <input type="hidden" name="patientId" value="<%= patient.getId() %>">
                        </div>

                        <!-- Select Doctor -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Select Doctor & Specialization</label>
                            <select name="doctorId" class="form-select" required>
                                <option value="" disabled selected>-- Choose Doctor --</option>
                                <%
                                    try {
                                        Connection con = DBConnection.getConnection();
                                        String sql = "SELECT * FROM doctor";
                                        Statement st = con.createStatement();
                                        ResultSet rs = st.executeQuery(sql);

                                        while (rs.next()) {
                                            int docId = rs.getInt("doctor_id");
                                            String docName = rs.getString("full_name");
                                            String spec = rs.getString("specialization");
                                %>
                                    <option value="<%= docId %>">Dr. <%= docName %> (<%= spec %>)</option>
                                <%
                                        }
                                        con.close();
                                    } catch (Exception e) {
                                        out.println("<option disabled>Error loading doctors</option>");
                                    }
                                %>
                            </select>
                        </div>

                        <!-- Preferred Date -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Appointment Date</label>
                            <input type="date" name="appointmentDate" class="form-control" required>
                        </div>

                        <!-- Reason / Symptoms -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Symptoms / Reason for Visit</label>
                            <textarea name="reason" class="form-control" rows="3" placeholder="Briefly describe your health issue..." required></textarea>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow-sm">
                            Submit Booking Request
                        </button>

                    </form>

                </div>
            </div>

        </div>
    </div>
</div>

</body>
</html>