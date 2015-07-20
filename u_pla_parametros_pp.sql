
/*
insert into pla_parametros_pp(parametro, descripcion)
values ('pagar_salario_en_liquidacion', 'PAGA SALARIO EN LIQUIDACION');
*/

update pla_parametros_pp
set descripcion = 'TIPO DE HORA DE DOMINGO PARA SALIDA EN HORAS LABORABLES'
where trim(parametro) = 'tipo_de_hora_domingo_sehl';



