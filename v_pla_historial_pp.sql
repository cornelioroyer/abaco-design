
drop view v_pla_historial_pp;

drop function f_pla_nombre_empleado(int4, char(7)) cascade;


create function f_pla_nombre_empleado(int4, char(7)) returns varchar(100) as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    r_pla_empleados record;
    lvc_nombre varchar(100);
begin
    lvc_nombre = null;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = ai_cia
    and trim(codigo_empleado) = trim(as_codigo_empleado);
    if found then
        lvc_nombre  =   trim(r_pla_empleados.nombre) || ''  '' || trim(r_pla_empleados.apellido);
    end if;

    return trim(lvc_nombre);
end;
' language plpgsql;




create view v_pla_historial_pp as
select pla_dinero.compania, pla_dinero.codigo_empleado,
trim(f_pla_nombre_empleado(pla_dinero.compania, pla_dinero.codigo_empleado)) as nombre,
pla_dinero.concepto, pla_conceptos.descripcion,
Anio(pla_periodos.dia_d_pago) as anio,
Mes(pla_periodos.dia_d_pago) as mes,
pla_periodos.dia_d_pago as fecha,
(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_periodos
where pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.id_periodos = pla_periodos.id
union
select pla_preelaboradas.compania, pla_preelaboradas.codigo_empleado,
trim(f_pla_nombre_empleado(pla_preelaboradas.compania, pla_preelaboradas.codigo_empleado)),
pla_preelaboradas.concepto, pla_conceptos.descripcion,
Anio(pla_preelaboradas.fecha),
Mes(pla_preelaboradas.fecha),
pla_preelaboradas.fecha,
pla_preelaboradas.monto*pla_conceptos.signo
from pla_preelaboradas, pla_conceptos
where pla_preelaboradas.concepto =  pla_conceptos.concepto;





