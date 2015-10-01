
--set search_path to dba;

select f_nomctrac_pla_reservas(compania, codigo_empleado,
tipo_calculo, nomctrac.tipo_planilla, nomctrac.year, nomctrac.numero_planilla, numero_documento,
cod_concepto_planilla), nomctrac.*
from nomctrac, nomtpla2
where nomctrac.tipo_planilla = nomtpla2.tipo_planilla
and nomctrac.numero_planilla = nomtpla2.numero_planilla
and nomctrac.year = nomtpla2.year
and nomtpla2.dia_d_pago >= '2015-07-01';



/*


delete from cglposteo
where aplicacion_origen = 'PLA'
and fecha_comprobante >= '2015-08-01';

and nomctrac.compania = '03'


*/
