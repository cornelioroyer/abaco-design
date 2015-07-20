
drop function f_mail_mass_mailing_contact_before_insert() cascade;
drop function f_mail_mass_mailing_list_before_insert() cascade;

create function f_mail_mass_mailing_list_before_insert() returns trigger as '
declare
    r_mail_mass_mailing_list record;
begin
    select into r_mail_mass_mailing_list *
    from mail_mass_mailing_list
    where trim(name) = trim(new.name);
    if found then
        RAISE ''Lista % ya Existe...Verifique'', new.name USING ERRCODE = ''unique_violation'';        
    end if;
    
    
    return new;
end;
' language plpgsql;



create function f_mail_mass_mailing_contact_before_insert() returns trigger as '
declare
    r_mail_mass_mailing_contact record;
begin

    new.email = Lower(Trim(new.email));

    select into r_mail_mass_mailing_contact *
    from mail_mass_mailing_contact
    where trim(email) = trim(new.email);
    if found then
--        Raise Exception ''Email % ya existe...Verifique'', new.email;    
--        Raise ''Email % ya existe...Verifique'', new.email;    
--        RAISE unique_violation USING MESSAGE = ''Email '' | new.email | ''ya Existe...Verifique '';
        RAISE ''Email %    ya Existe...Verifique'', new.email USING ERRCODE = ''unique_violation'';        
    end if;


    
    return new;
end;
' language plpgsql;

create trigger t_mail_mass_mailing_contact_before_insert 
before insert on mail_mass_mailing_contact
for each row execute procedure f_mail_mass_mailing_contact_before_insert();

create trigger t_mail_mass_mailing_list_before_insert 
before insert on mail_mass_mailing_list
for each row execute procedure f_mail_mass_mailing_list_before_insert();

