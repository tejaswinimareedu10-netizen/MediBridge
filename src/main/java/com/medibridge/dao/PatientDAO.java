package com.medibridge.dao;

import com.medibridge.model.Patient;
import com.medibridge.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class PatientDAO {

    public boolean registerPatient(Patient patient) {

        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO patient(full_name, email, password, phone, gender, age) VALUES (?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, patient.getFullName());
            ps.setString(2, patient.getEmail());
            ps.setString(3, patient.getPassword());
            ps.setString(4, patient.getPhone());
            ps.setString(5, patient.getGender());
            ps.setInt(6, patient.getAge());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                status = true;
            }

            con.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return status;
    }
}