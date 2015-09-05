

insert into pla_parametros_pp(parametro, descripcion)
values ('plantilla_web','PLANTILLA WEB PARA MARCACIONES');

insert into pla_parametros(compania, parametro, valor)
select compania, 'plantilla_web','N'
from pla_companias;


/*
insert into pla_parametros_pp(parametro, descripcion)
values ('tipo_de_hora_domingo_sehl','TIPO DE HORA PARA SALIDA EN HORAS LABORALES DE DOMINGO');
*/


/*
*/
