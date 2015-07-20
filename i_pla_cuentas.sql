insert into pla_cuentas(cuenta, compania, nombre, nivel, naturaleza,
tipo_cuenta, status, departamentos, acreedores, empleados, proyectos)
select cuenta, 747, nombre, nivel, naturaleza,
tipo_cuenta, status, departamentos, acreedores, empleados, proyectos
from pla_cuentas
where compania = 745