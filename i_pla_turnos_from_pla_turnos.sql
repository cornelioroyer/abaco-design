insert into pla_turnos(compania, turno, hora_inicio, hora_salida,
tipo_de_jornada, hora_inicio_descanso, hora_salida_descanso, tolerancia_de_entrada, 
tolerancia_de_salida) select 1252, turno, hora_inicio, hora_salida,
tipo_de_jornada, hora_inicio_descanso, hora_salida_descanso, tolerancia_de_entrada, 
tolerancia_de_salida from pla_turnos
where compania = 749
and turno <> '1'
