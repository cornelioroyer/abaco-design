insert into pla_turnos(compania, turno, hora_inicio,
hora_salida, hora_inicio_descanso, hora_salida_descanso,
tolerancia_de_entrada, tolerancia_de_salida,
tolerancia_descanso,
tipo_de_jornada)
select 791, to_number(cod_id_turnos,'999'), hora_inicio_trabajo,
hora_salida_trabajo, inicio_descanso, finalizar_descanso,
hora_inicio_trabajo, hora_salida_trabajo, tolerancia_descanso,
tipo_de_jornada
 from tmp_rhuturno
 where cod_id_turnos <> '01'