drop view v_cglposteo_detalle_excel;
create view v_cglposteo_detalle_excel as
SELECT gralcompanias.nombre as nombre_compania, cglposteo.compania, 
cglcuentas.nombre as descripcion_cuenta, 
cglposteo.cuenta, cglposteo.fecha_comprobante as fecha, cglposteo.secuencia, 
cglposteo.aplicacion_origen, f_cglposteo(cglposteo.consecutivo, 'NOMBRE') as nombre, 
Trim(cglposteo.descripcion) as descripcion, cglposteo.debito, cglposteo.credito
FROM cglcuentas, cglposteo, gralcompanias
WHERE cglposteo.cuenta = cglcuentas.cuenta 
AND cglposteo.compania = gralcompanias.compania 
AND cglposteo.fecha_comprobante>='2010-01-01'
ORDER BY gralcompanias.nombre, cglposteo.fecha_comprobante, cglposteo.cuenta
