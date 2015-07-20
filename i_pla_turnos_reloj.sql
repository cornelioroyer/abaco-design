
delete from pla_turnos_reloj where compania = 1360;

insert into pla_turnos_reloj(compania, turno, checkin_begin, checkin_end,
    checkout_begin, checkout_end)
select compania, turno, f_relative_minutes(hora_inicio, -30), 
f_relative_minutes(hora_inicio, 30), 
f_relative_minutes(hora_salida, -30),
f_relative_minutes(hora_salida, 30)
from pla_turnos
where compania = 1360    

/*

select hora_inicio + cast((-90 || 'minutes') as interval),
hora_inicio,
hora_inicio + cast((90 || 'minutes') as interval),
f_relative_minutes(hora_inicio, -60)
from pla_turnos
where compania = 1360;

sELECT  TO_CHAR('60 minute'::interval, 'HH24:MI:SS')

SELECT  TO_CHAR('60 minute'::interval, 'MI')

select cast(60 as seconds);

*/
