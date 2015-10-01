

insert into pla_parametros_pp(parametro, descripcion)
values ('utiliza_reloj_zk','UTILIZA RELOJ ZK');

insert into pla_parametros(compania, parametro, valor)
select compania, 'utiliza_reloj_zk','N'
from pla_companias;


/*
insert into pla_parametros_pp(parametro, descripcion)
values ('tipo_de_hora_domingo_sehl','TIPO DE HORA PARA SALIDA EN HORAS LABORALES DE DOMINGO');
*/


/*
*/
