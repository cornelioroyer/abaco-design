
drop table tmp_cias_expiradas;

create table tmp_cias_expiradas
as select * from pla_companias
where compania not in (988, 989, 990, 992);

select * from tmp_cias_expiradas
order by compania;

