

select * from pla_cheques_1, pla_bancos
where pla_cheques_1.id_pla_bancos = pla_bancos.id
and pla_bancos.compania = 1043
and pla_cheques_1.tipo_transaccion = 'SC';



update pla_cheques_1
set fecha_solicitud = '2014-12-30', fecha_cheque = '2014-12-30'
from pla_bancos
where pla_cheques_1.id_pla_bancos = pla_bancos.id
and pla_bancos.compania = 1043
and pla_cheques_1.tipo_transaccion = 'SC';


