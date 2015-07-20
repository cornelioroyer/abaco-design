
drop function f_words_words_after_insert_update() cascade;
drop function f_words_words_before_insert() cascade;
drop function f_words_words_before_update() cascade;


create function f_words_words_before_update() returns trigger as '
declare
    r_words_opciones record;
    r_words_words record;
    r_work record;
begin

    new.updated = current_timestamp;    

    if new.puntos < 0 then
        if new.next_question >= current_date then
            new.next_question = current_date - 2;
        else            
            new.next_question = new.next_question + new.puntos;
        end if;            
    elsif new.puntos = 0 then
--            raise exception ''entre %'', current_date;
            new.next_question = current_date;
    elsif new.puntos > 0 then
        new.next_question = new.next_question + new.puntos;
    end if;
    
    if new.type_question = 1 then
        new.type_question = 2;
    else
        new.type_question = 1;
    end if;        
                    
    return new;
end;
' language plpgsql;



create function f_words_words_before_insert() returns trigger as '
declare
    r_words_opciones record;
    r_words_words record;
    r_work record;
begin

    new.next_question = current_date - 2;
    new.created = current_timestamp;
    new.updated = current_timestamp;    
    new.puntos = -2;        
    return new;
end;
' language plpgsql;



create function f_words_words_after_insert_update() returns trigger as '
declare
    r_words_opciones record;
    r_words_words record;
    r_work record;
begin

    delete from words_opciones
    where words1_id = new.id;


    insert into words_opciones(words1_id, words2_id, d_spanish, d_english) values (new.id, new.id, new.spanish, new.english);
    
    
    for r_words_words in select * from words_words 
                            where user_id = new.user_id
                            and id <> new.id
                            order by random() limit 10
    loop
        select into r_work *
        from words_words
        where id = r_words_words.id;
        if not found then
            Raise Exception ''No Existe %'', r_words_words.id;
        end if;
        
        insert into words_opciones(words1_id, words2_id, d_english, d_spanish) values (new.id, r_words_words.id, r_work.english, r_work.spanish);
    end loop;

    new.updated = current_timestamp;
        
    return new;
end;
' language plpgsql;


create trigger t_words_words_after_insert_update after insert or update on words_words
for each row execute procedure f_words_words_after_insert_update();

create trigger t_words_words_before_insert before insert on words_words
for each row execute procedure f_words_words_before_insert();

create trigger t_words_words_before_update before update on words_words
for each row execute procedure f_words_words_before_update();
