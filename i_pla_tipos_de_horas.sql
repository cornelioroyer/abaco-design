insert into pla_tipos_de_horas (tipo_de_hora, descripcion,
recargo, tipo_d_dia, tipo_de_jornada, exceso_9horas, signo, sobretiempo)
select tipodhora, descripcion, recargo, tipo_d_dia, tipo_de_jornada, exceso_9horas, signo,
sobretiempo from nomtipodehoras
