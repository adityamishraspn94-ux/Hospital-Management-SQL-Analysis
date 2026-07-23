Create Database Hospital_Management_System;
Use Hospital_Management_System;

select * from appointments;
select * from patients;
select * from doctors;
select * from treatments;
select * from billing;

-- 1. total no of registered patients

select count(*) as total_patients
from patients;

select * from patients 
limit 10;

-- 2. provide the second patient row 

select * from patients 
limit 1 offset 1;  ## meaning of remove the 1st row after sowing the first row 

-- 3. how many patients are recently ragistered (last 30 days)

select * from patients
where registration_date >= (select max(registration_date) - interval 30 day from patients)
order by registration_date desc;

-- insight 
-- only one patient ragistered 
-- very low recent acquistion rate 
-- reduce marketing , bad reviews , if this pattern continues there will be no new patient in future
-- no efficient utilisation of resources 

-- 4. How many doctors are avaliable in hospital 
select count(*) from doctors;

-- 5. What are distinct specialization in the hospital 
select distinct specialization from doctors;

-- 6. Sort the doctors based on experiences and provide first and last name of doctors together 
-- concat & order by 
select concat(first_name,' ',last_name) as Doctor_name, 
specialization , years_experience
from doctors
order by years_experience desc;

select * from doctors;

-- 7. Find the doctors name ending with 'is' based on first name 
-- use the wild oprator 

select first_name from doctors
where first_name like '%is';   -- any pattern below this and end this    

-- Phone number 

select * from doctors_01;

-- 8. count distinct phone number 
select distinct `phone number` -- there is tilda symbols ,it is could back tick 
from doctors_01;

-- 9. What is total no of rows
select count(*) from appointments;

-- 10. what is appointment status distribution 

select status , count(*) from appointments
group by status;

-- 11. Provide me status type whose count is more than 50

select status, count(*) from appointments
group by status 
having count(*) >50; -- Having is used with group by are not use where 


-- 12. find all appointments in the last 7 days 

select * from appointments 
where appointment_date >= (select max(appointment_date) - interval 7 day from appointments)
order by appointment_date desc;

-- 13. find date wise count of status 
select appointment_date,status, count(*)
from appointments
group by appointment_date,status
order by appointment_date desc;

select * from  treatments;

select count(*) from treatments;

-- 14. most commen treatment_type

select treatment_type,count(*) as treatment_count
from treatments
group by treatment_type 
order by treatment_count desc;

-- 15. Find min cost , max cost , avg cost of the treatment
select min(cost) as min_cost ,
round(max(cost),1) as max_cost , 
round(avg(cost),1) as avg_cost 
from treatments;

select * from treatments;

-- 16. cast , round is temporary change 
-- if you want to make permanent then make a new column and write back to database 
-- update table 

-- update treatments set cost = cast(cast as int); 
-- select cast (cost as int) from treatments;
-- alter treatments cost int 

-- Trancate = delete all rows of a table 
-- delete = delete one rows of a table
 
select * from billing;
 select cast(cost as signed) from treatments;
 
-- 17. PAYMENT STATUS DISTRIBUTION 
select payment_status,count(*) as Bill_count 
from billing
group by payment_status;

-- 18. patients And doctor >> segmentation
select * from patients;

-- 19. How many patients are registed from each address ?

select address, count(*) as patient_count
from patients
group by address
order by patient_count desc;

-- besunisses insight ;-
-- 1. thease regions are residential area , localized demand , strong referral network/residential clusters 
-- targeted outreach 

-- 20. What is age distribution of patients.?  

select * from patients;

SELECT patient_id, first_name, gender ,
TIMESTAMPDIFF(YEAR, date_of_birth, curdate()) AS Age
FROM patients;

-- 21. Age Group Segmentation 
-- 18-35 Adult group
-- 36-55 Mechure group
-- 56+ old group
-- Age_group , patient_count

SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) < 18 THEN 'Under_age'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 18 AND 35 THEN 'Adult_group'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 36 AND 55 THEN 'Metured_group'
        ELSE "Seniors"
    END AS age_group,
    COUNT(*) AS Patient_count
FROM patients
GROUP BY age_group
order by patient_count desc;

select * from patients;

-- 22. which email domains are most commonly used by patients.
select substring_index(email, '@' , -1) as email_domain,
count(*) as patient_count
from patients
group by email_domain;

-- 23. Which month had higher patient Registeration 
select year(registration_date) as year ,
month(registration_date) as month,
count(*) as patient_count
from patients
group by year,month;

-- 24. which medical specialisation are most in demand based on appointment volume ? 	
 
select * from doctors;
select * from appointments;

select d.specialization,
count(a.appointment_id) as total_appointments
from appointments a
join doctors d
on a.doctor_id = d.doctor_id
group by d.specialization
order by total_appointments desc;

-- 25. are critical specialization supported by senior experienced senior doctor or junior doctor ?
-- > 15 years --- senior 

select specialization,
sum(case when years_experience >= 15 then 1 else 0 end) as senior_doctor,
sum(case when years_experience < 15 then 1 else 0 end) as junior_doctor,
count(*) as total_doctors
from doctors 
group by specialization; 

-- 26. make a table/master data >> appointments with patient details and doctor specialisation

select 
a.appointment_id,
concat(p.first_name, '' , p.last_name)  as patient_name,
concat(d.first_name, '' , d.last_name)  as doctor_name,
d.specialization,
a.appointment_date,
a.appointment_time,
a.reason_for_visit,
a.status
from appointments a
join patients p
on a.patient_id = p.patient_id
join doctors d
on a.doctor_id = d.doctor_id
order by appointment_date desc
limit 5;

-- 27. which doctors are oveloaded and which have available capacity based on appointment volume 

select 
concat(d.first_name, '' ,d.last_name) as doctor_name,
d.specialization,
count(a.appointment_id) as total_appointment
from doctors d
left join appointments a
on d.doctor_id = a.doctor_id 
group by d.specialization,d.doctor_id,doctor_name
order by total_appointment desc;

-- 28. build a big master data where we can see the entire journey of a patient >> from appointments > treatments > billing ?

select p.
patient_id,
concat(p.first_name, '' ,p.last_name) as patient_name,
a.appointment_id,
a.appointment_date,
a.status as appointment_status,
t.treatment_id,
t.treatment_type,
t.cost as treatment_cost,
b.bill_id,
b.amount as billed_amount,
b.payment_status
from patients p 
join appointments a
on p.patient_id = a.patient_id
left join treatments t
on a.appointment_id = t.appointment_id
left join billing b
on t.treatment_id = b.treatment_id
order by p.patient_id , a.appointment_date;

-- finances
-- 29. what is total revenue generated by company?

select * from billing;

select sum(amount) as total_revenue
from billing
where payment_status = 'paid';

-- 30. Which patients contribute the most revenue 

select
p.patient_id,
 concat(p.first_name, ' ' ,p.last_name) as patient_name,
 sum(b.amount) as total_spent
from patients p
join billing b
on p.patient_id = b.patient_id
where b.payment_status = 'paid'
group by p.patient_id , patient_name
order by total_spent desc;




  











  



 

