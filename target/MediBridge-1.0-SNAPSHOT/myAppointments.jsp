<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.medibridge.model.Patient" %>
<%@ page import="com.medibridge.dao.AppointmentDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    AppointmentDAO dao = new AppointmentDAO();
    List<Map<String, String>> appointments = dao.getAppointmentsByPatient(patient.getPatientId());
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Appointments - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-primary fw-bold">📅 My Scheduled Appointments</h2>
        <a href="portal.jsp" class="btn btn-secondary">Back to Portal</a>
    </div>

    <% if (appointments.isEmpty()) { %>
        <div class="alert alert-warning text-center p-4">
            <p class="mb-0 text-muted fs-5">You haven't booked any medical consultations yet.</p>
        </div>
    <% } else { %>
        <div class="card shadow-sm">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>Doctor Name</th>
                        <th>Specialization</th>
                        <th>Date</th>
                        <th>Time Slot</th>
                        <th>Status</th>
                        <th class="text-center">Medical Records</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, String> appt : appointments) { 
                        String badgeClass = "bg-warning text-dark";
                        if ("Approved".equalsIgnoreCase(appt.get("status"))) badgeClass = "bg-success";
                        if ("Rejected".equalsIgnoreCase(appt.get("status"))) badgeClass = "bg-danger";
                    %>
                        <tr>
                            <td><strong>Dr. <%= appt.get("doctorName") %></strong></td>
                            <td><span class="text-muted"><%= appt.get("specialization") %></span></td>
                            <td><%= appt.get("date") %></td>
                            <td><%= appt.get("time") %></td>
                            <td><span class="badge <%= badgeClass %>"><%= appt.get("status") %></span></td>
                            <td class="text-center">
                                <% if ("Approved".equalsIgnoreCase(appt.get("status"))) { %>
                                    <a href="viewPrescription.jsp?appointmentId=<%= appt.get("apptId") %>" class="btn btn-sm btn-outline-primary fw-bold">
                                        👁️ View Prescription
                                    </a>
                                <% } else { %>
                                    <span class="text-muted small">N/A</span>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>

</body>
</html>