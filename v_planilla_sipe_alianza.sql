
drop view v_planilla_sipe_alianza;

create view v_planilla_sipe_alianza as
select pla_companias.compania, trim(pla_companias.nombre) as nombre_cia, pla_empleados.codigo_empleado, 
trim(pla_empleados.nombre) as nombre,
trim(pla_empleados.apellido) as apellido,
Anio(pla_periodos.dia_d_pago) as anio,
Mes(pla_periodos.dia_d_pago) as mes,
pla_estructura.columna,
sum(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_periodos, pla_conceptos, pla_columnas, pla_estructura, pla_empleados, pla_companias
where pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_dinero.concepto = pla_estructura.concepto
and pla_dinero.compania = pla_companias.compania
and pla_estructura.columna = pla_columnas.columna
and pla_dinero.compania in (1321, 1286, 1287, 1288, 1289, 1290, 1292, 1293, 1294, 1295, 1296, 1297, 1298, 1299, 1300, 1302, 1303, 1305)
and pla_estructura.listado = 1
group by 1, 2, 3, 4, 5, 6, 7, 8

/*
and pla_dinero.compania in (1286, 1287, 1288, 1289, 1290, 1292, 1293, 1294, 1295, 1296, 1297, 1298, 1299, 1300, 1302, 1303, 1305)
*/
