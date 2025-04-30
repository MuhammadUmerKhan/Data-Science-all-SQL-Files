-- 1. Find patients whose total unpaid bill is above the average unpaid bill.
select 
	p.patient_id, 
    concat(p.first_name, ' ', p.last_name) as patient_name,
    b.payment_status, b.total_amount
from Patients p
	join Bills b on p.patient_id = b.patient_id
where b.total_amount > (select round(avg(b.total_amount), 2) as avg_unpaid_amount from Bills b where b.payment_status = 'Unpaid');

-- 2. For each patient, show the number of days between their registration and first appointment.
with FirstAppointments as (
	select
		patient_id, min(appointment_date) as first_visit
	from Appointments 
	group by patient_id
)
select 
	p.patient_id, 
    concat(p.first_name, ' ', p.last_name) as patient_name,
    datediff(fa.first_visit, p.registration_date) as days_until_first_visit
from Patients p
	join FirstAppointments fa on p.patient_id = fa.patient_id
order by days_until_first_visit desc;

-- 3. Show all patients and classify them as 'New', 'Active', or 'Frequent' based on number of appointments.
with PatientAppointments as (
	select 
		patient_id, 
		count(appointment_id) as total_appointments
	from Appointments 
	group by patient_id
)
select 	p.patient_id, 
		concat(p.first_name, ' ', p.last_name) as patient_name,
        pa.total_appointments,
        case
			when pa.total_appointments = 1 then "New"
            when pa.total_appointments between 2 and 3 then "Active"
			else "Frequent"
		end as patient_status
from Patients p 
	join PatientAppointments pa on p.patient_id = pa.patient_id;

-- 4. Rank patients by total billing amount using window function.
with PatientBillingAmount as (
	select 
		patient_id,
		sum(total_amount) as patient_total_amount,
		rank() over (order by sum(total_amount) desc) as amount_rank
	from Bills 
	group by patient_id
	order by patient_total_amount desc
)
select 
		p.patient_id,
        concat(p.first_name, ' ', p.last_name) as patient_name,
        pb.patient_total_amount, pb.amount_rank
from Patients p 
	join PatientBillingAmount pb on p.patient_id = pb.patient_id
order by pb.amount_rank asc;

-- 5. Find the doctor who gave the most prescriptions each month.
with DoctorPrescriptions as (
	select 
		d.doctor_id, d.first_name, d.last_name,
        month(a.appointment_date) as month_no,
		count(pre.prescription_id) as prescriptions_count
	from Doctors d 
		join Appointments a on d.doctor_id = a.doctor_id
		join Prescriptions pre on a.appointment_id = pre.appointment_id
	group by d.doctor_id, d.first_name, d.last_name, month(a.appointment_date)
),
ranked as (
	select *,
    row_number() over (partition by month_no order by prescriptions_count desc) as rnk
    from DoctorPrescriptions
)
select * from ranked where rnk = 1;

-- 6. List patients who had their appointment with a cardiologist.
select doctor_id from Doctors where specialty='Cardiology';
select 	p.patient_id, a.appointment_id, a.doctor_id,
		concat(d.first_name, ' ', d.last_name) as doctor_name,
		concat(p.first_name, ' ', p.last_name) as patient_name,
		a.reason
from Patients p 
	join Appointments a on p.patient_id = a.patient_id
    join Doctors d on a.doctor_id = d.doctor_id
where a.doctor_id in (select doctor_id from Doctors where specialty='Cardiology');

-- 7. For each doctor, find the average billing amount of their patients.
select 
	d.doctor_id, d.first_name, d.last_name,
    avg(b.total_amount) as avg_billed
from Doctors d 
	join Appointments a on d.doctor_id = a.doctor_id
    join Bills b on a.patient_id = b.patient_id
group by d.doctor_id, d.first_name, d.last_name;

-- 8. Find the top 2 most prescribed medicines per doctor.
with DoctorMeds as (
	select
		d.doctor_id, d.first_name, d.last_name, pr.medicine_name,
		count(*) as times_prescribed
	from Doctors d 
		join Appointments a on d.doctor_id = a.doctor_id
		join Prescriptions pr on a.appointment_id = pr.appointment_id
	group by d.doctor_id, d.first_name, d.last_name, pr.medicine_name
),
ranked as (
	select *,
    row_number() over (partition by doctor_id order by times_prescribed desc) as rnk
    from DoctorMeds
)
select * from ranked where rnk <= 2
order by rnk desc;

-- 9. Show running total of billing per patient ordered by bill date.
with RunningBill as (
	select 
		patient_id, bill_date, total_amount, 
		sum(total_amount) over (partition by patient_id order by bill_date desc) as running_total
	from Bills
)
select  
	rb.patient_id, rb.total_amount, rb.bill_date, p.first_name
from RunningBill rb 
	join Patients p on rb.patient_id = p.patient_id;

-- 10. Identify months where unpaid bills exceeded paid bills.
with MonthlyStatus as (
	select 
		month(bill_date) as month,
		sum(case when payment_status = 'Paid' then total_amount else 0 end) as paid_total,
		sum(case when payment_status = 'Unpaid' then total_amount else 0 end) as unpaid_total
	from Bills
	group by month(bill_date)
)
select month, paid_total, unpaid_total from MonthlyStatus where unpaid_total>paid_total;

--  [1] Identify patients who had multiple appointments within the same month
with MonthlyVisits as (
	select 	patient_id,
			date_format(appointment_date, '%Y-%m') as visit_month,
			count(*) over (partition by patient_id, date_format(appointment_date, '%Y-%m')) as monthly_visits
	from Appointments
)
select patient_id, visit_month, monthly_visits from MonthlyVisits where monthly_visits > 1;

--  [2] Show all doctors along with their total number of patients treated
select 	d.doctor_id, d.first_name, d.last_name,
		count(distinct a.patient_id) as total_patients
from Doctors d 
	left join Appointments a on d.doctor_id = a.doctor_id
group by d.doctor_id;

--  [3] Find patients with unpaid bills above the average bill amount
select p.patient_id, p.first_name, p.last_name, b.total_amount, b.payment_status 
from Patients p 
	join Bills b on p.patient_id = b.patient_id
where p.patient_id in (
	select patient_id 
		from Bills where (total_amount > (select avg(total_amount) from Bills) and payment_status='Unpaid'));

--  [4] List top 2 most prescribed medicines
with MedicineCount as (
	select 	medicine_name, 
			count(prescription_id) as prescription_count,
			rank() over (order by count(prescription_id) desc) as rank_order
	from Prescriptions
	group by medicine_name
)
select medicine_name, prescription_count from MedicineCount where rank_order <= 1;

--  [5] Assign billing tier (High, Medium, Low) using CASE
select 	
		patient_id, total_amount, payment_status,
		case
			when total_amount >= 400 then 'High'
			when total_amount >= 200 then 'Medium'
			else "Low"
		end as billing_teir
from Bills;

--  [6] Show each patient's first appointment date
WITH RankedAppointments AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY appointment_date ASC) AS rn
  FROM Appointments
)
SELECT patient_id, appointment_date AS first_appointment
FROM RankedAppointments
WHERE rn = 1;