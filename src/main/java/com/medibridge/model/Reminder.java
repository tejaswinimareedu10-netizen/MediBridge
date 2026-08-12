package com.medibridge.model;

import java.sql.Time;

public class Reminder {
    private int id;
    private int patientId;
    private String medicineName;
    private String dosage;
    private Time reminderTime;
    private String status;

    // Constructors
    public Reminder() {}

    public Reminder(int patientId, String medicineName, String dosage, Time reminderTime, String status) {
        this.patientId = patientId;
        this.medicineName = medicineName;
        this.dosage = dosage;
        this.reminderTime = reminderTime;
        this.status = status;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }

    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }

    public Time getReminderTime() { return reminderTime; }
    public void setReminderTime(Time reminderTime) { this.reminderTime = reminderTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}