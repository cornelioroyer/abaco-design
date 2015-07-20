
drop view v_cxp_declaracion_impuestos;

create view v_cxp_declaracion_impuestos as
select gralcompanias.nombre, cglposteo.compania, f_cglposteo(cglposteo.consecutivo, 'NOMBRE') as nombre_proveedor,
f_cglposteo(cglposteo.consecutivo, 'PROVEEDOR') as proveedor,
f_cglposteo(cglposteo.consecutivo, 'TIPO') as tipo,
f_cglposteo(cglposteo.consecutivo, 'DOCUMENTO') as documento,
cglposteo.fecha_comprobante as fecha,
f_cglposteo(cglposteo.consecutivo, 'OBSERVACION') as observacion,
f_cglposteo_itbms(cglposteo.consecutivo, 'COMPRA') as compra,
f_cglposteo_itbms(cglposteo.consecutivo, 'ITBMS') as impuesto
from cglposteo, gral_impuestos, gralcompanias
where cglposteo.cuenta = gral_impuestos.cuenta
and cglposteo.compania = gralcompanias.compania
and aplicacion_origen <> 'FAC'
and fecha_comprobante >= '2010-01-01'
