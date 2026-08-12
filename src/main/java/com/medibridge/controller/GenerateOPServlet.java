package com.medibridge.controller;

import com.medibridge.model.Patient;
import com.medibridge.util.DBConnection;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/GenerateOPTokenServlet")
public class GenerateOPServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");

        if (patient == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String patientName = request.getParameter("patientName");
        String ageStr = request.getParameter("age");
        String gender = request.getParameter("gender");
        String doctorIdStr = request.getParameter("doctorId");
        String symptoms = request.getParameter("symptoms");

        if (patientName == null || ageStr == null || doctorIdStr == null) {
            response.sendRedirect("generateOPToken.jsp?error=" + URLEncoder.encode("All fields are required!", "UTF-8"));
            return;
        }

        int doctorId = Integer.parseInt(doctorIdStr);
        int age = Integer.parseInt(ageStr);

        try (Connection con = DBConnection.getConnection()) {
            if (con != null) {
                // Calculate Token Number for Today
                int nextTokenNo = 1;
                String countSql = "SELECT COUNT(*) FROM op_tokens WHERE doctor_id = ? AND DATE(created_at) = CURDATE()";
                try (PreparedStatement psCount = con.prepareStatement(countSql)) {
                    psCount.setInt(1, doctorId);
                    try (ResultSet rs = psCount.executeQuery()) {
                        if (rs.next()) {
                            nextTokenNo = rs.getInt(1) + 1;
                        }
                    }
                }

                String tokenNumber = "OP-" + nextTokenNo;

                // Insert OP Token linked with Doctor ID
                String insertSql = "INSERT INTO op_tokens (patient_id, doctor_id, patient_name, age, gender, symptoms, token_number, status) VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')";
                try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                    ps.setInt(1, patient.getPatientId());
                    ps.setInt(2, doctorId);
                    ps.setString(3, patientName.trim());
                    ps.setInt(4, age);
                    ps.setString(5, gender);
                    ps.setString(6, symptoms.trim());
                    ps.setString(7, tokenNumber);

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        response.sendRedirect("generateOPToken.jsp?msg=" + URLEncoder.encode("OP Token Generated Successfully! Token No: " + tokenNumber, "UTF-8"));
                        return;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("generateOPToken.jsp?error=" + URLEncoder.encode("Database error: " + e.getMessage(), "UTF-8"));
            return;
        }

        response.sendRedirect("generateOPToken.jsp?error=" + URLEncoder.encode("Failed to generate token. Try again!", "UTF-8"));
    }
}