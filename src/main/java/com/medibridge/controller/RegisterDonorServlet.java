package com.medibridge.controller;

import com.medibridge.util.DBConnection;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterDonorServlet")
public class RegisterDonorServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String bloodGroup = request.getParameter("bloodGroup");
        String city = request.getParameter("city");
        String phone = request.getParameter("phone");

        if (fullName == null || fullName.trim().isEmpty() || 
            bloodGroup == null || city == null || phone == null) {
            response.sendRedirect("donorRegister.jsp?error=" + URLEncoder.encode("Please fill all required details!", "UTF-8"));
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            if (con != null) {
                String sql = "INSERT INTO blood_donors (full_name, blood_group, city, phone) VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, fullName.trim());
                    ps.setString(2, bloodGroup.trim());
                    ps.setString(3, city.trim());
                    ps.setString(4, phone.trim());

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        response.sendRedirect("donorRegister.jsp?msg=" + URLEncoder.encode("Successfully Registered as Blood Donor! ❤️", "UTF-8"));
                        return;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            String dbError = e.getMessage() != null ? e.getMessage() : "Database error";
            response.sendRedirect("donorRegister.jsp?error=" + URLEncoder.encode(dbError, "UTF-8"));
            return;
        }

        response.sendRedirect("donorRegister.jsp?error=" + URLEncoder.encode("Failed to register as donor. Try again!", "UTF-8"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}