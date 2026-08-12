package com.medibridge.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.medibridge.dao.PatientDAO;
import com.medibridge.model.Patient;

@WebServlet("/registerServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get data from the JSP form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        int age = Integer.parseInt(request.getParameter("age"));

        // 2. Create a Patient object
        Patient patient = new Patient();
        patient.setFullName(fullName);
        patient.setEmail(email);
        patient.setPassword(password);
        patient.setPhone(phone);
        patient.setGender(gender);
        patient.setAge(age);

        // 3. Call the DAO to save the data
        PatientDAO dao = new PatientDAO();
        boolean success = dao.registerPatient(patient);

        // 4. Send response back to the user
        if (success) {
            response.getWriter().println("<h1>Registration Successful!</h1>");
            response.getWriter().println("<a href='register.jsp'>Go Back</a>");
        } else {
            response.getWriter().println("<h1>Registration Failed. Please try again.</h1>");
        }
    }
}