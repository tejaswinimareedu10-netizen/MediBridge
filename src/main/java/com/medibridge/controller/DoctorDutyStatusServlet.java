package com.medibridge.controller;

import com.medibridge.model.Doctor;
import com.medibridge.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DoctorDutyStatusServlet")
public class DoctorDutyStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Doctor doctor = (session != null) ? (Doctor) session.getAttribute("doctor") : null;
        
        String dutyStatus = request.getParameter("dutyStatus"); // "ON_DUTY" or "OFF_DUTY"

        if (doctor != null && dutyStatus != null) {
            try (Connection con = DBConnection.getConnection()) {
                if (con != null) {
                    // Update live duty availability in doctor table
                    String sql = "UPDATE doctor SET duty_status = ? WHERE doctor_id = ?";
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setString(1, dutyStatus);
                        ps.setInt(2, doctor.getDoctorId());
                        ps.executeUpdate();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // Return smoothly back to doctor workspace
        response.sendRedirect("doctorDashboard.jsp?duty=" + (dutyStatus != null ? dutyStatus : "updated"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}