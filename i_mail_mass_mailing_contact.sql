



/*

update mail_mass_mailing_contact
set email = Trim(Lower(email));

select count(*) from mail_mass_mailing_contact;


insert into mail_mass_mailing_contact(opt_out,
list_id, email)
select false, 61, trim(email)
from tmp_matame2;


create table tmp_matame2 as
select trim(lower(email)) as email, count(*)
from mail_mass_mailing_contact
group by 1
having count(*) > 1
order by 1


delete from mail_mass_mailing_contact
where trim(lower(email)) in (select trim(email) from tmp_matame2)




delete from mail_mass_mailing_contact
where trim(lower(email)) in (select trim(email) from tmp_matame)



*/

