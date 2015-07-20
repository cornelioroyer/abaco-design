insert into pla_cuentas(cuenta, compania, nombre, nivel, naturaleza,
tipo_cuenta, status, departamentos, acreedores, empleados, proyectos)
select cuenta, 747, nombre, '1',naturaleza, tipo_cuenta, status,
true, true, true, true
from pla_cuentas_pp