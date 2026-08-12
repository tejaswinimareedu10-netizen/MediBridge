<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.medibridge.model.Appointment"%>
<%@page import="com.medibridge.dao.DoctorAppointmentDAO"%>
<%@page import="java.util.List"%>

<%
    // Ensure doctor session exists
    Object doctorSession = session.getAttribute("doctor");
    if (doctorSession == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }

    Integer doctorId = (Integer) session.getAttribute("doctorId");
    if (doctorId == null) doctorId = 1;

    DoctorAppointmentDAO dao = new DoctorAppointmentDAO();
    List<Appointment> appointmentList = dao.getAppointmentsByDoctor(doctorId);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Doctor Appointments - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<%@include file="navbar.jsp" %>

<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold text-primary mb-1"><i class="bi bi-calendar-check me-2"></i>Patient Consultation Queue</h3>
            <p class="text-muted mb-0">Manage appointments, issue prescriptions, and set required session counts.</p>
        </div>
        <a href="doctorDashboard.jsp" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i> Dashboard</a>
    </div>

    <% String msg = request.getParameter("msg");
       if ("saved".equals(msg)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            Prescription & session plan updated successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <div class="card border-0 shadow-sm rounded-3">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-3">Appt ID</th>
                            <th>Patient Name</th>
                            <th>Date</th>
                            <th>Reason</th>
                            <th>Status</th>
                            <th class="text-center">Action / Clinical Note</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (appointmentList != null && !appointmentList.isEmpty()) {
                                for (Appointment appt : appointmentList) {
                                    String badgeClass = "bg-warning";
                                    if ("Approved".equalsIgnoreCase(appt.getStatus())) badgeClass = "bg-primary";
                                    else if ("Completed".equalsIgnoreCase(appt.getStatus())) badgeClass = "bg-success";
                                    else if ("Cancelled".equalsIgnoreCase(appt.getStatus())) badgeClass = "bg-danger";
                        %>
                        <tr>
                            <td class="ps-3 fw-bold">#<%= appt.getId() %></td>
                            <td class="fw-bold text-dark"><%= appt.getPatientName() != null ? appt.getPatientName() : "Patient #" + appt.getPatientId() %></td>
                            <td><%= appt.getAppointmentDate() %></td>
                            <td><span class="text-muted"><%= appt.getReason() != null ? appt.getReason() : "General Consultation" %></span></td>
                            <td><span class="badge <%= badgeClass %>"><%= appt.getStatus() %></span></td>
                            <td class="text-center">
                                <% if ("Pending".equalsIgnoreCase(appt.getStatus())) { %>
                                    <a href="UpdateAppointmentStatusServlet?id=<%= appt.getId() %>&status=Approved" class="btn btn-sm btn-success px-3 me-1">Approve</a>
                                    <a href="UpdateAppointmentStatusServlet?id=<%= appt.getId() %>&status=Cancelled" class="btn btn-sm btn-outline-danger">Cancel</a>
                                <% } else if ("Approved".equalsIgnoreCase(appt.getStatus()) || "Completed".equalsIgnoreCase(appt.getStatus())) { %>
                                    <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#rxModal<%= appt.getId() %>">
                                        <i class="bi bi-file-earmark-medical me-1"></i> Prescribe / Set Sessions
                                    </button>
                                <% } else { %>
                                    <span class="text-muted small">No actions</span>
                                <% } %>
                            </td>
                        </tr>

                        <!-- Prescription & Sessions Modal -->
                        <div class="modal fade" id="rxModal<%= appt.getId() %>" tabindex="-1">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content border-0 shadow">
                                    <form action="SavePrescriptionServlet" method="post">
                                        <div class="modal-header bg-primary text-white">
                                            <h5 class="modal-title fw-bold">Prescription & Plan - Appt #<%= appt.getId() %></h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <input type="hidden" name="apptId" value="<%= appt.getId() %>">
                                            
                                            <div class="mb-3">
                                                <label class="form-label fw-bold">Diagnosis / Clinical Notes</label>
                                                <textarea name="diagnosis" class="form-control" rows="2" placeholder="e.g., Acute Migraine, Stage 1 Hypertension" required><%= appt.getDiagnosis() != null ? appt.getDiagnosis() : "" %></textarea>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label fw-bold">Medicines & Dosage</label>
                                                <textarea name="prescription" class="form-control" rows="3" placeholder="e.g., Paracetamol 500mg - 1 tablet after meals" required><%= appt.getPrescription() != null ? appt.getPrescription() : "" %></textarea>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label fw-bold">Required Sessions to Clear Issue</label>
                                                <input type="number" name="sessions" class="form-control" min="1" max="20" value="1" required>
                                                <small class="text-muted">Set how many visits/sittings the patient needs.</small>
                                            </div>
                                        </div>
                                        <div class="modal-footer bg-light">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                            <button type="submit" class="btn btn-primary fw-bold">Save & Mark Completed</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="bi bi-calendar-x fs-3 d-block mb-2"></i>
                                No patient appointments currently assigned to you.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>