insert into nomctrac (mes,
codigo_empleado, compania, tipo_calculo, 
cod_concepto_planilla, monto, tipo_planilla,
numero_planilla, year, usuario, fecha_actualiza,
status, forma_de_registro, descripcion,
numero_documento)
select 2, codigo_empleado, compania,
'1', '290', 3, '1', 7, 2004, 'dba', Today(),
'R', 'M', 'SUBSIDIO POR DEFUNCION', '0'
from rhuempl
where tipo_planilla = '1'
and status = 'A'

