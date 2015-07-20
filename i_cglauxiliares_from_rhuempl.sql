
begin work;
    insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
    select trim(codigo_empleado), substring(nombre_del_empleado from 1 for 30), '1', 'A'
    from rhuempl
    where status in ('A', 'V')
    and trim(codigo_empleado) not in (select trim(codigo_empleado) from cglauxiliares);
commit work;

begin work;
    update cglauxiliares
    set nombre = substring(trim(rhuempl.nombre_del_empleado) from 1 for 30)
    where trim(rhuempl.codigo_empleado) = trim(cglauxiliares.auxiliar)
    and rhuempl.status = 'A';
commit work;