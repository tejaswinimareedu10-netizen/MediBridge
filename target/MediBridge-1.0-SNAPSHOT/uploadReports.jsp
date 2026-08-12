<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.medibridge.model.Doctor"%>
<%
    Doctor doctor = (Doctor) session.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }
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
                
                <form onsubmit="alert('Report Uploaded Successfully!'); return false;">
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Select Patient</label>
                        <input type="text" class="form-control" placeholder="Patient ID or Email" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Report Type</label>
                        <select class="form-select" required>
                            <option value="Blood Test">Blood Test Report</option>
                            <option value="X-Ray / Scan">X-Ray / Scan Result</option>
                            <option value="General Clinical Report">General Clinical Report</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Attach File (PDF / Image)</label>
                        <input type="file" class="form-control" required>
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