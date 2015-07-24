

drop function f_it_tbl_data_user_before_insert() cascade;

create function f_it_tbl_data_user_before_insert() returns trigger as '
declare
    r_pla_empleados record;
    li_cia int4;
begin

--    raise exception ''error en la base de datos'';

/*    
    li_cia = new.it_dat_use_company;

    select into r_pla_empleados *
    from pla_empleados
    where compania = li_cia
    and trim(cedula) = trim(new.id_dat_use_id);
    if not found then
--        Raise Exception ''Cedula % no Existe'', new.id_dat_use_id;
    end if;        
*/        
    return new;
end;
' language plpgsql;


create trigger t_it_tbl_data_user_before_insert before insert on it_tbl_data_user
for each row execute procedure f_it_tbl_data_user_before_insert();



