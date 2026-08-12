package com.medibridge.dao;

import com.medibridge.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DoctorAppointmentDAO {

    public ResultSet getAppointments(int doctorId) {

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT a.*, p.full_name FROM appointment a JOIN patient p ON a.patient_id = p.patient_id WHERE a.doctor_id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, doctorId);

            return ps.executeQuery();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateStatus(int appointmentId, String status) {

        try {
            Connection con = DBConnection.getConnection();

            String sql = "UPDATE appointment SET status=? WHERE appointment_id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, appointmentId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}