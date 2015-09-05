
--delete from att_punches_pla_marcaciones;

select att_punches.id, hr_employee.emp_pin, att_punches.punch_time, f_att_punches_pla_marcaciones(att_punches.id)
from att_punches, hr_employee, hr_department
where att_punches.employee_id = hr_employee.id
and hr_department.id = hr_employee.department_id
and hr_department.company_id in (1382)
and punch_time >= '2015-08-01'
order by att_punches.punch_time

/*

and trim(hr_employee.emp_pin) = '0001'
and att_punches.id not in (select att_punches_id from att_punches_pla_marcaciones)

*/
