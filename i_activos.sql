
insert into activos (codigo, descripcion, descripcion_larga, marca, status, grupo, 
costo_inicial, fecha_compra, fecha_inicio, valor_rescate, activo_nuevo,
departamento, seccion, tipo_activo, compania, act_codigo)
select code_barra, descrip, modelo, trim(substring(marca from 1 for 5)),
'A', '01', 1, '2007-01-01', '2007-01-01', 1, 'N', depto, depto, tipo_activo,
'01',code_barra
from afiacti;