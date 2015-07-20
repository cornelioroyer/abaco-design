select compania, nombre, e_mail, fecha_de_apertura 
from pla_companias 
order by fecha_de_apertura desc, compania desc;


select pla_empleados.compania, pla_companias.nombre from pla_empleados, pla_companias
where pla_empleados.compania = pla_companias.compania
group by 1, 2
order by 1 desc;

select fecha_de_apertura, count(*) from pla_companias
group by 1
order by 1 desc;