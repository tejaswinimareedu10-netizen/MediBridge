package com.medibridge.dao;

import com.medibridge.model.Appointment;
import com.medibridge.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AppointmentDAO {

    // 1. Method to book a new appointment request
    public boolean bookAppointment(Appointment appointment) {
        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO appointment(patient_id, doctor_id, appointment_date, appointment_time, status) VALUES(?,?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, appointment.getPatientId());
            ps.setInt(2, appointment.getDoctorId());
            ps.setString(3, appointment.getAppointmentDate());
            ps.setString(4, appointment.getAppointmentTime());
            ps.setString(5, "Pending");

            int rows = ps.executeUpdate();

            if (rows > 0) {
                status = true;
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    // 2. Method to fetch historical logs for a specific patient
    public List<Map<String, String>> getAppointmentsByPatient(int patientId) {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT a.appointment_date, a.appointment_time, a.status, d.full_name, d.specialization " +
                     "FROM appointment a JOIN doctor d ON a.doctor_id = d.doctor_id " +
                     "WHERE a.patient_id = ? ORDER BY a.appointment_date DESC";
                     
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, String> map = new HashMap<>();
                map.put("date", rs.getString("appointment_date"));
                map.put("time", rs.getString("appointment_time"));
                map.put("status", rs.getString("status"));
                map.put("doctorName", rs.getString("full_name"));
                map.put("specialization", rs.getString("specialization"));
                list.add(map);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Method to fetch all incoming checkup requests for a specific doctor
    public List<Map<String, String>> getAppointmentsByDoctor(int doctorId) {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT a.id AS appt_id, a.appointment_date, a.appointment_time, a.status, p.full_name, p.phone " +
                     "FROM appointment a JOIN patient p ON a.patient_id = p.patientId " +
                     "WHERE a.doctor_id = ? ORDER BY a.appointment_date ASC";
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, String> map = new HashMap<>();
                map.put("apptId", rs.getString("appt_id"));
                map.put("date", rs.getString("appointment_date"));
                map.put("time", rs.getString("appointment_time"));
                map.put("status", rs.getString("status"));
                map.put("patientName", rs.getString("full_name"));
                map.put("patientPhone", rs.getString("phone"));
                list.add(map);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. Method to change appointment status (Approved/Rejected)
    public boolean updateAppointmentStatus(int apptId, String status) {
        boolean success = false;
        String sql = "UPDATE appointment SET status = ? WHERE id = ?";
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, apptId);
            
            if (ps.executeUpdate() > 0) {
                success = true;
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
}