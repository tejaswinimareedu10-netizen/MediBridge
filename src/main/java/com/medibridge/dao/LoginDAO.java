package com.medibridge.dao;

import com.medibridge.model.Patient;
import com.medibridge.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginDAO {

    public Patient login(String email, String password) {
        Patient patient = null;

        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM patient WHERE email=? AND password=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                patient = new Patient();

                // Safe extraction checking both column names
                try {
                    patient.setPatientId(rs.getInt("patientId"));
                } catch (SQLException e) {
                    patient.setPatientId(rs.getInt("patient_id"));
                }

                try {
                    patient.setFullName(rs.getString("full_name"));
                } catch (SQLException e) {
                    patient.setFullName(rs.getString("fullName"));
                }

                patient.setEmail(rs.getString("email"));
                patient.setPassword(rs.getString("password"));
                patient.setPhone(rs.getString("phone"));
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return patient;
    }
}