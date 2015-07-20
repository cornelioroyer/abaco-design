/*
delete from cglsldoaux1
where compania = '01'
and year = 2005
and periodo = 7;
*/

insert into cglsldoaux1
select cglposteo.compania, cglposteo.cuenta, 
cglposteoaux1.auxiliar, 
cglposteo.year, 
cglposteo.periodo,  0, 
sum(cglposteo.debito), sum(cglposteo.credito)
where cglposteo.consecutivo = cglposteoaux1.consecutivo
and cglposteo.compania = '03'
group by 1, 2, 3, 4, 5
