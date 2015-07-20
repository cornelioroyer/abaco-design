insert into rela_nomctrac_cglposteo (codigo_empleado, compania, tipo_calculo,
cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento,
consecutivo)
select codigo_empleado, compania, tipo_calculo,
cod_concepto_planilla, tipo_planilla, numero_planilla,
year, numero_documento, 2
from nomctrac
where no_cheque is null
and not exists
(select * from rela_nomctrac_cglposteo
where rela_nomctrac_cglposteo.codigo_empleado = nomctrac.codigo_empleado
and rela_nomctrac_cglposteo.compania = nomctrac.compania
and rela_nomctrac_cglposteo.tipo_calculo = nomctrac.tipo_calculo
and rela_nomctrac_cglposteo.cod_concepto_planilla = nomctrac.cod_concepto_planilla
and rela_nomctrac_cglposteo.tipo_planilla = nomctrac.tipo_planilla
and rela_nomctrac_cglposteo.numero_planilla = nomctrac.numero_planilla
and rela_nomctrac_cglposteo.year = nomctrac.year
and rela_nomctrac_cglposteo.numero_documento = nomctrac.numero_documento)