

insert into pla_parametros_pp(parametro, descripcion)
values ('calcular_horas_extras','CALCULAR HORAS EXTRAS');

insert into pla_parametros(compania, parametro, valor)
select compania, 'calcular_horas_extras','S'
from pla_companias;

/*
insert into pla_parametros_pp(parametro, descripcion)
values ('tipo_de_hora_domingo_sehl','TIPO DE HORA PARA SALIDA EN HORAS LABORALES DE DOMINGO');
*/


/*
*/
