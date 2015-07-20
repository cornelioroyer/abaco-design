insert into activos (compania, codigo, descripcion, marca, status, grupo, costo_inicial, fecha_compra, fecha_inicio, valor_rescate,
  activo_nuevo, departamento, seccion, tipo_activo, act_codigo)
select '03', codigo, descripcion, 'NO', status, '01', costo, to_date(fecha_compra, 'dd-mm-yyyy'), 
  to_date(fecha_compra, 'dd-mm-yyyy'), valor_rescate, 'S', 'NO', 'NO', tipo_activo, codigo from aficatalogo;


