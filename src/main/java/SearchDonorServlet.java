package com.medibridge.controller;

import com.medibridge.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SearchDonorServlet")
public class SearchDonorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String bloodGroup = request.getParameter("bloodGroup");
        String city = request.getParameter("city");

        List<Map<String, String>> donorList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            if (con != null) {
                StringBuilder sql = new StringBuilder("SELECT * FROM blood_donors WHERE 1=1");

                if (bloodGroup != null && !bloodGroup.trim().isEmpty() && !bloodGroup.equalsIgnoreCase("ALL")) {
                    sql.append(" AND blood_group = ?");
                }
                if (city != null && !city.trim().isEmpty()) {
                    sql.append(" AND LOWER(city) LIKE LOWER(?)");
                }

                try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
                    int paramIndex = 1;

                    if (bloodGroup != null && !bloodGroup.trim().isEmpty() && !bloodGroup.equalsIgnoreCase("ALL")) {
                        ps.setString(paramIndex++, bloodGroup.trim());
                    }
                    if (city != null && !city.trim().isEmpty()) {
                        ps.setString(paramIndex++, "%" + city.trim() + "%");
                    }

                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, String> donor = new HashMap<>();
                            donor.put("fullName", rs.getString("full_name"));
                            donor.put("bloodGroup", rs.getString("blood_group"));
                            donor.put("city", rs.getString("city"));
                            donor.put("phone", rs.getString("phone"));
                            donorList.add(donor);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("donorList", donorList);
        request.getRequestDispatcher("searchDonor.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}