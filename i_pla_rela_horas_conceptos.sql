
set search_path to planilla;

insert into pla_rela_horas_conceptos(concepto, tipo_de_hora)
select concepto, '39' from pla_rela_horas_conceptos
where tipo_de_hora = '75'
