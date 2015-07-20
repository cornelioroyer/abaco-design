

update pla_cheques_1
set fecha_cheque = '2014-04-30'
from pla_bancos
where pla_bancos.id = pla_cheques_1.id_pla_bancos
and pla_bancos.compania = 1043
and tipo_transaccion = 'SC'
