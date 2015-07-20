
begin work;
    update pla_periodos
    set status = 'C'
    where dia_d_pago < current_date
    and status = 'A';
commit work;


begin work;
    update pla_empleados
    set status = 'I'
    where fecha_terminacion_real is not null
    and status in ('A','V');
commit work;

begin work;
    update pla_vacaciones
    set status = 'I'
    where pagar_hasta < current_date
    and status = 'A';
commit work;

