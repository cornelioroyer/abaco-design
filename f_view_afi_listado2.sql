drop view view_afi_listado2;
create view view_afi_listado2 as
select afi_depreciacion.codigo, 
(-sum(afi_depreciacion.depreciacion) + (select costo_inicial from activos
where activos.codigo = afi_depreciacion.codigo)) as valor_actual
from afi_depreciacion, afi_listado2
where afi_depreciacion.codigo = afi_listado2.codigo
and afi_depreciacion.compania = afi_listado2.compania
and afi_depreciacion.aplicacion = afi_listado2.aplicacion
and afi_depreciacion.year = afi_listado2.year
and afi_depreciacion.periodo = afi_listado2.periodo
group by afi_depreciacion.codigo
