drop view v_fac_resumen_semanal;
create view v_fac_resumen_semanal as
select fac_resumen_semanal.usuario, gralcompanias.nombre, Trim(titulo1) as titulo1, Trim(titulo2) as titulo2, 
fact_referencias.descripcion, fac_resumen_semanal.referencia, fac_resumen_semanal.fecha, 
sum(fac_resumen_semanal.saldo_inicial) as saldo_inicial,
sum(fac_resumen_semanal.facturacion_semanal) as facturacion_semanal, 
sum(fac_resumen_semanal.monto) as monto
from gralcompanias, almacen, fac_resumen_semanal, fact_referencias
where gralcompanias.compania = almacen.compania
and almacen.almacen = fac_resumen_semanal.almacen
and fact_referencias.referencia = fac_resumen_semanal.referencia
group by 1, 2, 3, 4, 5, 6, 7