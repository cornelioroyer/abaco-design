insert into cgl_presupuesto
select compania, 2006, 13, cuenta, monto, usuario, fecha_captura
from cgl_presupuesto
where compania = '02'
and anio = 2006
and mes = 1

/*
and not exists
(select * from cgl_presupuesto a
where a.compania = cgl_presupuesto.compania
and a.anio = cgl_presupuesto.anio
and a.mes = 12
and a.cuenta = cgl_presupuesto.cuenta)
*/