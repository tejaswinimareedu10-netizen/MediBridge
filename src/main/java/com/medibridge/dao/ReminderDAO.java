package com.medibridge.dao;

import com.medibridge.model.Reminder;
import com.medibridge.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReminderDAO {

    // Add new reminder
    public boolean addReminder(Reminder reminder) {
        boolean status = false;
        String sql = "INSERT INTO medicine_reminders(patient_id, medicine_name, dosage, reminder_time, status) VALUES(?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reminder.getPatientId());
            ps.setString(2, reminder.getMedicineName());
            ps.setString(3, reminder.getDosage());
            ps.setTime(4, reminder.getReminderTime());
            ps.setString(5, reminder.getStatus());

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    // Fetch reminders by patient ID
    public List<Reminder> getRemindersByPatient(int patientId) {
        List<Reminder> list = new ArrayList<>();
        String sql = "SELECT * FROM medicine_reminders WHERE patient_id = ? ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Reminder rem = new Reminder();
                rem.setId(rs.getInt("id"));
                rem.setPatientId(rs.getInt("patient_id"));
                rem.setMedicineName(rs.getString("medicine_name"));
                rem.setDosage(rs.getString("dosage"));
                rem.setReminderTime(rs.getTime("reminder_time"));
                rem.setStatus(rs.getString("status"));

                list.add(rem);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}