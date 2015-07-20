drop function f_pla_parametros_contables(int4) cascade;


create function f_pla_parametros_contables(int4) returns integer as '
declare
    ai_cia alias for $1;
    r_pla_companias record;
    r_pla_departamentos record;
    r_pla_proyectos record;
    r_pla_cuentas record;
    r_pla_conceptos record;
    r_pla_parametros_contables record;
begin
    select into r_pla_companias * from pla_companias
    where compania = ai_cia;
    if not found then
        return 0;
    end if;
    
    select into r_pla_cuentas * from pla_cuentas
    where compania = ai_cia
    and cuenta = ''22500'';
    if not found then
        return 0;
    end if;
    
    for r_pla_departamentos
        in select * from pla_departamentos
            where compania = ai_cia
            order by id
    loop
        for r_pla_proyectos in
            select * from pla_proyectos
            where compania = ai_cia
            order by id
        loop
            for r_pla_conceptos in
                select * from pla_conceptos order by concepto
            loop
                select into r_pla_parametros_contables *
                from pla_parametros_contables
                where id_pla_departamentos = r_pla_departamentos.id
                and id_pla_proyectos = r_pla_proyectos.id
                and concepto = r_pla_conceptos.concepto
                and compania = ai_cia;
                if not found then
                    insert into pla_parametros_contables (id_pla_departamentos, id_pla_proyectos,
                        concepto, id_pla_cuentas, compania)
                    values(r_pla_departamentos.id, r_pla_proyectos.id, r_pla_conceptos.concepto,
                            r_pla_cuentas.id, ai_cia);
                end if;
            end loop;            
        end loop;
    end loop;
    
    return 1;
end;
' language plpgsql;
