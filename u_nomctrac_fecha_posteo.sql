begin work;
update nomctrac
set fecha_posteo = bcocheck1.fecha_posteo
where nomctrac.cod_ctabco = bcocheck1.cod_ctabco
and nomctrac.no_cheque = bcocheck1.no_cheque
and nomctrac.motivo_bco = bcocheck1.motivo_bco
and bcocheck1.status <> 'A';
commit work;


begin work;
update nomctrac
set fecha_posteo = cglposteo.fecha_comprobante
where nomctrac.codigo_empleado = rela_nomctrac_cglposteo.codigo_empleado
and nomctrac.compania = rela_nomctrac_cglposteo.compania
and nomctrac.tipo_calculo = rela_nomctrac_cglposteo.tipo_calculo
and nomctrac.cod_concepto_planilla = rela_nomctrac_cglposteo.cod_concepto_planilla
and nomctrac.tipo_planilla = rela_nomctrac_cglposteo.tipo_planilla
and nomctrac.numero_planilla = rela_nomctrac_cglposteo.numero_planilla
and nomctrac.year = rela_nomctrac_cglposteo.year
and nomctrac.numero_documento = rela_nomctrac_cglposteo.numero_documento
and rela_nomctrac_cglposteo.consecutivo = cglposteo.consecutivo;
commit work;
