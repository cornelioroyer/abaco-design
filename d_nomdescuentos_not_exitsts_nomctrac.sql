
delete from nomdescuentos
where not exists
(select * from nomctrac
where nomctrac.codigo_empleado = nomdescuentos.codigo_empleado
and nomctrac.compania = nomdescuentos.compania
and nomctrac.tipo_calculo = nomdescuentos.tipo_calculo
and nomctrac.cod_concepto_planilla = nomdescuentos.cod_concepto_planilla
and nomctrac.tipo_planilla = nomdescuentos.tipo_planilla
and nomctrac.numero_planilla = nomdescuentos.numero_planilla
and nomctrac.year = nomdescuentos.year
and nomctrac.numero_documento = nomdescuentos.numero_documento);


