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

@WebServlet("/PatientLoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email") != null ? request.getParameter("email").trim() : "";
        String password = request.getParameter("password") != null ? request.getParameter("password").trim() : "";

        try {
            Connection con = DBConnection.getConnection();

            if (con == null) {
                response.sendRedirect("login.jsp?error=" + URLEncoder.encode("Database Connection Failed!", "UTF-8"));
                return;
            }

            // Database query for table 'patient'
            String sql = "SELECT * FROM patient WHERE email = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Patient patient = new Patient();
                
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setFullName(rs.getString("full_name"));
                patient.setEmail(rs.getString("email"));
                patient.setPhone(rs.getString("phone"));
                patient.setGender(rs.getString("gender"));
                patient.setAge(rs.getInt("age"));

                // Store object in Session
                HttpSession session = request.getSession();
                session.setAttribute("patient", patient);

                con.close();
                
                // Direct Redirection to Patient Dashboard!
                response.sendRedirect("patientDashboard.jsp");
            } else {
                con.close();
                response.sendRedirect("login.jsp?error=" + URLEncoder.encode("Invalid Email or Password!", "UTF-8"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=" + URLEncoder.encode("Error: " + e.getMessage(), "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}