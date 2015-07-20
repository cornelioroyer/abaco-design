
drop view v_saldo_pla_retenciones;

create view v_saldo_pla_retenciones as
select pla_retenciones.compania, pla_companias.nombre as nombre_cia,  
trim(pla_empleados.nombre) || '  ' || trim(pla_empleados.apellido) as nombre_empleado,
pla_retenciones.codigo_empleado, pla_departamentos.descripcion as desc_departamento, 
pla_departamentos.departamento, pla_acreedores.nombre as nombre_acreedor, 
pla_acreedores.acreedor, 
pla_retenciones.id,
pla_retenciones.numero_documento,
pla_retenciones.descripcion_descuento, 
pla_retenciones.fecha_inidescto as fecha_inicio_descuento,
pla_retenciones.monto_original_deuda as monto_original_deuda, 
f_saldo_pla_retenciones(pla_retenciones.id, current_date) as saldo
from pla_companias, pla_acreedores, pla_retenciones,  pla_empleados, pla_departamentos
where pla_retenciones.compania = pla_companias.compania
and pla_retenciones.compania = pla_empleados.compania
and pla_retenciones.codigo_empleado = pla_empleados.codigo_empleado
and pla_empleados.departamento = pla_departamentos.id
and pla_retenciones.acreedor = pla_acreedores.acreedor
and pla_retenciones.compania = pla_acreedores.compania
and pla_retenciones.status <> 'I'
and pla_empleados.status in ('A','V')
and pla_retenciones.compania in (1261);
