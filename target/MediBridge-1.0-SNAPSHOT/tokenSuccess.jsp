<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.medibridge.model.Patient"%>
<%
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String dept = request.getParameter("dept");
    String tokenNo = request.getParameter("tokenNo");
%>
<!DOCTYPE html>
<html>
<head>
    <title>OP Token Details - MediBridge</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card p-4 shadow-sm border-0 text-center rounded-4">
                <div class="text-success fs-1 mb-2">🎉</div>
                <h4 class="fw-bold text-success mb-3">OP Token Generated!</h4>
                
                <div class="bg-primary text-white rounded-3 p-3 my-3">
                    <small class="text-uppercase fw-bold text-white-50">Token Number</small>
                    <h1 class="display-3 fw-bold my-1">#<%= tokenNo != null ? tokenNo : "1" %></h1>
                    <div class="badge bg-warning text-dark fs-6 mt-1"><%= dept != null ? dept : "General Medicine" %></div>
                </div>

                <div class="text-start bg-light p-3 rounded-3 border mb-3 small">
                    <p class="mb-1"><strong>Patient Name:</strong> <%= patient.getFullName() %></p>
                    <p class="mb-0"><strong>Status:</strong> <span class="text-success fw-bold">Active in Queue</span></p>
                </div>

                <button onclick="window.print()" class="btn btn-outline-primary w-100 fw-bold mb-2">🖨️ Print Token</button>
                <a href="patientDashboard.jsp" class="btn btn-primary w-100 fw-bold">Back to Dashboard</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>