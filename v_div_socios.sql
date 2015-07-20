drop view v_div_socios;

create view v_div_socios as
select div_socios.socio, div_socios.nombre1, 
sum(no_d_acciones) as no_d_acciones
from div_socios, div_libro_d_acciones
where div_socios.socio = div_libro_d_acciones.socio
and div_libro_d_acciones.status = 'A'
group by 1, 2