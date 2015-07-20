
drop view v_paying;
drop view v_pay_contabilidad;

create view v_pay_contabilidad as
select departamentos.descripcion as d_departamento,
departamentos.codigo, nomconce.nombre_concepto, cglcuentas.nombre as nombre_de_la_cuenta,
cglcuentas.cuenta as codigo_de_la_cuenta
from pla_afectacion_contable, cglcuentas, nomconce, departamentos
where pla_afectacion_contable.cuenta = cglcuentas.cuenta
and pla_afectacion_contable.departamento = departamentos.codigo
and pla_afectacion_contable.cod_concepto_planilla = nomconce.cod_concepto_planilla
order by 1, 3;


create view v_paying as
select nomctrac.codigo_empleado, rhuempl.departamento, nomtpla2.dia_d_pago,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, 
    nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NSALREG')) as nsalreg,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NSALSOB')) as nsalsob,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NBONO')) as nbono,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, 
    nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NOTROING')) as notroing,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NOTROING2')) as notroing2,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NOTROING3')) as otroing3,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, 
    nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NVAC')) as nvac,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NGRVAC')) as ngrvac,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NXIII')) as nxiii,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, 
    nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NGRXIII')) as ngrxiii,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NPRIMA')) as nprima,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NINDEM')) as nindem,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NGASTOREP')) as ngastorep,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NSS')) as nss,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, 
    nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NSE')) as nse,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NISR')) as nisr,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NISRGTORE')) as nisrgtore,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, 
    nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NGRATIF')) as ngratif,
sum(f_monto_por_concepto(nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
    nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla,
    nomctrac.numero_documento, nomctrac.cod_concepto_planilla,
    'NBONIF')) as nbonif
from nomctrac, rhuempl, nomtpla2
where nomctrac.compania = rhuempl.compania
and nomctrac.codigo_empleado = rhuempl.codigo_empleado
and rhuempl.fecha_terminacion is null
and rhuempl.status in ('A','V')
and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
and nomctrac.year = nomtpla2.year
and nomctrac.numero_planilla = nomtpla2.numero_planilla
and nomtpla2.dia_d_pago >= '2005-01-01'
group by 1, 2, 3
