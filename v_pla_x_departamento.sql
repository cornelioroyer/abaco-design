drop view v_planilla_x_departamento;
drop view v_planilla_x_cuenta;

create view v_planilla_x_departamento as
select nomctrac.compania, rhuempl.codigo_empleado, rhuempl.nombre_del_empleado,
departamentos.descripcion, nomconce.nombre_concepto, nomconce.tipodeconcepto, 
nomconce.priorioridad_impresion,
nomtpla2.dia_d_pago, Anio(nomtpla2.dia_d_pago) as anio, Mes(nomtpla2.dia_d_pago) as mes,
(nomctrac.monto*nomconce.signo) as monto
from nomctrac, rhuempl, departamentos, nomconce, nomtpla2
where nomctrac.compania = rhuempl.compania
and nomctrac.codigo_empleado = rhuempl.codigo_empleado
and nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
and rhuempl.departamento = departamentos.codigo
and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
and nomctrac.numero_planilla = nomtpla2.numero_planilla
and nomctrac.year = nomtpla2.year
and nomtpla2.dia_d_pago >= '2011-01-01';



create view v_planilla_x_cuenta as
select nomctrac.compania, rhuempl.codigo_empleado, rhuempl.nombre_del_empleado,
departamentos.descripcion, nomconce.nombre_concepto, nomconce.tipodeconcepto, 
nomconce.priorioridad_impresion, pla_afectacion_contable.cuenta,
nomtpla2.dia_d_pago, Anio(nomtpla2.dia_d_pago) as anio, Mes(nomtpla2.dia_d_pago) as mes,
(nomctrac.monto*nomconce.signo) as monto
from nomctrac, rhuempl, departamentos, nomconce, nomtpla2, pla_afectacion_contable
where nomctrac.compania = rhuempl.compania
and nomctrac.codigo_empleado = rhuempl.codigo_empleado
and nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
and rhuempl.departamento = departamentos.codigo
and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
and nomctrac.numero_planilla = nomtpla2.numero_planilla
and nomctrac.year = nomtpla2.year
and rhuempl.departamento = pla_afectacion_contable.departamento
and nomctrac.cod_concepto_planilla = pla_afectacion_contable.cod_concepto_planilla
and nomtpla2.dia_d_pago >= '2011-01-01';



