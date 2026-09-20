#  MediBridge - Healthcare & Patient Management System

MediBridge is a web-based Java EE application designed to bridge the gap between patients and doctors. It streamlines healthcare management by enabling secure doctor-patient authentications, digital prescription handling, appointment scheduling, and diagnostic/lab report management.

---

##  Key Features

* **Secure Authentication & Sessions:** Separate login and dashboard portals for Patients and Doctors with robust session management.
* **Diagnostic & Lab Report Management:** 
  * Patients and doctors can upload medical reports (PDF/Images) securely.
  * Files are uniquely stored on the server (`uploaded_reports/`) using timestamp-prefixed filenames to prevent overwriting.
  * Transactional deletion support: Deleting a report record from the MySQL database automatically removes the physical PDF file from server storage.
* **Digital Prescriptions:** View and manage digital prescriptions issued during consultations.
* **Appointment Tracking:** Patients can view scheduled appointments and manage healthcare workflows seamlessly.

---

## Tech Stack

* **Backend:** Java EE (Servlets, JSP, JDBC)
* **Server:** Apache Tomcat 8.5.x
* **Database:** MySQL
* **Frontend:** HTML5, CSS3, Bootstrap 5, Bootstrap Icons, JavaScript
* **Version Control:** Git & GitHub

---

##  Database Schema (`medical_reports` table example)

```sql
CREATE TABLE medical_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    report_title VARCHAR(255) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
