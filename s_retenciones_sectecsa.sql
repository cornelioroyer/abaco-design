select pla_acreedores.nombre, pla_acreedores.acreedor, codigo_empleado, hacer_cheque
from pla_retenciones, pla_acreedores
where pla_retenciones.acreedor = pla_acreedores.acreedor
and pla_retenciones.compania = 1261
and pla_retenciones.acreedor = 'B-01'
order by 1, 2
