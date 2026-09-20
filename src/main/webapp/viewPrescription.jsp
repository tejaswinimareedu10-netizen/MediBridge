<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.medibridge.model.Patient" %>
<%@ page import="com.medibridge.util.DBConnection" %>
<%@ page import="java.sql.*" %>

<%
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String doctor = request.getParameter("doctor");
    String date = request.getParameter("date");
    String time = request.getParameter("time");

    String medicineName = "N/A";
    String dosage = "N/A";
    String instructions = "N/A";
    boolean found = false;

    try {
        Connection con = DBConnection.getConnection();
        // Match appointment by patient, date, and time, then fetch from prescription table
        String sql = "SELECT pr.medicine_name, pr.dosage, pr.instructions " +
                     "FROM prescription pr " +
                     "JOIN appointment a ON pr.appointment_id = a.id " +
                     "JOIN doctor d ON a.doctor_id = d.doctor_id " +
                     "WHERE a.patient_id = ? AND a.appointment_date = ? AND a.appointment_time = ? AND d.full_name = ?";
        
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, patient.getPatientId());
        ps.setString(2, date);
        ps.setString(3, time);
        ps.setString(4, doctor);
        
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            medicineName = rs.getString("medicine_name");
            dosage = rs.getString("dosage");
            instructions = rs.getString("instructions");
            found = true;
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Prescription - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-primary fw-bold">💊 Prescription Details</h2>
        <a href="myAppointments.jsp" class="btn btn-secondary">Back to Appointments</a>
    </div>

    <div class="card shadow-sm p-4 mb-4">
        <h5 class="text-secondary mb-3">Appointment Info</h5>
        <p><strong>Doctor:</strong> Dr. <%= doctor != null ? doctor : "N/A" %></p>
        <p><strong>Date:</strong> <%= date != null ? date : "N/A" %> | <strong>Time:</strong> <%= time != null ? time : "N/A" %></p>
    </div>

    <div class="card shadow-sm p-4">
        <h4 class="mb-3 text-success">Medical Prescription</h4>
        <% if (found) { %>
            <hr>
            <div class="mb-3">
                <label class="fw-bold text-muted">Medicine Name:</label>
                <p class="fs-5"><%= medicineName %></p>
            </div>
            <div class="mb-3">
                <label class="fw-bold text-muted">Dosage:</label>
                <p class="fs-5"><%= dosage %></p>
            </div>
            <div class="mb-3">
                <label class="fw-bold text-muted">Instructions:</label>
                <p class="fs-5"><%= instructions %></p>
            </div>
        <% } else { %>
            <div class="alert alert-info mb-0">
                No prescription has been uploaded for this appointment yet. 
            </div>
        <% } %>
    </div>
</div>

</body>
</html>