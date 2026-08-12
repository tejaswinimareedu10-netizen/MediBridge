package com.medibridge.dao;

import com.medibridge.model.Doctor;
import com.medibridge.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DoctorLoginDAO {

    // 1. Validate Login using Email & Password
    public Doctor validateDoctor(String email, String password) {
        Doctor doctor = null;
        String sql = "SELECT * FROM doctor WHERE email = ? AND password = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email != null ? email.trim() : "");
            ps.setString(2, password != null ? password.trim() : "");

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("doctor_id"));
                    doctor.setFullName(rs.getString("full_name"));
                    doctor.setEmail(rs.getString("email"));
                    doctor.setPassword(rs.getString("password"));
                    doctor.setSpecialization(rs.getString("specialization"));
                    doctor.setPhone(rs.getString("phone"));
                    doctor.setApprovalStatus(rs.getString("approval_status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doctor;
    }

    // 2. Doctor Registration (Inserts into DB with default status 'PENDING')
    public boolean registerDoctor(Doctor doctor) {
        boolean registered = false;
        String sql = "INSERT INTO doctor (full_name, email, password, specialization, phone, approval_status) VALUES (?, ?, ?, ?, ?, 'PENDING')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, doctor.getFullName());
            ps.setString(2, doctor.getEmail());
            ps.setString(3, doctor.getPassword());
            ps.setString(4, doctor.getSpecialization());
            ps.setString(5, doctor.getPhone());

            registered = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return registered;
    }
}