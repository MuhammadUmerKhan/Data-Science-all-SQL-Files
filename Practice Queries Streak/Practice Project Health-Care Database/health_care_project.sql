-- Step 1: Create Database
CREATE DATABASE IF NOT EXISTS healthcare_db;
USE healthcare_db;

-- Step 2: Create Tables
-- Patients Table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender CHAR(1),
    registration_date DATE
);

-- Doctors Table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialty VARCHAR(100)
);

-- Appointments Table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    reason TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Prescriptions Table
CREATE TABLE Prescriptions (
    prescription_id INT PRIMARY KEY,
    appointment_id INT,
    medicine_name VARCHAR(100),
    dosage VARCHAR(50),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- Bills Table
CREATE TABLE Bills (
    bill_id INT PRIMARY KEY,
    patient_id INT,
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    bill_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- Step 3: Insert Realistic Sample Data
-- Patients
INSERT INTO Patients (patient_id, first_name, last_name, date_of_birth, gender, registration_date) VALUES
(1, 'John', 'Doe', '1985-04-12', 'M', '2023-01-10'),
(2, 'Jane', 'Smith', '1990-09-05', 'F', '2023-02-15'),
(3, 'Robert', 'Brown', '1978-11-22', 'M', '2023-03-20'),
(4, 'Emily', 'Clark', '1995-06-30', 'F', '2023-04-18'),
(5, 'Michael', 'Johnson', '1982-01-19', 'M', '2023-05-05');

-- Doctors
INSERT INTO Doctors (doctor_id, first_name, last_name, specialty) VALUES
(1, 'Sarah', 'Lee', 'Cardiology'),
(2, 'David', 'Kim', 'Orthopedics'),
(3, 'Laura', 'Adams', 'Dermatology'),
(4, 'James', 'Wilson', 'Pediatrics');

-- Appointments
INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, reason) VALUES
(1, 1, 1, '2023-01-15', 'Chest pain'),
(2, 2, 2, '2023-02-20', 'Knee injury'),
(3, 3, 3, '2023-03-25', 'Skin rash'),
(4, 1, 2, '2023-04-05', 'Back pain'),
(5, 4, 4, '2023-05-10', 'Child fever'),
(6, 5, 1, '2023-06-01', 'High blood pressure');

-- Prescriptions
INSERT INTO Prescriptions (prescription_id, appointment_id, medicine_name, dosage) VALUES
(1, 1, 'Aspirin', '100mg once daily'),
(2, 2, 'Ibuprofen', '200mg twice daily'),
(3, 3, 'Hydrocortisone cream', 'Apply twice daily'),
(4, 4, 'Muscle relaxant', '50mg once daily'),
(5, 5, 'Paracetamol', '500mg three times daily'),
(6, 6, 'Lisinopril', '10mg once daily');

-- Bills
INSERT INTO Bills (bill_id, patient_id, total_amount, payment_status, bill_date) VALUES
(1, 1, 300.00, 'Paid', '2023-01-20'),
(2, 2, 150.00, 'Unpaid', '2023-02-25'),
(3, 3, 200.00, 'Paid', '2023-03-30'),
(4, 4, 120.00, 'Paid', '2023-05-15'),
(5, 5, 500.00, 'Unpaid', '2023-06-05');

-- --------------------------------------- Problem Statements ---------------------------------------
-- Question 1: Show all appointments with patient and doctor full names.
select a.appointment_id, 
		concat(p.first_name, ' ', p.last_name) as patient_name,
        concat(d.first_name, ' ', d.last_name) as doctor_name,
        a.appointment_date, a.reason 
from Patients p
	join Appointments a on p.patient_id = a.patient_id
    join Doctors d on a.doctor_id = p.patient_id;

-- Question 2: List all patients who had more than one appointment.
select 
	concat(p.first_name, ' ', p.last_name) as patient_name, 
    count(a.appointment_id) as total_appointments
from Patients p 
	join Appointments a on p.patient_id = a.patient_id
group by a.patient_id
having count(a.appointment_id) > 1
order by total_appointments desc;

-- Question 3: Show the total billed amount for each patient (only if they’ve paid).
select 
		concat(p.first_name, ' ', p.last_name) as patient_name, 
        b.payment_status,
		sum(b.total_amount) as total_bill
from Patients p 
	join Bills b on p.patient_id = b.patient_id
where b.payment_status = 'Paid'
group by p.patient_id;

-- Question 4: Show the number of appointments per doctor in descending order.
select 
		d.doctor_id,
        concat(d.first_name, " ", d.last_name) as doctor_name,
        count(a.appointment_id) as total_appointments
from Appointments a 
	join Doctors d on a.doctor_id = d.doctor_id
group by d.doctor_id;

-- Question 5: Find patients who were prescribed more than one medicine in any appointment.
select 
		p.patient_id,
        concat(p.first_name, ' ', p.last_name) as patient_name,
        count(pr.prescription_id) as total_prescription
from Patients p 
	join Appointments a on p.patient_id = a.patient_id
    join Prescriptions pr on a.appointment_id = pr.appointment_id
group by a.appointment_id
having count(pr.prescription_id) > 1
order by total_prescription desc;

-- 1. Get the total number of appointments for each patient.
with PatientAppointements as 
		(select patient_id, count(*) as total_appointments from Appointments group by patient_id)
select concat(p.first_name, ' ', p.last_name) as patient_name, 
		pa.total_appointments
from Patients p join PatientAppointements pa on p.patient_id = pa.patient_id;

-- 2. Show doctors and how many unique patients they’ve seen.
select 	
        d.doctor_id, d.first_name, 
		count(distinct(a.patient_id)) unique_patient_seen
from Doctors d
	join Appointments a on d.doctor_id = a.doctor_id
group by d.doctor_id, d.first_name;

-- 1. List all patients who have had more than one appointment.
select 	
		p.patient_id,
		concat(p.first_name, ' ', p.last_name) as patient_name,
		count(a.appointment_id) as total_appointments
from Patients p 
	join Appointments a on p.patient_id = a.patient_id
group by p.patient_id
having count(a.appointment_id) > 1;

-- 2. Show the total bill amount per payment status (Paid/Unpaid).
select 
	b.payment_status, round(sum(b.total_amount), 2) as total_amount
from Bills b 
group by b.payment_status
order by total_amount desc;

-- 3. Find the most prescribed medicine.
select 
	p.medicine_name, 
    count(*) as prescription_count
from Prescriptions p
group by p.medicine_name
order by prescription_count desc;

-- 4. List all doctors who haven’t had any appointments.
select d.first_name, d.last_name 
from Doctors d
	left join Appointments a on d.doctor_id = a.doctor_id
where a.appointment_id is null;

-- 5. Get patient details who have unpaid bills.
select p.patient_id, p.first_name, p.last_name, b.bill_id, b.payment_status, b.payment_status, b.bill_date 
from Patients p 
	join Bills b on p.patient_id = b.patient_id
where b.payment_status = 'Unpaid';

-- 6. Calculate the average bill per patient.
select 	p.patient_id, p.first_name, p.last_name,
		round(avg(b.total_amount), 2) as avg_bill
from Patients p
	join Bills b on p.patient_id = b.patient_id
group by p.patient_id;

-- 8. List all patients along with their latest appointment date.
select 
	p.patient_id, p.first_name, p.last_name, max(a.appointment_date) as latest_appointment
from Patients p
	join Appointments a on p.patient_id = a.patient_id
group by p.patient_id, p.first_name, p.last_name;

-- 9. Show doctors and the number of prescriptions they have issued.
select 
		d.doctor_id, d.first_name, d.last_name, count(p.prescription_id) as total_prescriptions
from Doctors d 
	join Appointments a on d.doctor_id = a.doctor_id
    join Prescriptions p on a.appointment_id = p.appointment_id
group by d.doctor_id, d.first_name, d.last_name;

-- 10. Find which doctor is treating the oldest patient.
select d.doctor_id, p.patient_id, d.first_name as doctor_name, p.first_name as patient_name, p.date_of_birth
from Appointments a
	join Doctors d on a.doctor_id = d.doctor_id
    join Patients p on a.patient_id = p.patient_id
order by p.date_of_birth asc limit 1;