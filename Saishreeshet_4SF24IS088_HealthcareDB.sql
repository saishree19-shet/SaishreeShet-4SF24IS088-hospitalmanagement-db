

CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100),
    patient_phone VARCHAR(15)
);

CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100),
    doctor_specialization VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
);

CREATE TABLE Consultation (
    consultation_id INT PRIMARY KEY,
    patient_id INT,
    appointment_id INT,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

CREATE TABLE Consultation_Doctor (
    consultation_id INT,
    doctor_id INT,
    contribution VARCHAR(100),
    PRIMARY KEY (consultation_id, doctor_id),
    FOREIGN KEY (consultation_id) REFERENCES Consultation(consultation_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
);

CREATE TABLE Diagnosis (
    diagnosis_id INT PRIMARY KEY,
    consultation_id INT,
    diagnosis_description VARCHAR(255),
    FOREIGN KEY (consultation_id) REFERENCES Consultation(consultation_id)
);

CREATE TABLE Prescription (
    prescription_id INT PRIMARY KEY,
    consultation_id INT,
    FOREIGN KEY (consultation_id) REFERENCES Consultation(consultation_id)
);

CREATE TABLE Medicine (
    medicine_id INT PRIMARY KEY,
    medicine_name VARCHAR(100),
    medicine_price DECIMAL(10,2)
);

CREATE TABLE Prescribed_Medicine (
    prescription_id INT,
    medicine_id INT,
    PRIMARY KEY (prescription_id, medicine_id),
    FOREIGN KEY (prescription_id) REFERENCES Prescription(prescription_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicine(medicine_id)
);

CREATE TABLE Bill (
    bill_id INT PRIMARY KEY,
    consultation_id INT,
    bill_amount DECIMAL(10,2),
    FOREIGN KEY (consultation_id) REFERENCES Consultation(consultation_id)
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    bill_id INT,
    payment_status VARCHAR(50),
    FOREIGN KEY (bill_id) REFERENCES Bill(bill_id)
);

-- ========================
-- INSERT DATA (5 RECORDS EACH)
-- ========================

INSERT INTO Patient VALUES
(1, 'Sai', '9876543210'),
(2, 'Anu', '9123456780'),
(3, 'Ravi', '9988776655'),
(4, 'Meena', '9012345678'),
(5, 'Kiran', '9090909090');

INSERT INTO Department VALUES
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Orthopedics'),
(4, 'Dermatology'),
(5, 'General');

INSERT INTO Doctor VALUES
(1, 'Dr. Rao', 'Cardiologist', 1),
(2, 'Dr. Sharma', 'Neurologist', 2),
(3, 'Dr. Kumar', 'Orthopedic', 3),
(4, 'Dr. Priya', 'Dermatologist', 4),
(5, 'Dr. Arjun', 'General Physician', 5);

INSERT INTO Appointment VALUES
(1, 1, 1, '2026-04-01'),
(2, 2, 2, '2026-04-02'),
(3, 3, 3, '2026-04-03'),
(4, 4, 4, '2026-04-04'),
(5, 5, 5, '2026-04-05');

INSERT INTO Consultation VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

INSERT INTO Consultation_Doctor VALUES
(1, 1, 'Primary'),
(2, 2, 'Primary'),
(3, 3, 'Primary'),
(4, 4, 'Primary'),
(5, 5, 'Primary');

INSERT INTO Diagnosis VALUES
(1, 1, 'Fever'),
(2, 2, 'Migraine'),
(3, 3, 'Fracture'),
(4, 4, 'Skin Allergy'),
(5, 5, 'Cold');

INSERT INTO Prescription VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO Medicine VALUES
(1, 'Paracetamol', 50),
(2, 'Ibuprofen', 80),
(3, 'Calcium', 120),
(4, 'Antihistamine', 60),
(5, 'Cough Syrup', 90);

INSERT INTO Prescribed_Medicine VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO Bill VALUES
(1, 1, 500),
(2, 2, 700),
(3, 3, 1000),
(4, 4, 400),
(5, 5, 300);

INSERT INTO Payment VALUES
(1, 1, 'Pending'),
(2, 2, 'Paid'),
(3, 3, 'Pending'),
(4, 4, 'Paid'),
(5, 5, 'Pending');



SELECT * FROM Patient;

SELECT 
    p.patient_name,
    c.consultation_id,
    d.doctor_name,
    diag.diagnosis_description,
    m.medicine_name
FROM Patient p
JOIN Consultation c ON p.patient_id = c.patient_id
JOIN Consultation_Doctor cd ON c.consultation_id = cd.consultation_id
JOIN Doctor d ON cd.doctor_id = d.doctor_id
LEFT JOIN Diagnosis diag ON c.consultation_id = diag.consultation_id
LEFT JOIN Prescription pr ON c.consultation_id = pr.consultation_id
LEFT JOIN Prescribed_Medicine pm ON pr.prescription_id = pm.prescription_id
LEFT JOIN Medicine m ON pm.medicine_id = m.medicine_id;

SELECT 
    d.doctor_name,
    COUNT(cd.consultation_id) AS total_consultations
FROM Doctor d
JOIN Consultation_Doctor cd 
ON d.doctor_id = cd.doctor_id
GROUP BY d.doctor_name
ORDER BY total_consultations DESC;

SELECT 
    p.patient_name,
    SUM(b.bill_amount) AS total_pending
FROM Patient p
JOIN Consultation c ON p.patient_id = c.patient_id
JOIN Bill b ON c.consultation_id = b.consultation_id
JOIN Payment pay ON b.bill_id = pay.bill_id
WHERE pay.payment_status = 'Pending'
GROUP BY p.patient_id, p.patient_name;

BEGIN TRANSACTION;

INSERT INTO Consultation VALUES (6, 1, 1);

INSERT INTO Diagnosis VALUES (6, 6, 'Headache');

INSERT INTO Prescription VALUES (6, 6);

INSERT INTO Prescribed_Medicine VALUES (6, 1);

INSERT INTO Bill VALUES (6, 6, 600);

INSERT INTO Payment VALUES (6, 6, 'Pending');

COMMIT;
SELECT * FROM Consultation;
SELECT * FROM Diagnosis;
SELECT * FROM Bill;