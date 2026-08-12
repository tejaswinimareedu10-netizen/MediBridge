package com.medibridge.controller;

import com.medibridge.dao.ReminderDAO;
import com.medibridge.model.Reminder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Time;

@WebServlet("/ReminderServlet")
public class ReminderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        try {
            String medicineName = request.getParameter("medicineName");
            String dosage = request.getParameter("dosage");
            String reminderTimeStr = request.getParameter("reminderTime"); // HTML time input returns "HH:mm"
            String patientIdStr = request.getParameter("patientId");

            int patientId = (patientIdStr != null && !patientIdStr.isEmpty()) 
                            ? Integer.parseInt(patientIdStr) : 1;

            Reminder reminder = new Reminder();
            reminder.setPatientId(patientId);
            reminder.setMedicineName(medicineName);
            reminder.setDosage(dosage);

            // Convert String "HH:mm" to java.sql.Time
            if (reminderTimeStr != null && !reminderTimeStr.isEmpty()) {
                if (reminderTimeStr.length() == 5) { 
                    reminderTimeStr += ":00"; // Format as "HH:mm:ss" for Time.valueOf
                }
                reminder.setReminderTime(Time.valueOf(reminderTimeStr));
            }

            reminder.setStatus("Active");

            ReminderDAO dao = new ReminderDAO();
            dao.addReminder(reminder);

            response.sendRedirect("medicineReminder.jsp?msg=added");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("medicineReminder.jsp?error=failed");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("medicineReminder.jsp");
    }
}