insert into div_socios (compania, socio, grupo, nombre1, nombre2,
nombre3, nombre4, no_acciones, giro, a_nombre_de, apartado, telefono1,
telefono2, usuario, fecha_captura, tipo_d_persona, ruc, dv)
select '05', socio, grupo, nombre1, nombre2,
nombre3, nombre4, no_acciones, giro, a_nombre_de, apartado, telefono1,
telefono2, usuario, fecha_captura, tipo_d_persona, ruc, dv
from div_socios
where compania = '03';
