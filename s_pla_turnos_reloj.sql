SELECT pla_turnos.hora_inicio,pla_turnos_reloj.* FROM pla_turnos_reloj, pla_turnos
where pla_turnos_reloj.compania = pla_turnos.compania
and pla_turnos_reloj.turno = pla_turnos.turno
and pla_turnos.compania = 1360
