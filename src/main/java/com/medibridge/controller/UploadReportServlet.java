package com.medibridge.controller;

import com.medibridge.model.Doctor;
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
        
        // 1. Verify Doctor Session
        Doctor doctor = (Doctor) session.getAttribute("doctor");
        if (doctor == null) {
            response.sendRedirect("doctorLogin.jsp");
            return;
        }

        // 2. Fetch manual form inputs
        String patientIdStr = request.getParameter("patientId");
        String reportTitle = request.getParameter("reportTitle");
        Part filePart = request.getPart("reportFile");

        if (patientIdStr == null || patientIdStr.trim().isEmpty() || filePart == null || filePart.getSize() == 0 || reportTitle == null) {
            response.sendRedirect("uploadReport.jsp?error=" + URLEncoder.encode("Please enter Patient ID, title and select a valid report file!", "UTF-8"));
            return;
        }

        int patientId;
        try {
            patientId = Integer.parseInt(patientIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("uploadReport.jsp?error=" + URLEncoder.encode("Invalid Patient ID format!", "UTF-8"));
            return;
        }

        // 3. Project uploads directory path
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        // 4. Get file name and make unique with timestamp
        String originalFileName = extractFileName(filePart);
        String fileName = System.currentTimeMillis() + "_" + originalFileName;
        String filePath = uploadPath + File.separator + fileName;

        // Save file locally
        try {
            filePart.write(filePath);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("uploadReport.jsp?error=" + URLEncoder.encode("File write failed: " + e.getMessage(), "UTF-8"));
            return;
        }

        // 5. Save entry in Database
        try (Connection con = DBConnection.getConnection()) {
            if (con != null) {
                String sql = "INSERT INTO medical_reports (patient_id, report_title, file_name) VALUES (?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, patientId);
                    ps.setString(2, reportTitle.trim());
                    ps.setString(3, fileName);

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        response.sendRedirect("uploadReport.jsp?msg=" + URLEncoder.encode("Lab Report Uploaded Successfully!", "UTF-8"));
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