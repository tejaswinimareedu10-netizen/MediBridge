<%@page contentType="text/html" pageEncoding="UTF-8"%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4" href="index.jsp">🏥 MediBridge Healthcare</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item"><a class="nav-link text-white fw-bold" href="index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link text-white" href="portal.jsp">Portal Gateway</a></li>
                <li class="nav-item"><a class="nav-link text-white" href="searchDonor.jsp">Blood Donors</a></li>
                <li class="nav-item"><a class="nav-link text-white" href="medicineReminder.jsp">Reminders</a></li>
                
                <% 
                    Object patient = session.getAttribute("patient");
                    Object doctor = session.getAttribute("doctor");
                    
                    if (patient != null) { 
                %>
                    <!-- Logged-in Patient Links -->
                    <li class="nav-item ms-2"><a class="nav-link fw-bold text-warning" href="patientDashboard.jsp">Dashboard</a></li>
                    <li class="nav-item ms-2"><a href="LogoutServlet" class="btn btn-danger btn-sm px-3 fw-bold">Logout</a></li>
                <% } else if (doctor != null) { %>
                    <!-- Logged-in Doctor Links -->
                    <li class="nav-item ms-2"><a class="nav-link fw-bold text-warning" href="doctorDashboard.jsp">Doctor Portal</a></li>
                    <li class="nav-item ms-2"><a href="LogoutServlet" class="btn btn-danger btn-sm px-3 fw-bold">Logout</a></li>
                <% } else { %>
                    <!-- Guest Dropdown -->
                    <li class="nav-item dropdown ms-lg-2">
                        <a class="btn btn-light text-primary fw-bold dropdown-toggle" href="#" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle me-1"></i> Login Portal
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow">
                            <li><a class="dropdown-item" href="login.jsp">Patient Login</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="doctorLogin.jsp">Doctor Login</a></li>
                        </ul>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>