
drop table tmp_cias_expiradas;

create table tmp_cias_expiradas as
select compania, nombre, e_mail from pla_companias
where fecha_de_expiracion < current_date
order by 1
--limit 500
