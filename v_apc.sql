drop view v_apc_clientes;
drop view v_apc_refere;

create view v_apc_refere as
select f_id(clientes.tipo_de_persona, clientes.id, 'IDENT1') as ident1,
f_id(clientes.tipo_de_persona, clientes.id, 'IDENT2') as ident2,
f_id(clientes.tipo_de_persona, clientes.id, 'IDENT3') as ident3,
f_id(clientes.tipo_de_persona, clientes.id, 'IDENT4') as ident4,
case when clientes.tipo_de_persona = '2' then '2' else '1' end as tipo_clie,
'E' as cod_grupo_econ,
'07' as tipo_asoc,
'080006' as ident_asoc,
trim(clientes.cliente) as cuenta,
'DM080006' as user_id,
'P30' as tipo_forma_pago,
'LCR' as tipo_relacion,
trim(to_char(clientes.fecha_apertura,'mm/dd/yyyy')) as fec_inicio_rel,
'' as fec_fre,
clientes.limite_credito as monto_original,
f_apc(clientes.cliente, 'SALDO', '2010-11-30') as saldo_actual,
0 as num_pagos,
0 as importe_pago,
f_apc(clientes.cliente, 'FECHA_ULTIMO_PAGO', '2010-11-30') as fec_ultimo_pago,
f_apc(clientes.cliente, 'MONTO_ULTIMO_PAGO', '2010-11-30') as monto_ultimo_pago,
'' as fec_liq,
0 as tipo_comporta,
1 as estatus_ref,
f_apc(clientes.cliente, 'NUMERO_DIAS_ATRASO', '2010-11-30') as num_dias_atraso,
'' as monto_codificado,
'' as tipo_cifra,
'' as observacion,
'2010-11-30' as fec_corte,
trim(clientes.nomb_cliente) as nom_fiador,
trim(clientes.id) as ced_fiador
from clientes
where f_apc(clientes.cliente, 'SALDO', '2010-11-30') > 0;

create view v_apc_clientes as
select f_id(clientes.tipo_de_persona, clientes.id, 'IDENT1') as ident1,
f_id(clientes.tipo_de_persona, clientes.id, 'IDENT2') as ident2,
f_id(clientes.tipo_de_persona, clientes.id, 'IDENT3') as ident3,
f_id(clientes.tipo_de_persona, clientes.id, 'IDENT4') as ident4,
case when clientes.tipo_de_persona = '2' then '2' else '1' end as tipo_clie,
f_get_nombre(cliente, 'APELLIDO_PATERNO') as apel_pater,
f_get_nombre(cliente, 'APELLIDO_MATERNO') as apel_mater,
'' as apel_casad,
f_get_nombre(cliente, 'PRIMER_NOMBRE') as primer_nom,
f_get_nombre(cliente, 'SEGUNDO_NOMBRE') as segundo_no,
'1' as sexo_clie,
'' as seguro_soc,
'' as estado_civil,
f_get_nombre(cliente, 'NOMBRE_LEGAL') as nom_legal,
'' as nomb_comerc, trim(clientes.direccion1) as direc_clie, 
'' as fec_nac_in,
clientes.tel1_cliente as telef_casa,
clientes.fax_cliente as telef_fax1,
clientes.tel2_cliente as telef_fax2,
'' as telef_otro, 
'' as telef_celu,
'' as lug_trab,
'' as direc_trab,
'' as position_t,
0 as ingreso_me,
'' as fac_ingres, '' as telef_ofic, '' as telef_ofic2, '' as nom_conyug,
'' as apel_conyug, '' as ced_conyug, '' as nom_padre, '' as apel_padre,
'' as nom_madre, '' as ape_madre
from clientes, gral_forma_de_pago
where clientes.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias > 0
and f_apc(clientes.cliente, 'SALDO', '2010-11-30') > 0;
