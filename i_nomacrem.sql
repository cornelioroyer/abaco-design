delete from nomacrem;

insert into nomacrem(compania, codigo_empleado, cod_concepto_planilla, numero_documento,
cod_acreedores, monto_original_deuda, letras_a_pagar,
fecha_inidescto, status, hacer_cheque, incluir_deduc_carta_trabajo,deduccion_aplica_diciembre,
usuario,fecha_captura,tipo_descuento)
select '03', codigo_empleado, '113',id,cod_acredores, 0, 0, '2008-01-01', 'A','S',
'S','S',current_user, current_timestamp,'M'
from tmp_retensiones
where codigo_empleado in (select codigo_empleado from rhuempl)
and monto_x_periodo > 0;

insert into nomdedu(compania, codigo_empleado, numero_documento,
cod_concepto_planilla, periodo, monto)
select '03', codigo_empleado, id,'113',1,monto_x_periodo
from tmp_retensiones
where codigo_empleado in (select codigo_empleado from rhuempl)
and monto_x_periodo > 0;

insert into nomdedu(compania, codigo_empleado, numero_documento,
cod_concepto_planilla, periodo, monto)
select '03', codigo_empleado, id,'113',2,monto_x_periodo
from tmp_retensiones
where codigo_empleado in (select codigo_empleado from rhuempl)
and monto_x_periodo > 0;