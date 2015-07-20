insert into pla_estructura(columna, concepto, listado)
select 'SALARIOS', concepto, 1 from pla_conceptos
where tipo_de_concepto = '1'
