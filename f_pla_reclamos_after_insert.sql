

drop FUNCTION f_pla_reclamos_after_insert() cascade;

CREATE FUNCTION f_pla_reclamos_after_insert() RETURNS trigger
    AS $$
declare
    i integer;
    r_pla_periodos record;
    r_pla_empleados record;
    r_pla_tipos_de_horas record;
begin
    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    if not found then
        raise exception 'Codigo de Empleado % no Existe',new.codigo_empleado;
    end if;
   
    new.tipo_de_planilla = r_pla_empleados.tipo_de_planilla;

    select into r_pla_periodos *
    from pla_periodos
    where compania = new.compania
    and year = new.year
    and numero_planilla = new.numero_planilla
    and tipo_de_planilla = new.tipo_de_planilla;
    if not found then
        raise exception 'Numero de Planilla % no existe',new.numero_planilla;
    end if;

    if r_pla_periodos.status = 'C' then
        Raise Exception 'Numero de Planilla % esta cerrado',new.numero_planilla;
    end if;

    i   =   f_pla_reclamos_pla_dinero(new.compania, new.codigo_empleado, new.tipo_de_planilla, new.year, new.numero_planilla);
    i   =   f_pla_seguro_social(new.compania, new.codigo_empleado, r_pla_periodos.id, '5');
    i   =   f_pla_seguro_educativo(new.compania, new.codigo_empleado, r_pla_periodos.id, '5');
    return new;
end;
$$
    LANGUAGE plpgsql;

