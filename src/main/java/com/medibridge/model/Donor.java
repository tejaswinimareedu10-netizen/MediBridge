package com.medibridge.model;

public class Donor {

    private int id;
    private String name;
    private String bloodGroup;
    private String phone;
    private String city;
    private String availabilityStatus;

    // 1. Default (No-Argument) Constructor
    public Donor() {}

    // 2. Parameterized Constructor (Matches DonorServlet!)
    public Donor(String name, String bloodGroup, String phone, String city, String availabilityStatus) {
        this.name = name;
        this.bloodGroup = bloodGroup;
        this.phone = phone;
        this.city = city;
        this.availabilityStatus = availabilityStatus;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBloodGroup() {
        return bloodGroup;
    }

    public void setBloodGroup(String bloodGroup) {
        this.bloodGroup = bloodGroup;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getAvailabilityStatus() {
        return availabilityStatus;
    }

    public void setAvailabilityStatus(String availabilityStatus) {
        this.availabilityStatus = availabilityStatus;
    }
}