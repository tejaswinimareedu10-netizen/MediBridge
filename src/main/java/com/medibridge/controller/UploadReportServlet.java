package com.medibridge.controller;

import com.medibridge.model.Patient;
import com.medibridge.util.DBConnection;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/UploadReportServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UploadReportServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploaded_reports";

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

        String reportTitle = request.getParameter("reportTitle");
        Part filePart = request.getPart("reportFile");

        if (filePart == null || filePart.getSize() == 0 || reportTitle == null) {
            response.sendRedirect("uploadReport.jsp?error=" + URLEncoder.encode("Please select a valid report file!", "UTF-8"));
            return;
        }

        // Project uploads directory path
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        // Get file name and make unique with timestamp
        String originalFileName = extractFileName(filePart);
        String fileName = System.currentTimeMillis() + "_" + originalFileName;
        String filePath = uploadPath + File.separator + fileName;

        // Save file locally
        filePart.write(filePath);

        // Save entry in Database
        try (Connection con = DBConnection.getConnection()) {
            if (con != null) {
                String sql = "INSERT INTO medical_reports (patient_id, report_title, file_name) VALUES (?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, patient.getPatientId());
                    ps.setString(2, reportTitle.trim());
                    ps.setString(3, fileName);

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        response.sendRedirect("medicalReports.jsp?msg=" + URLEncoder.encode("Lab Report Uploaded Successfully!", "UTF-8"));
                        return;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("uploadReport.jsp?error=" + URLEncoder.encode("Database error: " + e.getMessage(), "UTF-8"));
            return;
        }

        response.sendRedirect("uploadReport.jsp?error=" + URLEncoder.encode("Failed to upload report. Try again!", "UTF-8"));
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String s : contentDisp.split(";")) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "report.pdf";
    }
}