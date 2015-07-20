

drop function f_agrupar_correos() cascade;
drop function f_cargar_correos_as() cascade;
drop function f_cargar_contactos() cascade;


create function f_cargar_contactos() returns integer as '
declare
    r_mail_mass_mailing_contact record;
    r_clientes record;
    r_tmp_contactos record;
    lvc_email varchar(200);
    lvc_email2 varchar(200);
    lvc_work varchar(200);
    lc_caracter char(1);
    li_largo integer;
    li_posicion integer;
    li_contador integer;
begin

    for r_tmp_contactos in select tmp_contactos.* 
                        from tmp_contactos
                        where email is not null
                        and Length(Trim(email)) >= 5
                        and Length(Trim(email)) <= 199
                        order by email
    loop


        lvc_email   =   Trim(r_tmp_contactos.email);

            raise exception ''enre %'',lvc_email;
        
        select into r_mail_mass_mailing_contact *
        from mail_mass_mailing_contact
        where trim(email) = trim(lvc_email);
        if not found then
            
            insert into mail_mass_mailing_contact(list_id, email, name)
            values(106, trim(lvc_email), trim(r_tmp_contactos.nombre));          
        else
            raise exception ''lo encontre %'', lvc_email;            
        end if;
        
    end loop;
    

    return 1;
end;
' language plpgsql;




create function f_cargar_correos_as() returns integer as '
declare
    r_mail_mass_mailing_contact record;
    r_clientes record;
    lvc_email varchar(200);
    lvc_email2 varchar(200);
    lvc_work varchar(200);
    lc_caracter char(1);
    li_largo integer;
    li_posicion integer;
    li_contador integer;
begin

    for r_clientes in select clientes.* from clientes
                        where mail is not null
                        and Length(Trim(mail)) >= 5
                        and Length(Trim(mail)) <= 199
                        order by mail
    loop
        lvc_email   =   Trim(r_clientes.mail);
        
        if strpos(trim(lvc_email),'';'') = 0 and strpos(trim(lvc_email),'','') = 0 then
            select into r_mail_mass_mailing_contact *
            from mail_mass_mailing_contact
            where trim(email) = trim(lvc_email);
            if not found then
                insert into mail_mass_mailing_contact(list_id, email)
                values(61, trim(lvc_email));          
            end if;
--            insert into tmp_matame(email2) values (trim(lvc_email));
            continue;
        end if;
        
        li_largo    =   Length(Trim(lvc_email));
        li_contador =   0;
        lvc_email2  =   null;
        
        while true loop
            li_contador =   li_contador + 1;
            
            lc_caracter =   substr(trim(lvc_email), li_contador, 1);
            if lc_caracter = '';'' or lc_caracter = '','' then
                select into r_mail_mass_mailing_contact *
                from mail_mass_mailing_contact
                where trim(email) = trim(lvc_email2);
                if not found then
                    insert into mail_mass_mailing_contact(list_id, email)
                    values(61, trim(lvc_email2));          
                end if;
--                insert into tmp_matame(email2) values (trim(lvc_email2));
                lvc_email2  =   null;
                continue;
            else
                if lvc_email2 is null then
                    lvc_email2  = lc_caracter;
                else
                    lvc_email2  = trim(lvc_email2) || lc_caracter;
                end if;                    
            end if;                
            
            if li_contador >= li_largo then
                exit;
            end if;                
        end loop;
        
    end loop;
    

    return 1;
end;
' language plpgsql;



create function f_agrupar_correos() returns integer as '
declare
    r_mail_mass_mailing_list record;
    r_mail_mass_mailing_contact record;
    r_work record;
    lvc_name varchar;
    li_contador integer;
    li_contador_lista integer;
    li_list_id integer;
begin
    select into r_mail_mass_mailing_list *
    from mail_mass_mailing_list
    where trim(name) = ''temporal'';
    if not found then
        Raise Exception ''No se encontro lista temporal'';
    else
        update mail_mass_mailing_contact
        set list_id = r_mail_mass_mailing_list.id
        from mail_mass_mailing_list
        where mail_mass_mailing_list.id = mail_mass_mailing_contact.list_id
        and trim(mail_mass_mailing_list.name) not in (''test'',''clientes'', ''prospectos'', ''unsubscribe'');
    end if;        


    select into r_mail_mass_mailing_list *
    from mail_mass_mailing_list
    where trim(name) = ''unsubscribe'';
    if not found then
        Raise Exception ''No se encontro lista unsubscribe'';
    else
        update mail_mass_mailing_contact
        set list_id = r_mail_mass_mailing_list.id
        where opt_out = true;
    end if;        

    li_contador         =   0;
    li_contador_lista   =   0;

/*
                    and trim(email) not like ''%gmail%''
*/
    
    for r_mail_mass_mailing_contact in select mail_mass_mailing_contact.* 
                    from mail_mass_mailing_contact, mail_mass_mailing_list
                    where mail_mass_mailing_list.id = mail_mass_mailing_contact.list_id
                    and mail_mass_mailing_contact.opt_out = false
                    and trim(mail_mass_mailing_list.name) not in (''test'',''clientes'', ''prospectos'', ''unsubscribe'')
                    order by email
    loop
        li_contador         =   li_contador + 1;

        if li_contador = 1 then
            li_contador_lista   =   li_contador_lista + 1;
            lvc_name            =   ''news''||trim(to_char(li_contador_lista,''09''));
        end if;
        
        select into r_mail_mass_mailing_list *
        from mail_mass_mailing_list
        where trim(name) = trim(lvc_name);
        if found then
            li_list_id  =   r_mail_mass_mailing_list.id;
        else
            insert into mail_mass_mailing_list(create_uid, create_date, name,
                write_uid, write_date)
            values(6, current_timestamp, lvc_name, 6, current_timestamp);

            li_list_id  =   LastVal();
            
        end if;
          
        if li_list_id <> r_mail_mass_mailing_contact.list_id then
            update mail_mass_mailing_contact
            set list_id = li_list_id
            where id  = r_mail_mass_mailing_contact.id;
        end if;

        if Mod(li_contador, 5000) = 0 then
            li_contador_lista   =   li_contador_lista + 1;
            lvc_name            =   ''news''||trim(to_char(li_contador_lista,''09''));
        end if;

    end loop;  

    return li_contador;
end;
' language plpgsql;


-- select f_agrupar_correos()
