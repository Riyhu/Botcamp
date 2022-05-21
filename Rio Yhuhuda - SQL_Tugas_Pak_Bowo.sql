use Employee
------------------------- Rio Yhuhuda -------------------------------------- 
-- //----------------------- NOMOR 1 ----------------------------- // --------- 
select CONCAT(bio.first_name,' ',bio.last_name) as [Nama Lengkap],pos.name as Jabatan, DATEDIFF(YEAR,bio.dob,CURRENT_TIMESTAMP) as Umur, COUNT(fam.biodata_id) as [Jumlah Anak] 
from biodata as bio
join employee as emp on emp.biodata_id = bio.id
join employee_position as emppos on emppos.employee_id = emp.id
join position as pos on pos.id = emppos.position_id
join family as fam on fam.biodata_id = bio.id
where fam.status = 'Anak'
group by CONCAT(bio.first_name,' ',bio.last_name),pos.name,DATEDIFF(YEAR,bio.dob,CURRENT_TIMESTAMP)



---------------------------- NOMOR 2 ----------------------------------
select CONCAT(bio.first_name,' ',bio.last_name)as [nama Lengkap],sum(Datediff(DAY,req.start_date,req.end_date)) as [Jumlah Cuti]
from employee as emp
join leave_request as req on req.employee_id = emp.id
join biodata as bio on bio.id = emp.biodata_id
group by CONCAT(bio.first_name,' ',bio.last_name)


----------------------------- Nomor 3 ------------------------------
select Top 3 CONCAT(bio.first_name,' ',bio.last_name) as [Nama Lengkap], pos.name as [Jabatan], DATEDIFF(YEAR,bio.dob,CURRENT_TIMESTAMP)as[Umur]
from biodata as bio
join employee as emp on emp.biodata_id = bio.id
join employee_position as emppos on emppos.employee_id = emp.id
join position as pos on pos.id = emppos.position_id
order by DATEDIFF(YEAR,bio.dob,CURRENT_TIMESTAMP)desc



-------------------------- NOMOR 4 ---------------------- 
select CONCAT(bio.first_name,' ',bio.last_name) as [Nama Lengkap]
from biodata as bio
left join employee as emp on emp.biodata_id = bio.id
left join employee_position as emppos on emppos.employee_id = emp.id
left join position as pos on pos.id = emppos.position_id
where pos.name is null


------------------------------ Nomor 5 ----------------------------
select cast(round(avg(emp.salary),4)as decimal(16,2)) as [Rata rata gaji Staff]
from employee as emp
join employee_position as empl on empl.employee_id = emp.id
join position as pos on pos.id = empl.position_id
where pos.name='Staff'



----------------------------- Nomor 6 ------------------------------------
select CONCAT(bio.first_name,' ',bio.last_name) as [Nama Karyawan], tipe.name as [Tipe Dinas] , format(req.start_date, 'dd MMMM yyyy', 'en-US') as [Tanggal Perjalanan],cast(sum(sett.item_cost)as numeric(32,2)) as [Total Pengeluaran]
from biodata as bio
join employee as emp on emp.biodata_id = bio.id
join travel_request as req on req.employee_id = emp.id
join travel_type as tipe on tipe.id = req.travel_type_id
join travel_settlement as sett on sett.travel_request_id = req.id
group by CONCAT(bio.first_name,' ',bio.last_name), tipe.name, req.start_date



-------------------------- Nomor 7 ---------------------------------------
select cuti.[Nama Karyawan], (empl.regular_quota - cuti.[Jumlah Cuti]) as [jumlah sisa cuti]
from
	(select emp.id,CONCAT(bio.first_name,' ',bio.last_name) as [Nama Karyawan] ,sum(Datediff(DAY,req.start_date,req.end_date)) as [Jumlah Cuti]
	from employee as emp
	join leave_request as req on req.employee_id =emp.id 
	join biodata as bio on bio.id = emp.id
	group by emp.id,CONCAT(bio.first_name,' ',bio.last_name)
	)as cuti
join employee_leave as empl on empl.employee_id = cuti.id
where empl.period=2020



-------------------------- Nomor 8 ---------------------------------------
select cast(round(avg(emp.salary),4)as decimal(16,2)) as [Rata rata gaji Karyawan yang bukan STAFF]
from employee as emp
join employee_position as empl on empl.employee_id = emp.id
join position as pos on pos.id = empl.position_id
where pos.name!='Staff'



------------------------ Nomor 9 -----------------------------------------
select 
concat(count(marital_status),' orang') as [Biodata],(case
	when marital_status = 1 then 'Menikah'
	else 'Tidak Menikah'
end) as [status]
from biodata 
group by (case
	when marital_status = 1 then 'Menikah'
	else 'Tidak Menikah'
end)



------------------------ Nomor 10 -----------------------------------------
select tampung.nama ,(tampung.[Jumlah Cuti]+tampung.[jumlah dinas]) as [Jumlah hari tidak berada dikantor]
from(
	select dinas.id,dinas.nama, sum(Datediff(DAY,req.start_date,req.end_date)) as [Jumlah Cuti], dinas.[jumlah dinas]	
	from 
		(select emp.id, bio.first_name as [nama], sum(Datediff(DAY,treq.start_date,treq.end_date)) as [jumlah dinas] 
		from employee as emp
		join travel_request as treq on treq.employee_id = emp.id
		join biodata as bio on bio.id = emp.id
		group by bio.first_name, emp.id
		) as dinas
	join leave_request as req on req.employee_id = dinas.id
	group by dinas.id,dinas.nama, dinas.[jumlah dinas]
) as tampung
join employee_leave as empl on empl.employee_id = tampung.id
where tampung.nama='Raya' AND empl.period =2020
------------------------- Rio Yhuhuda -------------------------------------- 

