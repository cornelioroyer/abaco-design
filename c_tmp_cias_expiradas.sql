
drop table tmp_cias_expiradas;

create table tmp_cias_expiradas
as select * from pla_companias
where compania = 745;

select * from tmp_cias_expiradas;

