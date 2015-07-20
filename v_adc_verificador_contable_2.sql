

drop view v_adc_verificador_contable_2 cascade;



begin work;
create view v_adc_verificador_contable_2 as
select 'COSTOS' as rubro, rela_adc_master_cglposteo.compania, 
rela_adc_master_cglposteo.consecutivo as consecutivo, 
cglposteo.consecutivo as cgl_consecutivo,
cglposteo.fecha_comprobante as fecha,
Anio(cglposteo.fecha_comprobante) as anio,
Mes(cglposteo.fecha_comprobante) as mes,
trim(fact_referencias.descripcion) as referencia,
trim(cglposteo.cuenta) as cuenta,
(case when trim(cglposteo.cuenta) <> '4614' and trim(cglposteo.cuenta) <> '4616' then -sum(cglposteo.debito-cglposteo.credito) else 0 end) as monto,
(case when trim(cglposteo.cuenta) = '4614' or trim(cglposteo.cuenta) = '4616' then -sum(cglposteo.debito-cglposteo.credito) else 0 end) as manejo
from rela_adc_master_cglposteo, cglposteo, adc_manifiesto, fact_referencias, cglcuentas
where fact_referencias.referencia = adc_manifiesto.referencia
and adc_manifiesto.compania = rela_adc_master_cglposteo.compania
and adc_manifiesto.consecutivo = rela_adc_master_cglposteo.consecutivo
and rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo
and cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9
union
select 'CUENTAS POR COBRAR', rela_adc_cxc_1_cglposteo.compania, 
rela_adc_cxc_1_cglposteo.consecutivo, 
cglposteo.consecutivo,
cglposteo.fecha_comprobante as fecha,
Anio(cglposteo.fecha_comprobante) as anio,
Mes(cglposteo.fecha_comprobante) as mes,
trim(fact_referencias.descripcion) as referencia,
trim(cglposteo.cuenta) as cuenta, 
(case when trim(cglposteo.cuenta) <> '4614' and trim(cglposteo.cuenta) <> '4616' then -sum(cglposteo.debito-cglposteo.credito) else 0 end) as monto,
(case when trim(cglposteo.cuenta) = '4614' or trim(cglposteo.cuenta) = '4616' then -sum(cglposteo.debito-cglposteo.credito) else 0 end) as manejo
from rela_adc_cxc_1_cglposteo, cglposteo, adc_manifiesto, fact_referencias, cglcuentas
where adc_manifiesto.compania = rela_adc_cxc_1_cglposteo.compania
and adc_manifiesto.consecutivo = rela_adc_cxc_1_cglposteo.consecutivo
and rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9
union
select 'CUENTAS POR PAGAR', rela_adc_cxp_1_cglposteo.compania, 
rela_adc_cxp_1_cglposteo.consecutivo, 
cglposteo.consecutivo,
cglposteo.fecha_comprobante,
Anio(cglposteo.fecha_comprobante) as anio,
Mes(cglposteo.fecha_comprobante) as mes,
trim(fact_referencias.descripcion) as referencia,
cglposteo.cuenta, 
(case when trim(cglposteo.cuenta) <> '4614' and trim(cglposteo.cuenta) <> '4616' then -sum(cglposteo.debito-cglposteo.credito) else 0 end) as monto,
(case when trim(cglposteo.cuenta) = '4614' or trim(cglposteo.cuenta) = '4616' then -sum(cglposteo.debito-cglposteo.credito) else 0 end) as manejo
from rela_adc_cxp_1_cglposteo, cglposteo, adc_manifiesto, fact_referencias, cglcuentas
where adc_manifiesto.compania = rela_adc_cxp_1_cglposteo.compania
and adc_manifiesto.consecutivo = rela_adc_cxp_1_cglposteo.consecutivo
and rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9
union
select 'NOTAS DEBITO', cglposteo.compania, adc_notas_debito_1.consecutivo,
cglposteo.consecutivo,
cglposteo.fecha_comprobante, Anio(cglposteo.fecha_comprobante),
Mes(cglposteo.fecha_comprobante),
trim(fact_referencias.descripcion),
cglposteo.cuenta,
(case when trim(cglposteo.cuenta) <> '4614' and trim(cglposteo.cuenta) <> '4616' then -sum(cglposteo.debito-cglposteo.credito) else 0 end) as monto,
(case when trim(cglposteo.cuenta) = '4614' or trim(cglposteo.cuenta) = '4616' then -sum(cglposteo.debito-cglposteo.credito) else 0 end) as manejo
from adc_notas_debito_1, adc_manifiesto, fact_referencias, cglcuentas,
rela_factura1_cglposteo, cglposteo
where adc_notas_debito_1.compania = adc_manifiesto.compania
and adc_notas_debito_1.consecutivo = adc_manifiesto.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
and adc_notas_debito_1.almacen = rela_factura1_cglposteo.almacen
and adc_notas_debito_1.caja = rela_factura1_cglposteo.caja
and adc_notas_debito_1.tipo = rela_factura1_cglposteo.tipo
and adc_notas_debito_1.num_documento = rela_factura1_cglposteo.num_documento
and rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
group by 1, 2, 3, 4, 5, 6, 7, 8, 9
union
select 'FACTURACION', cglposteo.compania, 
To_Number(Trim(f_factura1(rela_factura1_cglposteo.almacen,
rela_factura1_cglposteo.tipo,
rela_factura1_cglposteo.num_documento,
rela_factura1_cglposteo.caja, 'CONSECUTIVO')), '9999999'),
cglposteo.consecutivo,
cglposteo.fecha_comprobante as fecha,
Anio(cglposteo.fecha_comprobante) as anio,
Mes(cglposteo.fecha_comprobante) as mes,
Trim(f_factura1(rela_factura1_cglposteo.almacen,
rela_factura1_cglposteo.tipo,
rela_factura1_cglposteo.num_documento,
rela_factura1_cglposteo.caja, 'REFERENCIA')),
cglposteo.cuenta, 
(case when trim(cglposteo.cuenta) <> '4614' and trim(cglposteo.cuenta) <> '4616' then -sum(cglposteo.debito-cglposteo.credito) else 0 end) as monto,
(case when trim(cglposteo.cuenta) = '4614' or trim(cglposteo.cuenta) = '4616' then -sum(cglposteo.debito-cglposteo.credito) else 0 end) as manejo
from rela_factura1_cglposteo, cglposteo, cglcuentas
where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
and cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
and exists
(select * from adc_house_factura1
where adc_house_factura1.almacen = rela_factura1_cglposteo.almacen
and adc_house_factura1.tipo = rela_factura1_cglposteo.tipo
and adc_house_factura1.caja = rela_factura1_cglposteo.caja
and adc_house_factura1.num_documento = rela_factura1_cglposteo.num_documento)
group by 1, 2, 3, 4, 5, 6, 7, 8, 9;
commit work;






/*
select 'FACTURAS FLETE', cglposteo.compania, adc_manifiesto.consecutivo, 
cglposteo.fecha_comprobante,
Anio(cglposteo.fecha_comprobante) as anio,
Mes(cglposteo.fecha_comprobante) as mes,
trim(fact_referencias.descripcion) as referencia,
cglposteo.cuenta, 
-sum(cglposteo.debito-cglposteo.credito)/count(*)
from adc_house_factura1, rela_factura1_cglposteo, 
cglposteo, adc_manifiesto, fact_referencias, cglcuentas
where fact_referencias.referencia = adc_manifiesto.referencia
and adc_manifiesto.compania = adc_house_factura1.compania
and adc_manifiesto.consecutivo = adc_house_factura1.consecutivo
and rela_factura1_cglposteo.almacen = adc_house_factura1.almacen
and rela_factura1_cglposteo.tipo = adc_house_factura1.tipo
and rela_factura1_cglposteo.num_documento = adc_house_factura1.num_documento
and rela_factura1_cglposteo.caja = adc_house_factura1.caja
and cglposteo.consecutivo = rela_factura1_cglposteo.consecutivo
and cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
and adc_house_factura1.linea_manejo is null
group by 1, 2, 3, 4, 5, 6, 7, 8
union
select 'FACTURAS MANEJO', cglposteo.compania, adc_manifiesto.consecutivo, 
cglposteo.fecha_comprobante,
Anio(cglposteo.fecha_comprobante) as anio,
Mes(cglposteo.fecha_comprobante) as mes,
trim(fact_referencias.descripcion) as referencia,
cglposteo.cuenta, 
-sum(cglposteo.debito-cglposteo.credito)/count(*)
from adc_house_factura1, rela_factura1_cglposteo, 
cglposteo, adc_manifiesto, fact_referencias, cglcuentas
where fact_referencias.referencia = adc_manifiesto.referencia
and adc_manifiesto.compania = adc_house_factura1.compania
and adc_manifiesto.consecutivo = adc_house_factura1.consecutivo
and rela_factura1_cglposteo.almacen = adc_house_factura1.almacen
and rela_factura1_cglposteo.tipo = adc_house_factura1.tipo
and rela_factura1_cglposteo.num_documento = adc_house_factura1.num_documento
and rela_factura1_cglposteo.caja = adc_house_factura1.caja
and cglposteo.consecutivo = rela_factura1_cglposteo.consecutivo
and cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
and adc_house_factura1.linea_manejo is not null
group by 1, 2, 3, 4, 5, 6, 7, 8
*/
