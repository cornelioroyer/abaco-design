select pla_horas.id_marcaciones, pla_horas.tipo_de_hora, pla_horas.minutos, pla_horas_detalle.* from pla_horas_detalle, pla_horas
where pla_horas_detalle.id_pla_horas = pla_horas.id
and pla_horas.id_marcaciones = 2098824
order by pla_horas_detalle.desde
