
drop view v_dividendos;
create view v_dividendos as
select div_socios.compania, div_socios.tipo_d_persona,  div_socios.socio, div_socios.ruc, div_socios.dv, div_socios.nombre1, div_socios.nombre2,
div_socios.nombre3, div_socios.nombre4, '6' as descripcion_de_la_operacion, Anio(div_movimientos.fecha) as anio,
Mes(div_movimientos.fecha) as mes, div_movimientos.fecha, 
(select sum(no_d_acciones) from div_libro_d_acciones
where div_libro_d_acciones.compania = div_socios.compania
and div_libro_d_acciones.socio = div_socios.socio) as acciones,
div_movimientos.dividendo, 
div_movimientos.renta
from div_movimientos, div_socios
where div_socios.compania = div_movimientos.compania
and div_socios.socio = div_movimientos.socio
and div_movimientos.fecha >= '2013-01-01'
order by div_movimientos.fecha, div_movimientos.socio
