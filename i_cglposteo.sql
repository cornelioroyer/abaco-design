insert into cglposteo (consecutivo, secuencia, compania, aplicacion,
year, periodo, cuenta, tipo_comp, aplicacion_origen, usuario_captura, usuario_actualiza,
fecha_comprobante, fecha_captura, fecha_actualiza, descripcion, debito, credito,
status, linea)
select consecutivo, secuencia, compania, aplicacion,
year, periodo, cuenta, tipo_comp, aplicacion_origen, usuario_captura, usuario_actualiza,
fecha_comprobante, fecha_captura, fecha_actualiza, descripcion, debito, credito,
status, linea from tmp_cglposteo;