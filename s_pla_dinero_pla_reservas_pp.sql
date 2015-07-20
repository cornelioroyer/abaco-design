
select f_pla_dinero_pla_reservas_pp(pla_dinero.id)
from pla_dinero, pla_periodos
where pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.compania = 1324
and pla_periodos.dia_d_pago >= '2015-01-01';




