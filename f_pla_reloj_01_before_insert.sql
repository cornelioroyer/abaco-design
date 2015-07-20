drop function f_pla_reloj_01_before_insert() cascade;


create function f_pla_reloj_01_before_insert() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    ld_fecha date;
    li_work int4;
begin
    
    if new.compania = 1135 then
        li_work =   new.codigo_reloj;
        
        new.codigo_reloj    =   trim(to_char(li_work,''9999999''));    
    end if;

    return new;
end;
' language plpgsql;

create trigger t_pla_reloj_01_before_insert before insert on pla_reloj_01
for each row execute procedure f_pla_reloj_01_before_insert();
