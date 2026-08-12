<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.medibridge.model.Patient"%>
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
    <title>Medicine Reminders - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-warning text-dark">⏰ Daily Medicine & Pill Reminders</h3>
        <a href="patientDashboard.jsp" class="btn btn-outline-secondary fw-bold">Back to Dashboard</a>
    </div>

    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card p-4 shadow-sm border-0 mb-4">
                <h5 class="fw-bold mb-3">Add New Pill Reminder</h5>
                <form onsubmit="alert('Reminder Scheduled Successfully!'); return false;">
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Medicine Name</label>
                        <input type="text" class="form-control" placeholder="e.g. Paracetamol 500mg" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Dosage Timing</label>
                        <select class="form-select" required>
                            <option value="Morning">Morning (After Breakfast)</option>
                            <option value="Afternoon">Afternoon (After Lunch)</option>
                            <option value="Night">Night (Before Bed)</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-warning text-dark fw-bold w-100">Set Alarm</button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>