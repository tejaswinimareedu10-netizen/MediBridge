<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.medibridge.model.Doctor" %>
<%
    Doctor doctor = (Doctor) session.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Upload Lab Reports - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card p-4 shadow-sm border-0 rounded-4">
                <h4 class="fw-bold text-secondary mb-3">📤 Upload Diagnostic / Lab Reports</h4>
                
                <% if (msg != null && !msg.isEmpty()) { %>
                    <div class="alert alert-success"><%= msg %></div>
                <% } %>
                
                <% if (error != null && !error.isEmpty()) { %>
                    <div class="alert alert-danger"><%= error %></div>
                <% } %>

                <!-- FORM ACTION MUST POINT TO THE SERVLET -->
                <form action="UploadReportServlet" method="POST" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Patient ID</label>
                        <input type="number" name="patientId" class="form-control" placeholder="Enter Patient ID (e.g., 1)" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small">Report Title</label>
                        <input type="text" name="reportTitle" class="form-control" placeholder="e.g., Blood Test Report" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small">Select Report File (PDF/Image)</label>
                        <input type="file" name="reportFile" class="form-control" required>
                    </div>

                    <button type="submit" class="btn btn-secondary w-100 fw-bold py-2">Upload Report File</button>
                    <a href="doctorDashboard.jsp" class="btn btn-outline-secondary w-100 fw-bold mt-2">Back to Dashboard</a>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>