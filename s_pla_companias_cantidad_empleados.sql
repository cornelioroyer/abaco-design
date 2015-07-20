select compania, count(*) from pla_empleados
group by 1
order by 2 desc
limit 10
