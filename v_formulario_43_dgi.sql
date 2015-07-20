drop view v_formulario_43_dgi;
create view v_formulario_43_dgi as
select cxpfact1.compania, proveedores.tipo_de_persona, trim(proveedores.id_proveedor) as ruc,
Trim(proveedores.dv_proveedor) as dv, 
trim(proveedores.nomb_proveedor) as nomb_proveedor,
trim(cxpfact1.fact_proveedor) as fact_proveedor, cxpfact1.fecha_posteo_fact_cxp as fecha, 
proveedores.concepto, 
proveedores.tipo_de_compra, 
f_cxpfact2(cxpfact1.compania, cxpfact1.proveedor, cxpfact1.fact_proveedor, 'MONTO') as monto,
f_cxpfact2(cxpfact1.compania, cxpfact1.proveedor, cxpfact1.fact_proveedor, 'ITBMS') as itbms
from cxpfact1, proveedores, gralcompanias
where cxpfact1.proveedor = proveedores.proveedor
and cxpfact1.compania = gralcompanias.compania
and cxpfact1.fecha_posteo_fact_cxp >= '2012-01-01'
union
select cxpajuste1.compania, proveedores.tipo_de_persona, trim(proveedores.id_proveedor) as ruc,
Trim(proveedores.dv_proveedor) as dv, 
trim(proveedores.nomb_proveedor) as nomb_proveedor,
trim(cxpajuste1.docm_ajuste_cxp) as fact_proveedor, cxpajuste1.fecha_posteo_ajuste_cxp as fecha, 
proveedores.concepto, 
proveedores.tipo_de_compra, 
f_cxpajuste1(cxpajuste1.compania, cxpajuste1.sec_ajuste_cxp, 'MONTO'),
f_cxpajuste1(cxpajuste1.compania, cxpajuste1.sec_ajuste_cxp, 'ITBMS')
from proveedores, cxpajuste1, gralcompanias
where cxpajuste1.proveedor = proveedores.proveedor
and cxpajuste1.compania = gralcompanias.compania
union
select almacen.compania, clientes.tipo_de_persona, trim(clientes.id),
trim(clientes.dv), trim(clientes.nomb_cliente),
trim(to_char(factura1.num_documento, '9999999999')),
factura1.fecha_factura,
clientes.concepto,
clientes.tipo_de_compra,
-f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento, 'DA'),
0
from factura1, clientes, almacen
where factura1.cliente = clientes.cliente
and factura1.almacen = almacen.almacen
and factura1.tipo = 'DA'
and factura1.fecha_factura >= '2012-01-01'
union
select cajas.compania, cglauxiliares.tipo_persona, Trim(cglauxiliares.id),
Trim(cglauxiliares.dv), Trim(cglauxiliares.nombre),
trim(to_char(caja_trx1.numero_trx, '999999')),
caja_trx1.fecha_posteo, cglauxiliares.concepto, cglauxiliares.tipo_de_compra,  
f_caja_trx2(caja_trx2.caja, caja_trx2.numero_trx, caja_trx2.linea, 'MONTO'),
f_caja_trx2(caja_trx2.caja, caja_trx2.numero_trx, caja_trx2.linea, 'ITBMS')
from cajas, caja_trx1, caja_trx2, cglauxiliares
where cajas.caja = caja_trx1.caja
and caja_trx1.caja = caja_trx2.caja
and caja_trx1.numero_trx = caja_trx2.numero_trx
and caja_trx2.auxiliar_1 = cglauxiliares.auxiliar
and caja_trx1.fecha_posteo >= '201201-01'
union
select bcoctas.compania, cglauxiliares.tipo_persona, trim(cglauxiliares.id),
trim(cglauxiliares.dv), trim(cglauxiliares.nombre),
trim(to_char(bcocheck1.no_cheque, '99999999')),
bcocheck1.fecha_cheque, cglauxiliares.concepto, cglauxiliares.tipo_de_compra,
f_bcocheck2(bcocheck2.cod_ctabco, bcocheck2.motivo_bco, bcocheck2.no_cheque, bcocheck2.linea, 'MONTO'),
f_bcocheck2(bcocheck2.cod_ctabco, bcocheck2.motivo_bco, bcocheck2.no_cheque, bcocheck2.linea, 'ITBMS')
from bcoctas, bcocheck1, bcocheck2, cglauxiliares, cglcuentas
where bcoctas.cod_ctabco = bcocheck1.cod_ctabco
and bcocheck1.cod_ctabco = bcocheck2.cod_ctabco
and bcocheck1.motivo_bco = bcocheck2.motivo_bco
and bcocheck1.no_cheque = bcocheck2.no_cheque
and bcocheck2.auxiliar1 = cglauxiliares.auxiliar
and bcocheck1.fecha_cheque >= '2012-01-01'
and bcocheck1.status <> 'A'
and bcocheck1.aplicacion = 'BCO'
and cglcuentas.cuenta = bcocheck2.cuenta
and cglcuentas.tipo_cuenta = 'R';

