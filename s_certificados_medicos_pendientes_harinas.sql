

select codigo_empleado, 
(36 - (select sum(horas)/8 from pla_certificados
where pla_certificados.compania = rhuempl.compania
and pla_certificados.codigo_empleado = rhuempl.codigo_empleado
and pla_certificados.pagado = 'S'
and pla_certificados.f_hasta >= '2012-07-09'))
from rhuempl
where compania = '03'
and status in ('A', 'V')
order by 1

