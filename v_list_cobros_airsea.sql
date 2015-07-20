drop view v_list_cobros_airsea;
create view v_list_cobros_airsea as
select almacen.compania, clientes.nomb_cliente, cxctrx1.fecha_posteo_ajuste_cxc,
         cxctrx1.motivo_cxc, cxctrx1.cliente, cxctrx1.cheque, cxctrx1.efectivo, 0 as otro,
         cxctrx1.docm_ajuste_cxc, gralcompanias.nombre, cxctrx1.almacen
from cxctrx1, almacen, gralcompanias, cxcmotivos, clientes  
where almacen.compania = gralcompanias.compania
  and cxctrx1.almacen = almacen.almacen
  and cxctrx1.motivo_cxc = cxcmotivos.motivo_cxc
  and cxctrx1.cliente = clientes.cliente
union
select adc_cxc_1.compania, clientes.nomb_cliente, adc_cxc_1.fecha, adc_cxc_1.motivo_cxc,
    adc_cxc_1.cliente, 0,0,adc_cxc_1.monto, adc_cxc_1.documento, gralcompanias.nombre,
    adc_cxc_1.almacen
from adc_cxc_1, clientes, gralcompanias
where adc_cxc_1.cliente = clientes.cliente
and adc_cxc_1.compania = gralcompanias.compania
