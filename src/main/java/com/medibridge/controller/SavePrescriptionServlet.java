package com.medibridge.controller;

import com.medibridge.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/SavePrescriptionServlet")
public class SavePrescriptionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String apptIdParam = request.getParameter("apptId");
        String diagnosis = request.getParameter("diagnosis");
        String prescription = request.getParameter("prescription");
        String sessionsParam = request.getParameter("sessions");

        if (apptIdParam != null && !apptIdParam.trim().isEmpty()) {
            try {
                int apptId = Integer.parseInt(apptIdParam);
                int sessions = (sessionsParam != null && !sessionsParam.trim().isEmpty()) 
                                ? Integer.parseInt(sessionsParam) : 1;

                String sql = "UPDATE appointment SET diagnosis = ?, prescription = ?, status = 'Completed' WHERE id = ?";

                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(sql)) {

                    ps.setString(1, diagnosis);
                    ps.setString(2, prescription);
                    ps.setInt(3, apptId);

                    ps.executeUpdate();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("doctorAppointments.jsp?msg=saved");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("doctorAppointments.jsp");
    }
}