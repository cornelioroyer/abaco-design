rollback work;
begin work;
insert into pla_retenciones (compania,
codigo_empleado, acreedor, concepto, numero_documento,
descripcion_descuento, 
monto_original_deuda, letras_a_pagar,
fecha_inidescto, hacer_cheque, incluir_deduc_carta_trabajo,
aplica_diciembre, tipo_descuento, status)
select compania, codigo_empleado, '0006', '131',
'2010', 'SEGURO DE VIDA COLECTIVO', 0, 0,
'2010-05-01', 'S', 'S', 'S', 'M', 'A' from pla_empleados
where compania = 838
and status in ('A','V');

insert into pla_retener (id_pla_retenciones, periodo, monto)
select id, 1, 2.13
from pla_retenciones 
where compania = 838
and acreedor = '0006';

insert into pla_retener (id_pla_retenciones, periodo, monto)
select id, 2, 2.13
from pla_retenciones 
where compania = 838
and acreedor = '0006';

commit work;
