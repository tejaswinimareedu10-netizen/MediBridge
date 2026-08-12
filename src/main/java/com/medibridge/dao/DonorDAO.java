package com.medibridge.dao;

import com.medibridge.model.Donor;
import com.medibridge.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DonorDAO {

    // 1. Register a new Blood Donor
    public boolean registerDonor(Donor donor) {
        boolean success = false;
        String sql = "INSERT INTO blood_donor (name, blood_group, phone, city, availability_status) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, donor.getName());
            ps.setString(2, donor.getBloodGroup());
            ps.setString(3, donor.getPhone());
            ps.setString(4, donor.getCity());
            ps.setString(5, donor.getAvailabilityStatus() != null ? donor.getAvailabilityStatus() : "Available");

            success = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    // 2. Search Donors by Blood Group and optional City
    public List<Donor> searchDonors(String bloodGroup, String city) {
        List<Donor> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM blood_donor WHERE blood_group = ?");
        
        boolean hasCity = (city != null && !city.trim().isEmpty());
        if (hasCity) {
            sql.append(" AND LOWER(city) LIKE LOWER(?)");
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            ps.setString(1, bloodGroup);
            if (hasCity) {
                ps.setString(2, "%" + city.trim() + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Donor donor = new Donor();
                    donor.setId(rs.getInt("donor_id"));
                    donor.setName(rs.getString("name"));
                    donor.setBloodGroup(rs.getString("blood_group"));
                    donor.setPhone(rs.getString("phone"));
                    donor.setCity(rs.getString("city"));
                    donor.setAvailabilityStatus(rs.getString("availability_status"));
                    list.add(donor);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}