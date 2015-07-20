drop view v_pla_cheques_peachtree;

create view v_pla_cheques_peachtree as
select pla_bancos.compania, pla_cheques_1.paguese_a as vendor_name,
pla_cheques_1.no_cheque as check_number, 
Trim(to_char(pla_cheques_1.fecha_cheque, 'mm/dd/yyyy')) as fecha, 
pla_cheques_1.en_concepto_de,
pla_cuentas.cuenta as gl_account, pla_cheques_2.descripcion as description, 
Trim((select pla_cuentas.cuenta from pla_cuentas
where pla_cuentas.id = pla_bancos.id_pla_cuentas)) as cash_account,
'Yes' as detailed_payments,
(select count(*) from pla_cheques_2
where pla_cheques_2.id_pla_cheques_1 = pla_cheques_1.id) as number_of_distributions,
1 as quantity,
1 as unit_price,
pla_cheques_2.monto as amount
from pla_cheques_1, pla_cheques_2, pla_cuentas, pla_bancos
where pla_cheques_1.id = pla_cheques_2.id_pla_cheques_1
and pla_bancos.id = pla_cheques_1.id_pla_bancos
and pla_cuentas.id = pla_cheques_2.id_pla_cuentas
and pla_cheques_1.status <> 'A'
and pla_cheques_1.tipo_transaccion = 'C'
and pla_cuentas.cuenta not like '10%'
