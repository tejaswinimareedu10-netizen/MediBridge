package com.medibridge.controller;

import com.medibridge.dao.DoctorLoginDAO;
import com.medibridge.model.Doctor;
import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DoctorLoginServlet")
public class DoctorLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        DoctorLoginDAO dao = new DoctorLoginDAO();
        Doctor doctor = dao.validateDoctor(email, password);

        if (doctor != null) {
            // Check Admin Approval Status
            if ("PENDING".equalsIgnoreCase(doctor.getApprovalStatus())) {
                response.sendRedirect("doctorLogin.jsp?error=" + URLEncoder.encode("Your account is PENDING approval from Admin!", "UTF-8"));
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("doctor", doctor);
            response.sendRedirect("doctorDashboard.jsp");
        } else {
            response.sendRedirect("doctorLogin.jsp?error=" + URLEncoder.encode("Invalid Doctor Email or Password!", "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}