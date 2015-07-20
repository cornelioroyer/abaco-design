
drop function f_cargar_verbos() cascade;


create function f_cargar_verbos() returns integer as '
declare
    r_tmp_verbs2 record;
    r_words_words record;
begin
 
    for r_tmp_verbs2 in select * from tmp_verbs2
                        order by spanish
    loop
        select into r_words_words *
        from words_words
        where trim(spanish) = trim(r_tmp_verbs2.spanish);
        if found then
            update words_words
            set english = trim(r_tmp_verbs2.ipp)
            where id = r_words_words.id;
        else            
            insert into words_words(english, spanish, user_id, mistakes)
            values(trim(r_tmp_verbs2.ipp), trim(r_tmp_verbs2.spanish), 1, 0);
        end if;            
    end loop;
    
    
    return 1;
end;
' language plpgsql;
