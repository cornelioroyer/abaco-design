
drop function f_caja_default(char(2)) cascade;
--drop view v_cxcdocm_cxc;

create function f_caja_default(char(2))returns char(3) as '
declare
    as_almacen alias for $1;
    r_fac_cajas record;
begin
    for r_fac_cajas in select * from fac_cajas where almacen = as_almacen
                        order by caja
    loop
        return r_fac_cajas.caja;
    end loop;
    
    return '''';
end;
' language plpgsql;    


create view v_cxcdocm_cxc as
select cxc_recibo1.almacen, cxc_recibo1.caja, cxc_recibo1.cliente, cxc_recibo1.documento, cxc_recibo1.documento as docmto_aplicar,
cxc_recibo1.motivo_cxc, cxc_recibo1.documento as docmto_ref, cxc_recibo1.motivo_cxc as motivo_ref, cxc_recibo1.fecha as fecha_posteo,
cxc_recibo1.fecha as fecha_docmto, cxc_recibo1.fecha as fecha_vmto, cxc_recibo1.observacion as obs_docmto, cxc_recibo1.referencia, 'CXC' as aplicacion_origen,
(cxc_recibo1.efectivo + cxc_recibo1.cheque + cxc_recibo1.otro) as monto
from cxc_recibo1, cxc_recibo3, clientes, cglcuentas
where cxc_recibo1.almacen = cxc_recibo3.almacen
and cxc_recibo1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'B'
and cglcuentas.naturaleza = 1
and cxc_recibo1.consecutivo = cxc_recibo3.consecutivo
and cxc_recibo1.status <> 'A'
and not exists 
(select * from cxc_recibo2
where cxc_recibo2.almacen = cxc_recibo1.almacen
and cxc_recibo2.caja = cxc_recibo1.caja
and cxc_recibo2.consecutivo = cxc_recibo1.consecutivo
and cxc_recibo2.monto_aplicar <> 0)
union
select cxc_recibo2.almacen_aplicar, cxc_recibo2.caja_aplicar, cxc_recibo1.cliente, cxc_recibo1.documento, cxc_recibo2.documento_aplicar,
cxc_recibo1.motivo_cxc, cxc_recibo2.documento_aplicar, cxc_recibo2.motivo_aplicar, cxc_recibo1.fecha,
cxc_recibo1.fecha, cxc_recibo1.fecha, cxc_recibo1.observacion, cxc_recibo1.referencia, 'CXC', 
cxc_recibo2.monto_aplicar
from cxc_recibo1, cxc_recibo2, clientes, cglcuentas
where cxc_recibo1.almacen = cxc_recibo2.almacen
and cxc_recibo1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'B'
and cglcuentas.naturaleza = 1
and cxc_recibo1.consecutivo = cxc_recibo2.consecutivo
and cxc_recibo2.monto_aplicar <> 0
and cxc_recibo1.status <> 'A'
and exists
    (select * from cxcdocm
    where cxcdocm.almacen = cxc_recibo2.almacen_aplicar
    and cxcdocm.cliente = cxc_recibo1.cliente
    and cxcdocm.documento = cxc_recibo2.documento_aplicar
    and cxcdocm.caja = cxc_recibo2.caja_aplicar
    and cxcdocm.docmto_aplicar = cxc_recibo2.documento_aplicar
    and cxcdocm.motivo_cxc = cxc_recibo2.motivo_aplicar)
union    
select almacen, 
f_caja_default(cxc_saldos_iniciales.almacen),
cliente, documento, documento, motivo_cxc, documento, motivo_cxc,
fecha, fecha, fecha, null, null, 'CXC', 
monto
from cxc_saldos_iniciales
union
select cxcfact1.almacen, 
(select caja from fac_cajas 
where fac_cajas.almacen = cxcfact1.almacen and status = 'A'),
cxcfact1.cliente, cxcfact1.no_factura,
cxcfact1.no_factura, cxcfact1.motivo_cxc, cxcfact1.no_factura, cxcfact1.motivo_cxc,
cxcfact1.fecha_posteo_fact, cxcfact1.fecha_posteo_fact, cxcfact1.fecha_vence_fact,
trim(cxcfact1.obs_fact), null, 'CXC', 
-sum(cxcfact2.monto * rubros_fact_cxc.signo_rubro_fact_cxc)
from cxcfact1, cxcfact2, rubros_fact_cxc 
where cxcfact1.almacen = cxcfact2.almacen
and cxcfact1.no_factura = cxcfact2.no_factura
and cxcfact2.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
group by cxcfact1.aplicacion, 2, cxcfact1.almacen, cxcfact1.cliente, cxcfact1.no_factura, 
cxcfact1.motivo_cxc, cxcfact1.fecha_posteo_fact, cxcfact1.fecha_vence_fact,
cxcfact1.obs_fact
union
select cxctrx1.almacen, cxctrx1.caja, cxctrx1.cliente, 
cxctrx1.docm_ajuste_cxc, cxctrx1.docm_ajuste_cxc, cxctrx1.motivo_cxc, 
cxctrx1.docm_ajuste_cxc, cxctrx1.motivo_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, cxctrx1.fecha_posteo_ajuste_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, trim(cxctrx1.obs_ajuste_cxc), 
trim(cxctrx1.referencia), 'CXC',
sum(cxctrx1.cheque + cxctrx1.efectivo)
from cxctrx1, clientes, cglcuentas
where cxctrx1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'B'
and cglcuentas.naturaleza = 1
and not exists
(select * from cxctrx2
where cxctrx2.almacen = cxctrx1.almacen
and cxctrx2.sec_ajuste_cxc = cxctrx1.sec_ajuste_cxc
and cxctrx2.caja = cxctrx1.caja
and cxctrx2.monto <> 0)
group by cxctrx1.almacen, cxctrx1.caja, cxctrx1.cliente, cxctrx1.docm_ajuste_cxc, 
cxctrx1.motivo_cxc, cxctrx1.fecha_posteo_ajuste_cxc, cxctrx1.referencia, cxctrx1.obs_ajuste_cxc
union
select cxctrx1.almacen, cxctrx2.caja_aplicar, cxctrx1.cliente, 
cxctrx1.docm_ajuste_cxc, cxctrx2.aplicar_a, cxctrx1.motivo_cxc, 
cxctrx2.aplicar_a, cxctrx2.motivo_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, cxctrx1.fecha_posteo_ajuste_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, 
trim(cxctrx1.obs_ajuste_cxc), trim(cxctrx1.referencia),
'CXC', 
sum(cxctrx2.monto)
from cxctrx1, cxctrx2, cxcdocm, clientes, cglcuentas
where cxctrx1.sec_ajuste_cxc = cxctrx2.sec_ajuste_cxc
and cxctrx1.caja = cxctrx2.caja
and cxctrx1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'B'
and cglcuentas.naturaleza = 1
and cxctrx1.almacen = cxctrx2.almacen
and cxcdocm.almacen = cxctrx2.almacen
and cxcdocm.cliente = cxctrx1.cliente
and cxcdocm.documento = cxctrx2.aplicar_a
and cxcdocm.docmto_aplicar = cxctrx2.aplicar_a
and cxcdocm.caja = cxctrx2.caja_aplicar
and cxcdocm.motivo_cxc = cxctrx2.motivo_cxc
and cxctrx2.monto <> 0
group by cxctrx1.almacen, cxctrx1.caja, cxctrx2.caja_aplicar, cxctrx1.cliente, cxctrx1.docm_ajuste_cxc, cxctrx2.aplicar_a, 
cxctrx1.motivo_cxc, cxctrx2.motivo_cxc, cxctrx1.fecha_posteo_ajuste_cxc,
cxctrx1.obs_ajuste_cxc, cxctrx1.referencia
union
select adc_cxc_1.almacen, 
f_caja_default(adc_cxc_1.almacen),
adc_manifiesto.from_agent, trim(adc_cxc_1.documento),
trim(adc_cxc_1.documento), trim(adc_cxc_1.motivo_cxc),
trim(adc_cxc_1.documento), trim(adc_cxc_1.motivo_cxc),
adc_cxc_1.fecha, adc_cxc_1.fecha, adc_cxc_1.fecha, trim(adc_cxc_1.observacion),
trim(adc_manifiesto.no_referencia), 'CXC', 
adc_cxc_1.monto
from adc_cxc_1, adc_manifiesto, fact_referencias
where adc_cxc_1.compania = adc_manifiesto.compania
and adc_cxc_1.consecutivo = adc_manifiesto.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and fact_referencias.tipo = 'I'
and adc_cxc_1.cliente is null
union
select adc_cxc_1.almacen, 
f_caja_default(adc_cxc_1.almacen),
adc_manifiesto.to_agent, trim(adc_cxc_1.documento),
trim(adc_cxc_1.documento), trim(adc_cxc_1.motivo_cxc),
trim(adc_cxc_1.documento), trim(adc_cxc_1.motivo_cxc),
adc_cxc_1.fecha, adc_cxc_1.fecha, adc_cxc_1.fecha, trim(adc_cxc_1.observacion),
trim(adc_manifiesto.no_referencia), 'CXC', 
adc_cxc_1.monto
from adc_cxc_1, adc_manifiesto, fact_referencias
where adc_cxc_1.compania = adc_manifiesto.compania
and adc_cxc_1.consecutivo = adc_manifiesto.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and fact_referencias.tipo <> 'I'
and adc_cxc_1.cliente is null
union
select adc_cxc_1.almacen, 
f_caja_default(adc_cxc_1.almacen),
adc_cxc_1.cliente, trim(adc_cxc_1.documento),
trim(adc_cxc_1.documento), trim(adc_cxc_1.motivo_cxc),
trim(adc_cxc_1.documento), trim(adc_cxc_1.motivo_cxc),
adc_cxc_1.fecha, adc_cxc_1.fecha, adc_cxc_1.fecha, trim(adc_cxc_1.observacion),
trim(adc_manifiesto.no_referencia), 'CXC', 
adc_cxc_1.monto
from adc_cxc_1, adc_manifiesto, fact_referencias
where adc_cxc_1.compania = adc_manifiesto.compania
and adc_cxc_1.consecutivo = adc_manifiesto.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_cxc_1.cliente is not null;



