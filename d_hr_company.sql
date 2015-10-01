

delete from hr_employee
using hr_department
where hr_department.id = hr_employee.department_id
and hr_department.company_id = 1263;


delete from hr_department where company_id = 1263;

delete from hr_company where id = 1263;
