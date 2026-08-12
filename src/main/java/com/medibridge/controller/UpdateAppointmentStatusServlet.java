package com.medibridge.controller;

import com.medibridge.dao.DoctorAppointmentDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateAppointmentStatusServlet")
public class UpdateAppointmentStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String status = request.getParameter("status");

        if (idParam != null && status != null) {
            try {
                int appointmentId = Integer.parseInt(idParam);
                DoctorAppointmentDAO dao = new DoctorAppointmentDAO();
                dao.updateStatus(appointmentId, status);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("doctorAppointments.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}