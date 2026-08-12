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

@WebServlet("/DoctorRegisterServlet")
public class DoctorRegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String specialization = request.getParameter("specialization");
        String phone = request.getParameter("phone");

        Doctor doctor = new Doctor();
        doctor.setFullName(fullName != null ? fullName.trim() : "");
        doctor.setEmail(email != null ? email.trim() : "");
        doctor.setPassword(password != null ? password.trim() : "");
        doctor.setSpecialization(specialization != null ? specialization.trim() : "");
        doctor.setPhone(phone != null ? phone.trim() : "");

        DoctorLoginDAO dao = new DoctorLoginDAO();
        boolean success = dao.registerDoctor(doctor);

        if (success) {
            response.sendRedirect("doctorLogin.jsp?msg=" + URLEncoder.encode("Registered successfully! Wait for Admin APPROVAL.", "UTF-8"));
        } else {
            response.sendRedirect("doctorRegister.jsp?error=" + URLEncoder.encode("Registration failed. Try again!", "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}