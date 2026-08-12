package com.medibridge.controller;

import com.medibridge.dao.AppointmentDAO;
import com.medibridge.model.Doctor;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DoctorActionServlet")
public class DoctorActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Security Check: Ensure a Doctor session exists
        HttpSession session = request.getSession(false);
        Doctor doctor = (session != null) ? (Doctor) session.getAttribute("doctor") : null;

        if (doctor == null) {
            // Block unauthorized access (patients or guests trying to call this link)
            response.sendRedirect("doctorLogin.jsp?error=unauthorized");
            return;
        }

        try {
            // 2. Parse appointment action parameters
            int apptId = Integer.parseInt(request.getParameter("apptId"));
            String action = request.getParameter("status"); // Expected: Approved or Rejected
            
            // 3. Update database status
            AppointmentDAO dao = new AppointmentDAO();
            dao.updateAppointmentStatus(apptId, action);
            
            // 4. Redirect back to dashboard with success message
            response.sendRedirect("doctorDashboard.jsp?msg=action_success");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("doctorDashboard.jsp?error=invalid_operation");
        }
    }
}