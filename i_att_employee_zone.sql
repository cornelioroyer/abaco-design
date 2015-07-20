

insert into att_employee_zone(employee_id, zone_id)
select hr_employee.id, 1165 from hr_employee, hr_department
where hr_employee.department_id = hr_department.id
and hr_department.company_id = 1360

