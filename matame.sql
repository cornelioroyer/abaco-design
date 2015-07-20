 select * from hr_employee, hr_department, att_punches
    where hr_employee.department_id = hr_department.id
    and hr_employee.id = att_punches.employee.id
    and hr_department.company_id = 1360

/*


    and trim(hr_employee.pin) = trim(r_pla_empleados.codigo_empleado)
    and f_to_date(att_punches.punch_time) >= '2015-07-15'
    and not exists
        (select * from att_punches_pla_marcaciones
            where att_punches_pla_marcaciones.att_punches_id = att_punches.id)
            
            
*/

