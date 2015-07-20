delete from pla_cheques_1
where tipo_transaccion = 'SC';

select f_pla_crear_cheques_acreedores(pla_dinero.id)
from pla_dinero, pla_periodos, pla_deducciones, pla_retenciones
where pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.id = pla_deducciones.id_pla_dinero
and pla_deducciones.id_pla_retenciones = pla_retenciones.id
and pla_retenciones.acreedor = '0021'
and pla_periodos.dia_d_pago >= '2012-03-01'
and pla_periodos.compania = 1043
