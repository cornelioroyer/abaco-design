
insert into pla_bancos(id_pla_cuentas, compania, nombre,
status, sec_cheques, sec_solicitudes, ruta_ach)
select 13266, 1304, nombre, status, 0, 0, ruta_ach
from pla_bancos
where compania = 749;

