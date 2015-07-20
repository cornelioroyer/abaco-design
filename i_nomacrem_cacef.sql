update nomacrem
set status = 'E'
where cod_acreedores = 'CACEFP';


insert into nomacrem(compania, codigo_empleado, cod_concepto_planilla, numero_documento,
cod_acreedores, monto_original_deuda, letras_a_pagar,
fecha_inidescto, status, hacer_cheque, incluir_deduc_carta_trabajo,deduccion_aplica_diciembre,
usuario,fecha_captura,tipo_descuento)
select '03', codigo_empleado, '113','2012','CACEFP', 0, 0, '2012-01-01', 'A','S',
'S','S',current_user, current_timestamp,'M'
from rhuempl
where status in ('A','V')

