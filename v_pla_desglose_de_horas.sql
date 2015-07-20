
drop view v_pla_desglose_de_horas;

create view v_pla_desglose_de_horas as
select rhuempl.tipo_planilla, rhuempl.nombre_del_empleado, rhuempl.codigo_empleado,
rhuempl.tasaporhora, nomhoras.fecha_laborable, Anio(nomhoras.fecha_laborable) as anio,
Mes(nomhoras.fecha_laborable) as mes,
nomtipodehoras.descripcion, 
((nomhoras.horas+(nomhoras.minutos/60))*nomtipodehoras.signo) as horas
from rhuempl, nomhoras, nomtipodehoras
where rhuempl.compania = nomhoras.compania
and rhuempl.codigo_empleado = nomhoras.codigo_empleado
and nomhoras.tipodhora = nomtipodehoras.tipodhora
