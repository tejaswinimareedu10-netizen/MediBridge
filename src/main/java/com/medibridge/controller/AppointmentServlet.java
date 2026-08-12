package com.medibridge.controller;

import com.medibridge.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/BookAppointmentServlet")
public class AppointmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            String patientName = request.getParameter("patientName");
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String appointmentDate = request.getParameter("appointmentDate");
            String reason = request.getParameter("reason");

            Connection con = DBConnection.getConnection();

            // Fetch Doctor Name to populate doctor_name field
            String docName = "Assigned Doctor";
            String docSql = "SELECT full_name FROM doctor WHERE doctor_id = ? OR doctorId = ?";
            PreparedStatement docPs = con.prepareStatement(docSql);
            docPs.setInt(1, doctorId);
            docPs.setInt(2, doctorId);
            ResultSet docRs = docPs.executeQuery();
            if (docRs.next()) {
                docName = docRs.getString("full_name");
            }

            // Insert new appointment record with status = 'Pending'
            String sql = "INSERT INTO appointment (patient_id, patient_name, doctor_id, doctor_name, appointment_date, status, reason) VALUES (?, ?, ?, ?, ?, 'Pending', ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, patientId);
            ps.setString(2, patientName);
            ps.setInt(3, doctorId);
            ps.setString(4, docName);
            ps.setString(5, appointmentDate);
            ps.setString(6, reason);

            int rows = ps.executeUpdate();
            con.close();

            if (rows > 0) {
                response.sendRedirect("patientDashboard.jsp?msg=booking_success");
            } else {
                response.sendRedirect("bookAppointment.jsp?error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("bookAppointment.jsp?error=failed");
        }
    }
}