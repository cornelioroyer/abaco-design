
drop table tmp_cias_expiradas;

create table tmp_cias_expiradas as
select compania, nombre, e_mail from pla_companias
where compania in (1142, 745, 749, 754, 880, 941, 960, 1043, 1046, 1075, 1077, 1140 );

select * from tmp_cias_expiradas;

/*

create table tmp_cias_expiradas as
select compania, nombre, e_mail from pla_companias
where fecha_de_expiracion < current_date
order by 1
limit 2450;

*/

