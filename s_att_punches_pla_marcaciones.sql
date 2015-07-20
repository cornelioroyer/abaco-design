
--delete from att_punches_pla_marcaciones;

select att_punches.id, hr_employee.emp_pin, att_punches.punch_time, f_att_punches_pla_marcaciones(att_punches.id)
from att_punches, hr_employee
where att_punches.employee_id = hr_employee.id
and punch_time >= '2015-06-26'
order by att_punches.punch_time

/*

and trim(hr_employee.emp_pin) = '0001'
and att_punches.id not in (select att_punches_id from att_punches_pla_marcaciones)

*/

