package com.medibridge.controller;

import com.medibridge.model.Patient;
import com.medibridge.util.DBConnection;
import java.io.File;
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

@WebServlet("/DeleteReportServlet")
public class DeleteReportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");
        
        // If patient is not logged in, redirect to login page
        if (patient == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int reportId = Integer.parseInt(idStr);
                Connection con = DBConnection.getConnection();
                
                // 1. Fetch file name from database using report_id
                String selectSql = "SELECT file_name FROM medical_reports WHERE report_id = ?";
                PreparedStatement psSelect = con.prepareStatement(selectSql);
                psSelect.setInt(1, reportId);
                ResultSet rs = psSelect.executeQuery();
                
                String fileName = "";
                if (rs.next()) {
                    fileName = rs.getString("file_name");
                }
                rs.close();
                psSelect.close();

                // 2. Delete physical file from 'uploaded_reports' folder
                if (fileName != null && !fileName.isEmpty()) {
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploaded_reports";
                    File file = new File(uploadPath + File.separator + fileName);
                    if (file.exists()) {
                        file.delete();
                    }
                }

                // 3. Delete row from database using report_id
                String deleteSql = "DELETE FROM medical_reports WHERE report_id = ?";
                PreparedStatement psDelete = con.prepareStatement(deleteSql);
                psDelete.setInt(1, reportId);
                int rows = psDelete.executeUpdate();
                psDelete.close();
                con.close();

                if (rows > 0) {
                    response.sendRedirect("medicalReports.jsp?msg=" + URLEncoder.encode("Report deleted successfully!", "UTF-8"));
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("medicalReports.jsp?error=" + URLEncoder.encode("Error deleting report: " + e.getMessage(), "UTF-8"));
                return;
            }
        }
        response.sendRedirect("medicalReports.jsp?error=" + URLEncoder.encode("Invalid report ID.", "UTF-8"));
    }
}