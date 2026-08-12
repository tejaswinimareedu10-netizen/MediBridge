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
    <title>Add Prescription - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-7">
            <div class="card p-4 shadow-sm border-0 rounded-4">
                <h4 class="fw-bold text-warning text-dark mb-3">💊 Write Digital Prescription</h4>
                
                <form onsubmit="alert('Prescription saved successfully!'); return false;">
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Patient Name / ID</label>
                        <input type="text" class="form-control" placeholder="Enter Patient Name or ID" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Diagnosis / Symptoms</label>
                        <input type="text" class="form-control" placeholder="e.g. Mild Fever, Cold" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Prescribed Medicines & Dosage Instructions</label>
                        <textarea class="form-control" rows="4" placeholder="1. Paracetamol 500mg - 1-0-1 (3 Days)&#10;2. Cetirizine 10mg - 0-0-1 (At Night)" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-warning text-dark w-100 fw-bold py-2">Save Prescription</button>
                    <a href="doctorDashboard.jsp" class="btn btn-outline-secondary w-100 fw-bold mt-2">Back to Dashboard</a>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>