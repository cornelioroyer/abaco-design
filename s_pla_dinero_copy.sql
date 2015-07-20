


select pla_dinero.* 
from pla_dinero, pla_periodos
where pla_periodos.id = pla_dinero.id_periodos
and pla_periodos.compania = 1289
and pla_periodos.year = 2015
and pla_dinero.codigo_empleado = '0008'
and pla_periodos.numero_planilla = 2
and pla_periodos.tipo_de_planilla = '3'
and pla_dinero.tipo_de_calculo = '7'




/*
update pla_dinero
set id_pla_cheques_1 = null
where id_pla_cheques_1 is not null
and compania = 1261
and id_pla_cheques_1 not in (select id from pla_cheques_1);



insert into pla_dinero(id_periodos, id_pla_cheques_1, id_pla_vacaciones,
id_pla_liquidacion, id_pla_departamentos, id_pla_proyectos, id_pla_cuentas,
id_pla_dinero_archivo, compania, codigo_empleado, tipo_de_calculo, concepto, forma_de_registro,
descripcion, mes, monto)
select id_periodos, id_pla_cheques_1, id_pla_vacaciones,
id_pla_liquidacion, id_pla_departamentos, id_pla_proyectos, id_pla_cuentas,
id_pla_dinero_archivo, compania, codigo_empleado, tipo_de_calculo, concepto, forma_de_registro,
descripcion, mes, monto from tmp_pla_dinero;




copy (select pla_dinero.*
from pla_periodos, pla_dinero
where pla_periodos.id = pla_dinero.id_periodos
and pla_periodos.compania = 1261
and pla_periodos.year = 2014
and pla_periodos.numero_planilla = 13) to '/tmp/pla_dinero.out'

delete from tmp_pla_dinero;
copy tmp_pla_dinero from '/tmp/pla_dinero.out';



rollback work;

commit work;

--drop function f_pla_dinero_before_delete() cascade;
--drop function f_pla_dinero_before_insert() cascade;

delete from pla_dinero
using pla_periodos
where pla_periodos.id = pla_dinero.id_periodos
and pla_periodos.compania = 1261
and pla_periodos.year = 2014
and pla_periodos.numero_planilla = 13;



commit work;

select pla_dinero.* from pla_dinero, pla_periodos
where pla_periodos.id = pla_dinero.id_periodos
and pla_periodos.compania = 1261
and pla_periodos.year = 2014
and pla_periodos.numero_planilla = 13;



select pla_dinero.* from pla_dinero, pla_periodos
where pla_periodos.id = pla_dinero.id_periodos
and pla_periodos.compania = 1261
and pla_periodos.year = 2014
and pla_periodos.numero_planilla = 13;


copy (select pla_dinero.*
from pla_periodos, pla_dinero
where pla_periodos.id = pla_dinero.id_periodos
and pla_periodos.compania = 1261
and pla_periodos.year = 2014
and pla_periodos.numero_planilla = 13) to '/tmp/pla_dinero.out'

*/
