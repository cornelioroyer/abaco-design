SELECT cglcuentas.nombre, tmp_afi_listado1.dep_acumulada, tmp_afi_listado1.dep_actual, 0,
tmp_afi_listado1.dep_acumulada + tmp_afi_listado1.dep_actual
FROM afi_tipo_activo, activos, tmp_afi_listado1, cglcuentas
where afi_tipo_activo.codigo = activos.tipo_activo
and activos.codigo = tmp_afi_listado1.codigo
and afi_tipo_activo.cuenta_activo = cglcuentas.cuenta
order by cglcuentas.nombre