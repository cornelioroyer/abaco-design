
drop view v_ach_dividendos;
create view v_ach_dividendos as
select div_movimientos.fecha, div_socios.compania,
trim(div_socios.nombre1) as nombre,
trim(div_socios.socio) as accionista,
trim(div_socios.email) as email,
div_socios.ruta,
div_socios.tipo_de_cuenta,
trim(div_socios.cuenta) as cuenta,
(div_movimientos.dividendo-div_movimientos.renta) as monto
from div_socios, div_movimientos
where div_socios.compania = div_movimientos.compania
and div_socios.socio = div_movimientos.socio
and div_movimientos.fecha >= '2014-01-01'
and div_socios.forma_de_pago = 'A'
