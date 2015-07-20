

set search_path to dba;



drop view v_adc_comisiones_verificador;
drop view v_adc_comisiones;
drop view v_adc_estadisticas_house;
drop view v_adc_estadisticas;
drop view v_adc_estadisticas_x_cliente;
drop view v_adc_estadisticas_x_contenedor;
drop view v_adc_estadisticas_venta;
drop view v_adc_facturas_x_master;
drop view v_adc_manifiesto_contable;
drop view v_adc_notificacion;
drop view v_adc_master_cglposteo;
drop view v_adc_house_cglposteo;
drop view v_adc_cxc_1_cglposteo;
drop view v_adc_cxc_1;
drop view v_adc_cxp_1_cglposteo;
drop view v_adc_cxp_1;
drop view v_adc_manifiesto_cliente;
drop view v_adc_si;
drop view v_adc_facturacion;
drop view v_adc_facturacion_carga_suelta;
drop view v_adc_cargas_por_cliente_detallado;
drop view v_adc_verificador_operacion;
drop view v_adc_control_entrega;
drop view v_adc_eficiencia cascade;
drop view v_adc_tracking cascade;
drop view v_adc_notificacion_cargos cascade;
drop view v_adc_verificador_contable cascade;
drop view v_factura1_factura2_airsea cascade;
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


create view v_factura1_factura2_airsea as
select almacen.compania, factura1.almacen, factura1.cajero, factura1.tipo, factmotivos.descripcion,
factura1.num_documento, factura1.cliente, factura1.nombre_cliente, factura1.forma_pago,
gral_forma_de_pago.dias,
factura1.codigo_vendedor, almacen.desc_almacen,
f_adc_region(adc_manifiesto.compania, adc_manifiesto.consecutivo) as region,
f_adc_tipo_de_carga(adc_manifiesto.compania, adc_manifiesto.consecutivo) as tipo_de_carga,
Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, factura1.fecha_factura,
factura2.articulo, articulos.desc_articulo,
vendedores.nombre as nombre_del_vendedor,
fact_referencias.descripcion as referencia,
gralcompanias.nombre as nombre_de_cia,
articulos.orden_impresion,
f_factura1_ciudad(factura1.almacen, factura1.tipo, factura1.num_documento, factura1.caja) as ciudad,
(factura2.cantidad * factmotivos.signo) as cantidad,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) / factura2.cantidad) as precio,
((((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) - f_factura2_costo(factura2.almacen,factura2.tipo,factura2.num_documento,factura2.linea,'COSTO')) as margen
from almacen, factura1, factura2, factmotivos, clientes, articulos, 
vendedores, gralcompanias, gral_forma_de_pago, fact_referencias, adc_manifiesto
where factura1.referencia = fact_referencias.referencia
and almacen.compania = adc_manifiesto.compania
and trim(factura1.no_referencia) = trim(adc_manifiesto.no_referencia)
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and almacen.compania = gralcompanias.compania
and factura1.codigo_vendedor = vendedores.codigo
and almacen.almacen = factura1.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura1.tipo = factmotivos.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S')
and factura1.cliente = clientes.cliente
and factura2.articulo = articulos.articulo
and factura2.cantidad <> 0
and factura1.fecha_factura >= '2013-01-01'
and almacen.compania = '03'
and factura1.status <> 'A';



create view v_adc_notificacion_cargos as
select trim(factura1.cliente) as cliente, trim(factura1.no_referencia) as no_referencia, 
trim(factura1.hbl) as hbl, 
trim(factura1.mbl) as mbl,
trim(articulos.desc_articulo) as desc_articulo, trim(factura2.observacion) as observacion, 
trim(factura2.articulo) as articulo, factura2.precio,
(select sum(factura3.monto) from factura3
    where factura3.almacen = factura2.almacen
    and factura3.tipo = factura2.tipo
    and factura3.caja = factura2.caja
    and factura3.num_documento = factura2.num_documento
    and factura3.linea = factura2.linea
    and factura3.monto <> 0) as itbms
from factura1, factura2, articulos, factmotivos
where factura1.almacen = factura2.almacen
and factura1.caja = factura2.caja
and factura1.tipo = factura2.tipo
and factura1.tipo = factmotivos.tipo
and factmotivos.cotizacion <> 'S'
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and factura1.fecha_factura >= '2014-01-01'
and factura1.status <> 'A'
and not exists
    (select * from factura1 a, factmotivos
        where a.tipo = factmotivos.tipo
        and factmotivos.devolucion = 'S'
        and a.almacen = factura1.almacen
        and a.caja = factura1.caja
        and a.num_factura = factura1.num_documento
        and a.fecha_factura >= '2014-01-01')
union
select trim(factura1.cliente) as cliente, trim(factura1.no_referencia) as no_referencia, 
trim(factura1.hbl) as hbl, 
trim(factura1.mbl) as mbl,
trim(articulos.desc_articulo) as desc_articulo, trim(factura2.observacion) as observacion, 
trim(factura2.articulo) as articulo, factura2.precio,
(select sum(factura3.monto) from factura3
    where factura3.almacen = factura2.almacen
    and factura3.tipo = factura2.tipo
    and factura3.caja = factura2.caja
    and factura3.num_documento = factura2.num_documento
    and factura3.linea = factura2.linea
    and factura3.monto <> 0) as itbms
from factura1, factura2, articulos, factmotivos
where factura1.almacen = factura2.almacen
and factura1.caja = factura2.caja
and factura1.tipo = factura2.tipo
and factura1.tipo = factmotivos.tipo
and factmotivos.cotizacion = 'S'
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and factura1.fecha_factura >= '2014-01-01'
and factura1.status <> 'A';

create view v_adc_notificacion as
select current_user as usuario, adc_manifiesto.compania, trim(gralcompanias.nombre) as nombre_cia, 
adc_manifiesto.fecha_arrive,
a.nomb_cliente as agente, b.nomb_cliente as cliente, b.cliente as codigo_cliente,
adc_manifiesto.vapor, trim(adc_master.no_bill) as master, trim(adc_master.container) as contenedor,
trim(adc_master.sello) as sello, 
trim(adc_house.no_house) as house_bill,
adc_house.linea_master, adc_house.linea_house,
trim(adc_tipo_de_contenedor.descripcion) as tipo_de_contenedor,
trim(b.direccion3) as atencion,
adc_house.pkgs as ctns, adc_house.cbm as cbm, adc_manifiesto.ciudad_destino, 
trim(fac_ciudades.nombre) as ciudad_origen,
adc_master.tamanio, adc_manifiesto.confirmado, adc_house.embarcador,
adc_manifiesto.consecutivo, adc_manifiesto.no_referencia, destinos.descripcion as puerto_descarga,
adc_house.cod_destino, gralcompanias.mensaje, b.mail,
f_adc_f_notificacion(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house) as fecha_notificacion
from adc_manifiesto, adc_master, adc_house, gralcompanias, fac_ciudades,
clientes a, clientes b, adc_tipo_de_contenedor, fact_referencias, destinos
where adc_manifiesto.puerto_descarga = destinos.cod_destino
and adc_manifiesto.ciudad_origen = fac_ciudades.ciudad
and adc_manifiesto.referencia = fact_referencias.referencia
and ((fact_referencias.medio = 'M' and fact_referencias.tipo = 'I') or
(fact_referencias.medio = 'O' and fact_referencias.tipo = 'O') or 
(fact_referencias.medio = 'O' and fact_referencias.tipo = 'I'))
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.from_agent = a.cliente
and adc_house.cliente = b.cliente
and adc_master.tipo = adc_tipo_de_contenedor.tipo;




create view v_adc_tracking as
select adc_house.no_house as hbl, 
(select fac_ciudades.nombre from fac_ciudades
where fac_ciudades.ciudad = adc_manifiesto.ciudad_origen) as origen,
(select destinos.descripcion from destinos
where destinos.cod_destino = adc_manifiesto.port_of_departure) as port_of_departure,
(select destinos.descripcion from destinos
where destinos.cod_destino = adc_house.cod_destino) as port_of_arrival,
(select destinos.descripcion from destinos where destinos.cod_destino = adc_manifiesto.puerto_descarga) as final_destination,
adc_master.tipo as tipo,
case when adc_master.tipo = 'LCL/LCL' then 'CBM' else adc_master.tamanio end as units,
case when adc_master.tamanio = 'NO' then 0 else 
    case when adc_master.tipo = 'LCL/LCL' then adc_house.cbm else
        (select count(*) from adc_master a
        where a.compania = adc_master.compania
        and a.consecutivo = adc_master.consecutivo
        and a.no_bill = adc_master.no_bill) end
  end as amount,
adc_manifiesto.fecha_departure as date_of_receipt,
adc_manifiesto.fecha_departure as etd,
adc_manifiesto.fecha_departure as departure_date,
adc_manifiesto.fecha_arrive as eta,
adc_manifiesto.fecha_arrive as arrival,
adc_house.fecha_entrega as final,
adc_house.observacion as comments
from adc_manifiesto, adc_master, adc_house, fact_referencias
where fact_referencias.referencia = adc_manifiesto.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_manifiesto.fecha >= '2013-01-01'
and fact_referencias.medio = 'M'
union
select adc_house.no_house as hbl, 
(select fac_ciudades.nombre from fac_ciudades
where fac_ciudades.ciudad = adc_manifiesto.ciudad_origen) as origen,
(select destinos.descripcion from destinos
where destinos.cod_destino = adc_manifiesto.port_of_departure) as port_of_departure,
(select destinos.descripcion from destinos
where destinos.cod_destino = adc_house.cod_destino) as port_of_arrival,
(select destinos.descripcion from destinos where destinos.cod_destino = adc_manifiesto.puerto_descarga) as final_destination,
'AIR' as tipo,
'KGS' as units,
Round(adc_house.kgs,1) as amount,
adc_manifiesto.fecha_departure as date_of_receipt,
adc_manifiesto.fecha_departure as etd,
adc_manifiesto.fecha_departure,
adc_manifiesto.fecha_arrive as eta,
adc_manifiesto.fecha_arrive as arrival,
adc_house.fecha_entrega as final,
adc_house.observacion as comments
from adc_manifiesto, adc_master, adc_house, fact_referencias
where fact_referencias.referencia = adc_manifiesto.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_manifiesto.fecha >= '2013-01-01'
and fact_referencias.medio <> 'M';


create view v_adc_eficiencia as
select adc_manifiesto.operacion, 
trim(fact_referencias.descripcion) as import_export,
adc_manifiesto.fecha as report_date,
Anio(adc_manifiesto.fecha) as anio,
Mes(adc_manifiesto.fecha) as mes,
case when fact_referencias.tipo = 'I' then Extract(week from adc_manifiesto.fecha_arrive) else Extract(week from fecha_departure) end as semana,
clientes.nomb_cliente as nombre_cliente,
adc_house.cliente as codigo_cliente,
(select vendedores.nombre from vendedores 
where vendedores.codigo = adc_house.vendedor) as vendedor,
adc_manifiesto.consecutivo as no_abaco,
(select adc_si.num_shipping from adc_si
where adc_si.compania = adc_house.compania
and adc_si.anio = adc_house.anio
and adc_si.secuencia = adc_house.secuencia) as no_si,
(select adc_si.fecha from adc_si
where adc_si.compania = adc_house.compania
and adc_si.anio = adc_house.anio
and adc_si.secuencia = adc_house.secuencia) as fecha_si,
adc_manifiesto.no_referencia as lote,
adc_master.container, 
adc_manifiesto.vapor as vessel,
(select fac_regiones.nombre from fac_regiones, fac_paises, fac_ciudades
where fac_regiones.region = fac_paises.region
and fac_paises.pais = fac_ciudades.pais
and fac_ciudades.ciudad = adc_manifiesto.ciudad_origen) as region,
(select destinos.descripcion from destinos where destinos.cod_destino = adc_manifiesto.port_of_departure) as port_of_departure,
(select destinos.descripcion from destinos where destinos.cod_destino = adc_manifiesto.puerto_descarga) as puerto_de_descarga,
(select destinos.descripcion from destinos where destinos.cod_destino = adc_house.cod_destino) as destino,
(select navieras.descripcion from navieras where navieras.cod_naviera = adc_manifiesto.cod_naviera) as carrier,
adc_master.no_bill as mbl_mawb, adc_house.no_house as hbl_hawb,
adc_master.tipo as tipo_de_carga,
adc_master.tamanio,
adc_tipo_de_contenedor.clase,
case when adc_tipo_de_contenedor.clase = 'INTACTS' then 1 else 0 end as amount,
case when adc_tipo_de_contenedor.clase = 'INTACTS' then adc_containers.teus else 0 end as teus,
adc_manifiesto.fecha_departure as date_of_receipt,
adc_manifiesto.fecha_departure as etd, 
adc_manifiesto.fecha_arrive as eta,
adc_house.fecha_entrega as final,
adc_house.cbm as cbm,
adc_house.kgs,
adc_house.embarcador as shipper,
case when adc_house.cargo_prepago = 'S' then 'PP' else 'CC' end as term,
adc_house.fecha_sice as fecha_siga,
adc_house.fecha_inicio_almacenaje,
adc_house.fecha_retencion as fecha_retencion,
adc_house.f_preaviso as fecha_preaviso,
adc_house.f_aviso_final as fecha_aviso_final,
adc_house.transportista,
adc_house.tipo as tipo_de_servicio,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo) as agente,
(select navieras.descripcion from navieras
where navieras.cod_naviera = adc_manifiesto.co_loader_naviera) as co_loader_naviera,
adc_manifiesto.co_loader_destino,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'NUMERO_FACTURA_FLETE') as numero_factura_flete,
to_number(f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MONTO_FACTURA_FLETE'),'9999999999.99') as monto_factura_flete,
to_number(f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'SALDO_FACTURA_FLETE'), '9999999999.99') as saldo_factura_flete,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'NUMERO_FACTURA_MANEJO') as numero_factura_manejo,
to_number(f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MONTO_FACTURA_MANEJO'),'99999999999.99') as monto_factura_manejo,
to_number(f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'SALDO_FACTURA_MANEJO'), '9999999999.99') as saldo_factura_manejo,
(to_number(f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MONTO_FACTURA_FLETE'),'9999999999.99') -
f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FLETE')) as costo_flete,
(to_number(f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MONTO_FACTURA_MANEJO'),'99999999999.99') -
f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MANEJO')) as costo_manejo,
f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FLETE') as flete,
f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MANEJO') as manejo,
(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FLETE') +
f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MANEJO')) as resultado,
Trim(adc_house.observacion) as comentario
from adc_manifiesto, adc_master, adc_house, clientes, fact_referencias, adc_containers,
adc_tipo_de_contenedor
where adc_master.tipo = adc_tipo_de_contenedor.tipo
and adc_master.tamanio = adc_containers.tamanio
and fact_referencias.referencia = adc_manifiesto.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_house.cliente = clientes.cliente
and adc_manifiesto.fecha >= '2014-01-01';


create view v_adc_comisiones as
select adc_manifiesto.compania, Anio(adc_manifiesto.fecha) as anio,
Mes(adc_manifiesto.fecha) as mes,
adc_manifiesto.fecha as fecha,
adc_manifiesto.consecutivo, trim(fact_referencias.descripcion) as referencia, adc_manifiesto.no_referencia,
adc_house.no_house,
adc_house.anio as anio_si, adc_house.secuencia as num_si,
(select fac_ciudades.nombre from fac_ciudades
where fac_ciudades.ciudad = adc_manifiesto.ciudad_origen) as origen,
f_adc_region(adc_manifiesto.compania, adc_manifiesto.consecutivo) as region,
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo,'NOMBRE') as agente,
clientes.nomb_cliente as nombre_cliente,
adc_house.cliente as codigo_cliente,
adc_house.embarcador, vendedores.nombre as vendedor,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FECHA_FACTURA_FLETE') as fecha_factura_flete,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'NUMERO_FACTURA_FLETE') as numero_factura_flete,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'RECIBO_FACTURA_FLETE') as recibo_factura_flete,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FECHA_RECIBO_FACTURA_FLETE') as fecha_recibo_factura_flete,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'SALDO_FACTURA_FLETE') as saldo_factura_flete,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FECHA_FACTURA_MANEJO') as fecha_factura_manejo,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'NUMERO_FACTURA_MANEJO') as numero_factura_manejo,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'RECIBO_FACTURA_MANEJO') as recibo_factura_manejo,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FECHA_RECIBO_FACTURA_MANEJO') as fecha_recibo_factura_manejo,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'SALDO_FACTURA_MANEJO') as saldo_factura_manejo,
(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FLETE')
-f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'COSTOS_FLETE')) as venta_flete,
f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FLETE') as flete,
-f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'COSTOS_FLETE') as costos_flete,
f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MANEJO') as manejo,
(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FLETE') + 
f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MANEJO')) as rentabilidad,
(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FLETE')
-f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'COSTOS_FLETE') + 
f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MANEJO')) as venta_total
from adc_manifiesto, adc_house, clientes, vendedores, fact_referencias
where adc_manifiesto.compania = adc_house.compania
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.consecutivo = adc_house.consecutivo
and adc_house.cliente = clientes.cliente
and adc_house.vendedor = vendedores.codigo
and adc_manifiesto.fecha >= '2014-01-01';


create view v_adc_comisiones_verificador as
SELECT Anio(fecha) as anio, Mes(fecha) as mes, fecha as fecha, adc_manifiesto.consecutivo, adc_manifiesto.no_referencia,
trim(fact_referencias.descripcion) as referencia,
f_adc_region(adc_manifiesto.compania, adc_manifiesto.consecutivo) as region,
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo,'NOMBRE') as agente,
f_adc_manifiesto(adc_manifiesto.compania, adc_manifiesto.consecutivo,'FLETE') as flete_manifiesto , 
f_adc_manifiesto(adc_manifiesto.compania, adc_manifiesto.consecutivo,'MANEJO') as manejo_manifiesto,
-f_adc_manifiesto(adc_manifiesto.compania, adc_manifiesto.consecutivo,'COSTOS') as costos_manifiesto,
(f_adc_manifiesto(adc_manifiesto.compania, adc_manifiesto.consecutivo,'FLETE') +
f_adc_manifiesto(adc_manifiesto.compania, adc_manifiesto.consecutivo,'MANEJO')  -
f_adc_manifiesto(adc_manifiesto.compania, adc_manifiesto.consecutivo,'COSTOS')) as venta,
(f_adc_manifiesto(adc_manifiesto.compania, adc_manifiesto.consecutivo,'FLETE') +
f_adc_manifiesto(adc_manifiesto.compania, adc_manifiesto.consecutivo,'MANEJO')) as rentabilidad,
sum(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FLETE')) as flete_house,
sum(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MANEJO')) as manejo_house,
-sum(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'COSTOS_FLETE')) as costos_flete
FROM adc_house, adc_manifiesto, fact_referencias
WHERE adc_house.compania = adc_manifiesto.compania
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_house.consecutivo = adc_manifiesto.consecutivo
and adc_manifiesto.fecha >= '2010-01-01'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13;


create view v_adc_cargas_por_cliente_detallado as
select factura1.fecha_factura as fecha_factura, 
Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes,
factura1.num_documento, clientes.nomb_cliente, 
factura1.cliente, clientes.status, vendedores.nombre,
clientes.fecha_apertura, adc_manifiesto.fecha, 
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo) as agente,
f_monto_factura(factura1.almacen, factura1.tipo, factura1.num_documento) as monto_factura,
fact_referencias.descripcion, adc_master.no_bill, adc_house.no_house, 
case when fact_referencias.medio = 'A' then adc_house.kgs else 0 end as kgs,
(select nombre from fac_ciudades where fac_ciudades.ciudad = adc_manifiesto.ciudad_origen) as origen,
(select nombre from fac_ciudades where fac_ciudades.ciudad = adc_manifiesto.ciudad_destino) as destino,
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
f_adc_region(adc_manifiesto.compania, adc_manifiesto.consecutivo) as region,
trim(adc_house.embarcador) as embarcador, 
case when adc_master.tamanio = '20' then 1 else 0 end as C20,
case when adc_master.tamanio = '40' then 1 else 0 end as C40,
case when adc_master.tamanio = '40HQ' then 1 else 0 end as C40HQ,
(select adc_containers.teus from adc_containers
where adc_containers.tamanio = adc_master.tamanio) as teus,
case when adc_master.tipo = 'LCL/LCL' then adc_master.cbm else 0 end as clcl,
fact_referencias.medio, fact_referencias.tipo, adc_house.cargo_prepago, adc_master.tipo as tipo_de_carga
from factura1, adc_house_factura1, adc_house, adc_master, adc_manifiesto,
    fact_referencias, factmotivos, clientes, vendedores
where clientes.vendedor = vendedores.codigo
and factura1.almacen = adc_house_factura1.almacen
and factura1.tipo = adc_house_factura1.tipo
and factura1.num_documento = adc_house_factura1.num_documento
and factura1.tipo = factmotivos.tipo
and factura1.cliente = clientes.cliente
and factmotivos.factura = 'S'
and adc_house_factura1.compania = adc_house.compania
and adc_house_factura1.consecutivo = adc_house.consecutivo
and adc_house_factura1.linea_master = adc_house.linea_master
and adc_house_factura1.linea_house = adc_house.linea_house
and adc_house.compania = adc_master.compania
and adc_house.consecutivo = adc_master.consecutivo
and adc_house.linea_master = adc_master.linea_master
and adc_master.compania = adc_manifiesto.compania
and adc_master.consecutivo = adc_manifiesto.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and factura1.fecha_factura >= '2008-01-01'
union
select factura1.fecha_factura, 
Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes,
factura1.num_documento, clientes.nomb_cliente, 
factura1.cliente, clientes.status, vendedores.nombre,
clientes.fecha_apertura, factura1.fecha_factura,
clientes.cliente,
f_monto_factura(factura1.almacen, factura1.tipo, factura1.num_documento) as monto_factura,
fact_referencias.descripcion, null, null, 
0, null, null, null, null, null, 0, 0, 0, 0, 0, null, null, 'N', null
from factura1, fact_referencias, factmotivos, clientes, vendedores
where clientes.vendedor = vendedores.codigo
and factura1.tipo = factmotivos.tipo
and factura1.cliente = clientes.cliente
and factmotivos.factura = 'S'
and factura1.referencia = fact_referencias.referencia
and factura1.fecha_factura >= '2008-01-01'
and not exists
    (select * from adc_house_factura1
        where adc_house_factura1.almacen = factura1.almacen
        and adc_house_factura1.tipo = factura1.tipo
        and adc_house_factura1.num_documento = factura1.num_documento);



create view v_adc_estadisticas as
select adc_manifiesto.consecutivo, trim(adc_manifiesto.no_referencia) as no_referencia, 
f_adc_region(adc_manifiesto.compania, adc_manifiesto.consecutivo) as region,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo,'NOMBRE') as agente,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo,'CONTACTO') as contacto,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo,'MAIL') as mail_agente,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo,'FECHA_APERTURA') as fecha_apertura,
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
(select destinos.descripcion from destinos where destinos.cod_destino = adc_manifiesto.puerto_descarga) as puerto_descarga,
(select navieras.descripcion from navieras where navieras.cod_naviera = adc_manifiesto.cod_naviera) as naviera,
adc_manifiesto.fecha_departure as etd, 
adc_manifiesto.fecha_arrive as eta,
case when fact_referencias.tipo = 'E' then adc_manifiesto.fecha_departure else adc_manifiesto.fecha_arrive end as fecha,
case when fact_referencias.tipo = 'E' then Anio(adc_manifiesto.fecha_departure) else Anio(adc_manifiesto.fecha_arrive) end as anio,
case when fact_referencias.tipo = 'E' then Mes(adc_manifiesto.fecha_departure) else Mes(adc_manifiesto.fecha_arrive) end as mes, 
adc_master.tamanio, adc_master.no_bill, adc_master.container, adc_house.no_house, adc_house.cliente,
clientes.nomb_cliente,
case when adc_master.tamanio = 'NO' then 0 else 1 end as contenedor,
case when adc_master.tamanio = 'NO' then adc_master.cbm else 0 end as cbm, 
adc_master.pkgs, adc_master.kgs,
fact_referencias.descripcion as desc_referencia, fact_referencias.medio, 
fact_referencias.tipo as import_export, adc_tipo_de_contenedor.clase,
adc_tipo_de_contenedor.tipo as tipo,
trim(adc_house.vendedor) as codigo_vendedor, trim(vendedores.nombre) as nombre_vendedor,
f_adc_master_tipo_de_carga(adc_master.compania, adc_master.consecutivo, adc_master.linea_master) as tipo_de_carga,
f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FLETE') as flete,
-f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'COSTOS_FLETE') as costos_flete,
f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MANEJO') as manejo
from adc_manifiesto, adc_master, adc_containers, fact_referencias, adc_tipo_de_contenedor, 
adc_house, clientes, vendedores
where adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_house.cliente = clientes.cliente
and adc_master.tipo = adc_tipo_de_contenedor.tipo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.tamanio = adc_containers.tamanio
and adc_house.vendedor = vendedores.codigo;


create view v_adc_facturacion_carga_suelta as
select gralcompanias.nombre, almacen.compania, fact_referencias.descripcion, adc_master.container, adc_manifiesto.no_referencia,
adc_master.tipo, factura1.fecha_factura, Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes,
factura1.almacen, factura1.num_documento as no_factura, 
factura1.cliente, factura1.nombre_cliente, f_monto_factura(factura1.almacen, factura1.tipo, factura1.num_documento) as monto
from adc_manifiesto, adc_master, adc_house, adc_house_factura1, factura1, fact_referencias, 
factmotivos, almacen, gralcompanias
where almacen.compania = gralcompanias.compania
and factura1.almacen = almacen.almacen
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_house.compania = adc_house_factura1.compania
and adc_house.consecutivo = adc_house_factura1.consecutivo
and adc_house.linea_master = adc_house_factura1.linea_master
and adc_house.linea_house = adc_house_factura1.linea_house
and adc_house_factura1.almacen = factura1.almacen
and adc_house_factura1.tipo = factura1.tipo
and adc_house_factura1.num_documento = factura1.num_documento
and factura1.referencia = fact_referencias.referencia
and factura1.status <> 'A'
and factura1.tipo = factmotivos.tipo
and factmotivos.factura = 'S'
and adc_master.tipo in ('LCL/LCL','FCL/LCL');

create view v_adc_facturacion as
select gralcompanias.nombre, almacen.compania, fact_referencias.descripcion, adc_master.container, adc_manifiesto.no_referencia,
adc_master.tipo, factura1.fecha_factura, Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes,
factura1.almacen, factura1.num_documento as no_factura, 
factura1.cliente, factura1.nombre_cliente, f_monto_factura(factura1.almacen, factura1.tipo, factura1.num_documento) as monto
from adc_manifiesto, adc_master, adc_house, 
adc_house_factura1, factura1, fact_referencias, 
factmotivos, almacen, gralcompanias
where almacen.compania = gralcompanias.compania
and factura1.almacen = almacen.almacen
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_house.compania = adc_house_factura1.compania
and adc_house.consecutivo = adc_house_factura1.consecutivo
and adc_house.linea_master = adc_house_factura1.linea_master
and adc_house.linea_house = adc_house_factura1.linea_house
and adc_house_factura1.almacen = factura1.almacen
and adc_house_factura1.tipo = factura1.tipo
and adc_house_factura1.num_documento = factura1.num_documento
and factura1.referencia = fact_referencias.referencia
and factura1.status <> 'A'
and factura1.tipo = factmotivos.tipo
and factmotivos.factura = 'S';


create view v_adc_estadisticas_venta as
select adc_manifiesto.compania, vendedores.nombre as nombre_vendedor, vendedores.codigo as codigo_vendedor, 
clientes.nomb_cliente as nombre_cliente,
clientes.cliente as codigo_cliente,
Anio(fecha) as anio, Mes(fecha) as mes,
sum(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FLETE')) as flete,
sum(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MANEJO')) as manejo
from adc_manifiesto, adc_house, vendedores, clientes
where Anio(fecha) >= 2008
and adc_house.vendedor = vendedores.codigo
and adc_manifiesto.compania = adc_house.compania
and adc_manifiesto.consecutivo = adc_house.consecutivo
and adc_house.cliente = clientes.cliente
group by 1, 2, 3, 4, 5, 6, 7;


create view v_adc_estadisticas_x_contenedor as
select adc_manifiesto.consecutivo, trim(adc_manifiesto.no_referencia) as no_referencia, 
f_adc_location(adc_manifiesto.compania, adc_manifiesto.consecutivo,'REGION') as region,
f_adc_location(adc_manifiesto.compania, adc_manifiesto.consecutivo,'PAIS') as pais,
f_adc_location(adc_manifiesto.compania, adc_manifiesto.consecutivo,'CIUDAD') as ciudad,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo) as agente,
(select destinos.descripcion from destinos where destinos.cod_destino = adc_manifiesto.puerto_descarga) as puerto_descarga,
(select navieras.descripcion from navieras where navieras.cod_naviera = adc_manifiesto.cod_naviera) as naviera,
adc_manifiesto.fecha_departure as etd, 
adc_manifiesto.fecha_arrive as eta,
case when fact_referencias.tipo = 'E' then adc_manifiesto.fecha_departure else adc_manifiesto.fecha_arrive end as fecha,
case when fact_referencias.tipo = 'E' then Anio(adc_manifiesto.fecha_departure) else Anio(adc_manifiesto.fecha_arrive) end as anio,
case when fact_referencias.tipo = 'E' then Mes(adc_manifiesto.fecha_departure) else Mes(adc_manifiesto.fecha_arrive) end as mes, 
adc_master.tamanio, adc_master.no_bill, adc_master.container, 
fact_referencias.descripcion as desc_referencia, fact_referencias.medio, 
fact_referencias.tipo as import_export, adc_tipo_de_contenedor.clase,
adc_tipo_de_contenedor.tipo as tipo,
f_adc_master_tipo_de_carga(adc_master.compania, adc_master.consecutivo, adc_master.linea_master) as tipo_de_carga,
case when trim(adc_tipo_de_contenedor.clase) = 'INTACTS' then 1 else 0 end as contenedor,
case when trim(adc_tipo_de_contenedor.clase) = 'INTACTS' then adc_containers.teus else 0 end as teus,
sum(case when adc_master.tamanio = 'NO' then adc_master.cbm else 0 end) as cbm, 
sum(adc_master.pkgs) as pkgs, sum(adc_master.kgs) as kgs
from adc_manifiesto, adc_master, adc_containers, fact_referencias, adc_tipo_de_contenedor
where adc_master.tipo = adc_tipo_de_contenedor.tipo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.tamanio = adc_containers.tamanio
and adc_manifiesto.fecha >= '2013-01-01'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
21, 22, 23, 24;


create view v_adc_estadisticas_x_cliente as
select adc_manifiesto.consecutivo, trim(adc_manifiesto.no_referencia) as no_referencia, 
f_adc_region(adc_manifiesto.compania, adc_manifiesto.consecutivo) as region,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo) as agente,
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
clientes.nomb_cliente, clientes.cliente,
(select destinos.descripcion from destinos where destinos.cod_destino = adc_manifiesto.puerto_descarga) as puerto_descarga,
(select navieras.descripcion from navieras where navieras.cod_naviera = adc_manifiesto.cod_naviera) as naviera,
adc_manifiesto.fecha_departure as etd, 
adc_manifiesto.fecha_arrive as eta, 
Anio(adc_manifiesto.fecha_arrive) as anio,
Mes(adc_manifiesto.fecha_arrive) as mes, 
adc_master.tamanio, adc_master.no_bill, adc_house.no_house, adc_master.container, 
case when adc_master.tamanio = 'NO' then 0 else 1 end as contenedor,
case when adc_master.tamanio = 'NO' then adc_master.cbm else 0 end as cbm, 
adc_house.pkgs, adc_house.kgs,
fact_referencias.descripcion as desc_referencia, fact_referencias.medio, 
fact_referencias.tipo as import_export, adc_tipo_de_contenedor.clase,
adc_tipo_de_contenedor.tipo as tipo,
f_adc_master_tipo_de_carga(adc_master.compania, adc_master.consecutivo, adc_master.linea_master) as tipo_de_carga,
f_adc_house_flete(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house) as flete,
f_adc_house_manejo(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house) as manejo
from adc_manifiesto, adc_master, adc_containers, fact_referencias, adc_tipo_de_contenedor, adc_house, clientes
where adc_master.tipo = adc_tipo_de_contenedor.tipo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.tamanio = adc_containers.tamanio
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_house.cliente = clientes.cliente;


create view v_adc_control_entrega as
select gralcompanias.nombre, gralcompanias.compania, adc_manifiesto.consecutivo, adc_manifiesto.no_referencia,
    adc_master.no_bill, adc_master.tamanio, adc_master.tipo, adc_manifiesto.fecha_arrive as fecha,
    adc_master.container, adc_house.no_house, adc_house.cliente, clientes.nomb_cliente,
    adc_house.pkgs as bultos, 
    f_adc_bultos_entregados(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house) as bultos_entregados,
    f_adc_saldo_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house) as saldo
from adc_manifiesto, adc_master, adc_house, clientes, gralcompanias
where adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_house.cliente = clientes.cliente
and exists
    (select * from adc_house_factura1, factmotivos
    where adc_house_factura1.tipo = factmotivos.tipo
    and factmotivos.factura = 'S'
    and adc_house_factura1.compania = adc_house.compania
    and adc_house_factura1.consecutivo = adc_house.consecutivo
    and adc_house_factura1.linea_master = adc_house.linea_master
    and adc_house_factura1.linea_house = adc_house.linea_house);


create view v_adc_verificador_contable as
select rela_adc_cxc_1_cglposteo.compania, 
rela_adc_cxc_1_cglposteo.consecutivo, rela_adc_cxc_1_cglposteo.cgl_consecutivo, 
cglposteo.cuenta, 
-sum(cglposteo.debito-cglposteo.credito) as monto
from rela_adc_cxc_1_cglposteo, cglposteo
where rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
group by 1, 2, 3, 4
union
select rela_adc_cxp_1_cglposteo.compania, rela_adc_cxp_1_cglposteo.consecutivo, 
rela_adc_cxp_1_cglposteo.cgl_consecutivo, 
cglposteo.cuenta, 
-sum(cglposteo.debito-cglposteo.credito)
from rela_adc_cxp_1_cglposteo, cglposteo
where rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
group by 1, 2, 3, 4
union
select rela_adc_master_cglposteo.compania, 
rela_adc_master_cglposteo.consecutivo, 
rela_adc_master_cglposteo.cgl_consecutivo, 
cglposteo.cuenta, 
-sum(cglposteo.debito-cglposteo.credito)
from rela_adc_master_cglposteo, cglposteo
where rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo
group by 1, 2, 3, 4;



create view v_adc_verificador_operacion as
select 'OPERACION' as grupo, 2 as secuencia, 'COSTOS' as concepto, adc_master.linea_master, gralcompanias.nombre as nombre_cia, adc_manifiesto.compania, 
adc_manifiesto.consecutivo, adc_manifiesto.fecha, 
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo) as cliente,
adc_manifiesto.no_referencia, 
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
destinos.descripcion as destino,
adc_manifiesto.fecha_departure as etd, adc_manifiesto.fecha_arrive as eta, adc_manifiesto.divisor,
navieras.descripcion, adc_manifiesto.vapor, adc_master.container as container_house, 0 as factura,
case when adc_master.cargo_prepago = 'S' then -adc_master.cargo else 0 end as cargo_prepagado, 
case when adc_master.cargo_prepago <> 'S' then -adc_master.cargo else 0 end as cargo,
case when adc_master.gtos_prepago = 'S' then -adc_master.gtos_d_origen else 0 end as gtos_d_origen_prepagado,
case when adc_master.gtos_prepago <> 'S' then -adc_master.gtos_d_origen else 0 end as gtos_d_origen,
-adc_master.gtos_destino as gtos_destino,
case when adc_master.dthc_prepago = 'S' then -adc_master.dthc else 0 end as dthc_prepagado,
case when adc_master.dthc_prepago <> 'S' then -adc_master.dthc else 0 end as dthc
from adc_manifiesto, clientes, adc_master, navieras, fact_referencias, destinos, gralcompanias
where adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.from_agent = clientes.cliente
and adc_manifiesto.puerto_descarga = destinos.cod_destino
union
select 'OPERACION', 1, 'INGRESOS POR FLETE LOCALES', adc_master.linea_master, gralcompanias.nombre, adc_manifiesto.compania, 
adc_manifiesto.consecutivo, adc_manifiesto.fecha,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo),
adc_manifiesto.no_referencia, 
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
destinos.descripcion,
adc_manifiesto.fecha_departure as etd, adc_manifiesto.fecha_arrive as eta,adc_manifiesto.divisor,
navieras.descripcion, adc_manifiesto.vapor, adc_house.no_house, 
(select adc_house_factura1.num_documento from adc_house_factura1, factmotivos
where adc_house_factura1.tipo = factmotivos.tipo
and factmotivos.factura = 'S'
and adc_house_factura1.compania = adc_house.compania
and adc_house_factura1.consecutivo = adc_house.consecutivo
and adc_house_factura1.linea_master = adc_house.linea_master
and adc_house_factura1.linea_house = adc_house.linea_house),
case when adc_house.cargo_prepago = 'S' then adc_house.cargo else 0 end as cargo_prepagado,
case when adc_house.cargo_prepago <> 'S' then adc_house.cargo else 0 end as cargo,
case when adc_house.gtos_prepago = 'S' then adc_house.gtos_d_origen else 0 end,
case when adc_house.gtos_prepago <> 'S' then adc_house.gtos_d_origen else 0 end, 0,
case when adc_house.dthc_prepago = 'S' then adc_house.dthc else 0 end as dthc_prepagado,
case when adc_house.dthc_prepago <> 'S' then adc_house.dthc else 0 end as dthc
from adc_manifiesto, adc_master, navieras, fact_referencias, 
destinos, adc_house, gralcompanias
where adc_manifiesto.compania = gralcompanias.compania
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.puerto_descarga = destinos.cod_destino
union
select 'NOTAS', 4, 'OTROS INGRESOS', 0, gralcompanias.nombre, adc_manifiesto.compania, 
adc_manifiesto.consecutivo, adc_manifiesto.fecha,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo) as cliente,
adc_manifiesto.no_referencia,
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
destinos.descripcion,
adc_manifiesto.fecha_departure as etd, adc_manifiesto.fecha_arrive as eta,adc_manifiesto.divisor,
navieras.descripcion, adc_manifiesto.vapor, adc_cxc_1.documento, adc_cxc_1.consecutivo,
0, -(cxcmotivos.signo*adc_cxc_2.monto), 0, 0, 0, 0, 0
from adc_manifiesto, adc_cxc_1, navieras, fact_referencias, destinos, gralcompanias, adc_cxc_2, cxcmotivos
where adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.puerto_descarga = destinos.cod_destino
and adc_manifiesto.compania = adc_cxc_1.compania
and adc_manifiesto.consecutivo = adc_cxc_1.consecutivo
and adc_cxc_1.compania = adc_cxc_2.compania
and adc_cxc_1.consecutivo = adc_cxc_2.consecutivo
and adc_cxc_1.secuencia = adc_cxc_2.secuencia
and adc_cxc_2.cuenta like '4%'
and adc_cxc_1.motivo_cxc = cxcmotivos.motivo_cxc
union
select 'MANEJO',3, 'INGRESOS POR MANEJO', adc_manejo.linea_manejo, gralcompanias.nombre, adc_manifiesto.compania, 
adc_manifiesto.consecutivo, adc_manifiesto.fecha,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo),
adc_manifiesto.no_referencia,
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
destinos.descripcion,
adc_manifiesto.fecha_departure as etd, adc_manifiesto.fecha_arrive as eta,adc_manifiesto.divisor,
navieras.descripcion, adc_manifiesto.vapor, adc_house.no_house,
(select adc_manejo_factura1.num_documento from adc_manejo_factura1, factmotivos
where adc_manejo_factura1.compania = adc_manejo.compania
and adc_manejo_factura1.consecutivo = adc_manejo.consecutivo
and adc_manejo_factura1.linea_master = adc_manejo.linea_master
and adc_manejo_factura1.linea_house = adc_manejo.linea_house
and adc_manejo_factura1.linea_manejo = adc_manejo.linea_manejo
and adc_manejo_factura1.tipo = factmotivos.tipo
and factmotivos.factura = 'S'),
0, adc_manejo.cargo, 0, 0, 0, 0, 0
from adc_manifiesto, adc_master, navieras, fact_referencias,
destinos, adc_house, adc_manejo, gralcompanias
where adc_manifiesto.compania = gralcompanias.compania
and adc_house.compania = adc_manejo.compania
and adc_house.consecutivo = adc_manejo.consecutivo
and adc_house.linea_master = adc_manejo.linea_master
and adc_house.linea_house = adc_manejo.linea_house
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.puerto_descarga = destinos.cod_destino
and trim(adc_manejo.observacion) not like '%DTHC%'
union
select 'OPERACION', 1, 'INGRESOS POR FLETE LOCALES', adc_manejo.linea_manejo, gralcompanias.nombre, adc_manifiesto.compania, 
adc_manifiesto.consecutivo, adc_manifiesto.fecha,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo),
adc_manifiesto.no_referencia,
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
destinos.descripcion,
adc_manifiesto.fecha_departure as etd, adc_manifiesto.fecha_arrive as eta,adc_manifiesto.divisor,
navieras.descripcion, adc_manifiesto.vapor, adc_house.no_house,
(select adc_manejo_factura1.num_documento from adc_manejo_factura1, factmotivos
where adc_manejo_factura1.compania = adc_manejo.compania
and adc_manejo_factura1.consecutivo = adc_manejo.consecutivo
and adc_manejo_factura1.linea_master = adc_manejo.linea_master
and adc_manejo_factura1.linea_house = adc_manejo.linea_house
and adc_manejo_factura1.linea_manejo = adc_manejo.linea_manejo
and adc_manejo_factura1.tipo = factmotivos.tipo
and factmotivos.factura = 'S'),
0, 0, 0, 0, 0, 0, adc_manejo.cargo
from adc_manifiesto, adc_master, navieras, fact_referencias,
destinos, adc_house, adc_manejo, gralcompanias
where adc_manifiesto.compania = gralcompanias.compania
and adc_house.compania = adc_manejo.compania
and adc_house.consecutivo = adc_manejo.consecutivo
and adc_house.linea_master = adc_manejo.linea_master
and adc_house.linea_house = adc_manejo.linea_house
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.puerto_descarga = destinos.cod_destino
and trim(adc_manejo.observacion) like '%DTHC%';

create view v_adc_si as
select adc_si.compania, gralcompanias.nombre, anio, secuencia, trim(adc_si.num_shipping) as num_shipping, 
    fecha, sh_sp_ints as observacion, trim(c_company) as cliente
from adc_si, gralcompanias
where adc_si.compania = gralcompanias.compania
union
select adc_si_eventos.compania, gralcompanias.nombre, adc_si_eventos.anio, adc_si_eventos.secuencia, 
trim(adc_si.num_shipping), adc_si_eventos.fecha, adc_si_eventos.evento, trim(adc_si.c_company)
from adc_si, adc_si_eventos, gralcompanias
where adc_si.compania = adc_si_eventos.compania
and adc_si.compania = gralcompanias.compania
and adc_si.anio = adc_si_eventos.anio
and adc_si.secuencia = adc_si_eventos.secuencia;

create view v_adc_estadisticas_house as
select trim(adc_manifiesto.no_referencia) as no_referencia, adc_manifiesto.ciudad_origen as ciudad, 
adc_manifiesto.fecha_departure as fecha_salida,
adc_manifiesto.fecha_arrive, Anio(adc_manifiesto.fecha_arrive) as anio,
Mes(adc_manifiesto.fecha_arrive) as mes, 
adc_master.tamanio, adc_master.no_bill, adc_master.container, 1 as contenedor,
adc_manifiesto.cod_naviera, navieras.descripcion as nombre_naviera,
adc_master.tipo, 
case when adc_master.tamanio = 'NO' then adc_master.cbm else 0 end as cbm, 
case when adc_master.tamanio = 'NO' then 0 else adc_containers.teus end as teus,
adc_master.kgs,
fac_ciudades.nombre as nombre_ciudad, fac_paises.nombre as nombre_pais,
fac_regiones.region, fac_regiones.nombre as nombre_region,
adc_manifiesto.referencia, fact_referencias.medio, adc_house.tipo as tipo_house, adc_house.vendedor,
f_adc_master_flete(adc_master.compania, adc_master.consecutivo, adc_master.linea_master) as monto,
0 as manejo,
fact_referencias.tipo as import_export, adc_tipo_de_contenedor.clase
from adc_manifiesto, adc_master, fac_ciudades, adc_containers, fac_paises, fac_regiones,
fact_referencias, adc_tipo_de_contenedor, adc_house, navieras
where adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_master.tipo = adc_tipo_de_contenedor.tipo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.ciudad_origen = fac_ciudades.ciudad
and adc_master.tamanio = adc_containers.tamanio
and fac_ciudades.pais = fac_paises.pais
and fac_paises.region = fac_regiones.region
and fact_referencias.tipo = 'I'
and adc_house.tipo in ('3','2')
union
select trim(adc_manifiesto.no_referencia) as no_referencia, adc_manifiesto.ciudad_destino, 
adc_manifiesto.fecha_departure as fecha_salida,
adc_manifiesto.fecha_arrive, Anio(adc_manifiesto.fecha_arrive) as anio,
Mes(adc_manifiesto.fecha_arrive) as mes, 
adc_master.tamanio, adc_master.no_bill, adc_master.container, 1 as contenedor,
adc_manifiesto.cod_naviera, navieras.descripcion as nombre_naviera,
adc_master.tipo, 
case when adc_master.tamanio = 'NO' then adc_master.cbm else 0 end as cbm, 
case when adc_master.tamanio = 'NO' then 0 else adc_containers.teus end as teus,
adc_master.kgs,
fac_ciudades.nombre as destino, fac_paises.nombre as nombre_pais,
fac_regiones.region, fac_regiones.nombre as nombre_region,
adc_manifiesto.referencia, fact_referencias.medio, adc_house.tipo, adc_house.vendedor,
f_adc_master_flete(adc_master.compania, adc_master.consecutivo, adc_master.linea_master) as monto,
0 as manejo,
fact_referencias.tipo as import_export, adc_tipo_de_contenedor.clase
from adc_manifiesto, adc_master, fac_ciudades, adc_containers, fac_paises, fac_regiones,
fact_referencias, adc_tipo_de_contenedor, adc_house, navieras
where adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_tipo_de_contenedor.tipo = adc_master.tipo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.ciudad_destino = fac_ciudades.ciudad
and adc_master.tamanio = adc_containers.tamanio
and fac_ciudades.pais = fac_paises.pais
and fac_paises.region = fac_regiones.region
and fact_referencias.tipo <> 'I'
and adc_house.tipo in ('3','2');

create view v_adc_manifiesto_cliente as
select adc_manifiesto.consecutivo,   
       adc_manifiesto.no_referencia,   
       f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'NOMBRE') as nomb_cliente,       
       fact_referencias.descripcion,
       f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'CODIGO') as agente,
       adc_manifiesto.compania,
       gralcompanias.nombre,
       adc_manifiesto.fecha,
       case when fact_referencias.tipo = 'I' then adc_manifiesto.fecha_arrive else adc_manifiesto.fecha_departure end as fecha_arrive,
       adc_manifiesto.referencia
from adc_manifiesto, fact_referencias, gralcompanias
where adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.referencia = fact_referencias.referencia;


create view v_adc_cxp_1 as
select gralcompanias.*, adc_cxp_1.consecutivo, cxpmotivos.desc_motivo_cxp,
adc_cxp_1.secuencia, adc_cxp_1.fecha, adc_cxp_1.monto,
trim(adc_cxp_1.observacion) as observacion,
trim(adc_cxp_1.documento) as documento, adc_manifiesto.no_referencia,
proveedores.proveedor, proveedores.nomb_proveedor,
fact_referencias.descripcion,
adc_manifiesto.no_referencia as lote,
f_adc_cxp(adc_cxp_1.compania, adc_cxp_1.consecutivo, adc_cxp_1.secuencia, 'HBL') as hbl,
f_adc_cxp(adc_cxp_1.compania, adc_cxp_1.consecutivo, adc_cxp_1.secuencia, 'MBL') as mbl,
f_adc_cxp(adc_cxp_1.compania, adc_cxp_1.consecutivo, adc_cxp_1.secuencia, 'CONTENEDOR') as contenedor,
f_adc_cxp(adc_cxp_1.compania, adc_cxp_1.consecutivo, adc_cxp_1.secuencia, 'BULTOS') as bultos,
f_adc_cxp(adc_cxp_1.compania, adc_cxp_1.consecutivo, adc_cxp_1.secuencia, 'PESO') as peso,
f_adc_cxp(adc_cxp_1.compania, adc_cxp_1.consecutivo, adc_cxp_1.secuencia, 'NOMBRE_CLIENTE') as nombre_cliente,
f_adc_cxp(adc_cxp_1.compania, adc_cxp_1.consecutivo, adc_cxp_1.secuencia, 'CODIGO_CLIENTE') as codigo_cliente,
f_adc_cxp(adc_cxp_1.compania, adc_cxp_1.consecutivo, adc_cxp_1.secuencia, 'EMBARCADOR') as embarcador,
f_adc_cxp(adc_cxp_1.compania, adc_cxp_1.consecutivo, adc_cxp_1.secuencia, 'CARPETA') as carpeta
from adc_manifiesto, adc_cxp_1, cxpmotivos, gralcompanias, proveedores, fact_referencias
where adc_cxp_1.proveedor = proveedores.proveedor
and adc_manifiesto.compania = adc_cxp_1.compania
and adc_manifiesto.consecutivo = adc_cxp_1.consecutivo
and adc_cxp_1.motivo_cxp = cxpmotivos.motivo_cxp
and adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.referencia = fact_referencias.referencia;


create view v_adc_cxp_1_cglposteo as
select adc_cxp_1.documento, adc_cxp_1.consecutivo as consecutivo, cglposteo.compania, 
cglposteo.consecutivo as cgl_consecutivo, 
cglposteo.cuenta, cglposteo.debito, cglposteo.credito,
cxpmotivos.desc_motivo_cxp
from rela_adc_cxp_1_cglposteo, cglposteo, cxpmotivos, adc_cxp_1
where rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
and adc_cxp_1.motivo_cxp = cxpmotivos.motivo_cxp
and adc_cxp_1.compania = rela_adc_cxp_1_cglposteo.compania
and adc_cxp_1.consecutivo = rela_adc_cxp_1_cglposteo.consecutivo
and adc_cxp_1.secuencia = rela_adc_cxp_1_cglposteo.secuencia;


create view v_adc_cxc_1 as
select gralcompanias.*, adc_cxc_1.consecutivo, cxcmotivos.desc_motivo_cxc,
adc_cxc_1.secuencia, adc_cxc_1.fecha, adc_cxc_1.monto,
clientes.nomb_cliente, clientes.cliente,
trim(adc_cxc_1.observacion) as observacion,
trim(adc_cxc_1.documento) as documento
from adc_manifiesto, adc_cxc_1, cxcmotivos, gralcompanias, 
fact_referencias, clientes
where adc_manifiesto.compania = adc_cxc_1.compania
and adc_manifiesto.consecutivo = adc_cxc_1.consecutivo
and adc_cxc_1.motivo_cxc = cxcmotivos.motivo_cxc
and adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.referencia = fact_referencias.referencia
and fact_referencias.tipo = 'I'
and adc_manifiesto.from_agent = clientes.cliente
and adc_cxc_1.cliente is null
union
select gralcompanias.*, adc_cxc_1.consecutivo, cxcmotivos.desc_motivo_cxc,
adc_cxc_1.secuencia, adc_cxc_1.fecha, adc_cxc_1.monto,
clientes.nomb_cliente, clientes.cliente,
trim(adc_cxc_1.observacion),
trim(adc_cxc_1.documento) as documento
from adc_manifiesto, adc_cxc_1, cxcmotivos, gralcompanias, 
fact_referencias, clientes
where adc_manifiesto.compania = adc_cxc_1.compania
and adc_manifiesto.consecutivo = adc_cxc_1.consecutivo
and adc_cxc_1.motivo_cxc = cxcmotivos.motivo_cxc
and adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.referencia = fact_referencias.referencia
and fact_referencias.tipo <> 'I'
and adc_manifiesto.to_agent = clientes.cliente
and adc_cxc_1.cliente is null
union
select gralcompanias.*, adc_cxc_1.consecutivo, cxcmotivos.desc_motivo_cxc,
adc_cxc_1.secuencia, adc_cxc_1.fecha, adc_cxc_1.monto,
clientes.nomb_cliente, clientes.cliente,
trim(adc_cxc_1.observacion),
trim(adc_cxc_1.documento) as documento
from adc_manifiesto, adc_cxc_1, cxcmotivos, gralcompanias, 
fact_referencias, clientes
where adc_manifiesto.compania = adc_cxc_1.compania
and adc_manifiesto.consecutivo = adc_cxc_1.consecutivo
and adc_cxc_1.motivo_cxc = cxcmotivos.motivo_cxc
and adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_cxc_1.cliente = clientes.cliente;


create view v_adc_cxc_1_cglposteo as
select adc_cxc_1.documento, adc_cxc_1.consecutivo as consecutivo, cglposteo.compania, 
cglposteo.consecutivo as cgl_consecutivo, 
cglposteo.cuenta, cglposteo.debito, cglposteo.credito,
cxcmotivos.desc_motivo_cxc
from rela_adc_cxc_1_cglposteo, cglposteo, cxcmotivos, adc_cxc_1
where rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
and adc_cxc_1.motivo_cxc = cxcmotivos.motivo_cxc
and adc_cxc_1.compania = rela_adc_cxc_1_cglposteo.compania
and adc_cxc_1.consecutivo = rela_adc_cxc_1_cglposteo.consecutivo
and adc_cxc_1.secuencia = rela_adc_cxc_1_cglposteo.secuencia;


create view v_adc_house_cglposteo as
select adc_house.compania, adc_house.consecutivo, adc_house.cliente, adc_house.cod_destino, 
adc_house.embarcador, adc_house.no_house, adc_house.observacion,
adc_house_factura1.almacen, adc_house_factura1.tipo, adc_house_factura1.num_documento, 
cglposteo.consecutivo as cgl_consecutivo, cglposteo.cuenta, cglposteo.debito, cglposteo.credito
from adc_house, adc_house_factura1, rela_factura1_cglposteo, cglposteo
where adc_house.compania = adc_house_factura1.compania
and adc_house.consecutivo = adc_house_factura1.consecutivo
and adc_house.linea_master = adc_house_factura1.linea_master
and adc_house.linea_house = adc_house_factura1.linea_house
and adc_house_factura1.almacen = rela_factura1_cglposteo.almacen
and adc_house_factura1.tipo = rela_factura1_cglposteo.tipo
and adc_house_factura1.num_documento = rela_factura1_cglposteo.num_documento
and rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo;

create view v_adc_master_cglposteo as
select adc_master.*, cglposteo.consecutivo as cgl_consecutivo, 
cglposteo.cuenta, cglposteo.debito, cglposteo.credito
from adc_master, rela_adc_master_cglposteo, cglposteo
where adc_master.compania = rela_adc_master_cglposteo.compania
and adc_master.consecutivo = rela_adc_master_cglposteo.consecutivo
and adc_master.linea_master = rela_adc_master_cglposteo.linea_master
and rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo;



create view v_adc_manifiesto_contable as
select 'COSTOS' AS rubro, adc_master.compania, adc_master.consecutivo, 
adc_master.linea_master, adc_manifiesto.no_referencia, adc_master.no_bill, 
adc_master.container, cglposteo.cuenta, cglposteo.debito, cglposteo.credito, 0 AS factura, 
adc_manifiesto.fecha, adc_manifiesto.cod_naviera, fact_referencias.descripcion, 
fact_referencias.tipo, adc_manifiesto.to_agent, adc_manifiesto.from_agent, 
adc_manifiesto.ciudad_origen, adc_manifiesto.ciudad_destino, adc_manifiesto.vapor, adc_master.observacion
FROM adc_master, cglposteo, rela_adc_master_cglposteo, adc_manifiesto, fact_referencias 
WHERE adc_master.compania = rela_adc_master_cglposteo.compania 
and adc_master.consecutivo = rela_adc_master_cglposteo.consecutivo
AND adc_master.linea_master = rela_adc_master_cglposteo.linea_master
AND rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo
AND adc_manifiesto.compania = adc_master.compania
AND adc_manifiesto.consecutivo = adc_master.consecutivo
AND adc_manifiesto.referencia = fact_referencias.referencia 
UNION 
SELECT 'INGRESOS' AS rubro, adc_master.compania, adc_master.consecutivo, 0 AS linea_master, 
adc_manifiesto.no_referencia, adc_master.no_bill, NULL AS container, cglposteo.cuenta, 
cglposteo.debito, cglposteo.credito, adc_house_factura1.num_documento AS factura, 
adc_manifiesto.fecha, adc_manifiesto.cod_naviera, fact_referencias.descripcion, 
fact_referencias.tipo, adc_manifiesto.to_agent, adc_manifiesto.from_agent, 
adc_manifiesto.ciudad_origen, adc_manifiesto.ciudad_destino, adc_manifiesto.vapor, ''
FROM adc_manifiesto, adc_master, adc_house, adc_house_factura1, 
rela_factura1_cglposteo, cglposteo, fact_referencias 
WHERE adc_manifiesto.compania = adc_master.compania
AND adc_manifiesto.consecutivo = adc_master.consecutivo
AND adc_master.compania = adc_house.compania
AND adc_master.consecutivo = adc_house.consecutivo
AND adc_master.linea_master = adc_house.linea_master
AND adc_house.compania = adc_house_factura1.compania
AND adc_house.consecutivo = adc_house_factura1.consecutivo
AND adc_house.linea_master = adc_house_factura1.linea_master
AND adc_house.linea_house = adc_house_factura1.linea_house
AND adc_house_factura1.almacen = rela_factura1_cglposteo.almacen
AND adc_house_factura1.tipo = rela_factura1_cglposteo.tipo
AND adc_house_factura1.num_documento = rela_factura1_cglposteo.num_documento
AND rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
AND adc_manifiesto.referencia = fact_referencias.referencia
GROUP BY adc_master.compania, adc_master.consecutivo, adc_manifiesto.no_referencia, 
adc_master.no_bill, cglposteo.cuenta, cglposteo.debito, cglposteo.credito, 
adc_house_factura1.num_documento, adc_manifiesto.fecha, adc_manifiesto.cod_naviera, 
fact_referencias.descripcion, fact_referencias.tipo, adc_manifiesto.to_agent, 
adc_manifiesto.from_agent, adc_manifiesto.ciudad_origen, adc_manifiesto.ciudad_destino, 
adc_manifiesto.vapor
UNION 
SELECT 'INGRESOS' AS rubro, adc_master.compania, adc_master.consecutivo, 
adc_master.linea_master, adc_manifiesto.no_referencia, adc_master.no_bill, adc_master.container, 
cglposteo.cuenta, cglposteo.debito, cglposteo.credito, 
adc_manejo_factura1.num_documento AS factura, adc_manifiesto.fecha, 
adc_manifiesto.cod_naviera, fact_referencias.descripcion, fact_referencias.tipo, 
adc_manifiesto.to_agent, adc_manifiesto.from_agent, adc_manifiesto.ciudad_origen, 
adc_manifiesto.ciudad_destino, adc_manifiesto.vapor, ''
FROM adc_manifiesto, adc_master, adc_house, adc_manejo, adc_manejo_factura1, 
rela_factura1_cglposteo, cglposteo, fact_referencias 
WHERE adc_manifiesto.compania = adc_master.compania
AND adc_manifiesto.consecutivo = adc_master.consecutivo
AND adc_master.compania = adc_house.compania
AND adc_master.consecutivo = adc_house.consecutivo
AND adc_master.linea_master = adc_house.linea_master
 AND adc_house.compania = adc_manejo.compania
  AND adc_house.consecutivo = adc_manejo.consecutivo
  AND adc_house.linea_master = adc_manejo.linea_master
  AND adc_house.linea_house = adc_manejo.linea_house
AND adc_manejo.compania = adc_manejo_factura1.compania
AND adc_manejo.consecutivo = adc_manejo_factura1.consecutivo
 AND adc_manejo.linea_master = adc_manejo_factura1.linea_master
 AND adc_manejo.linea_house = adc_manejo_factura1.linea_house
 AND adc_manejo.linea_manejo = adc_manejo_factura1.linea_manejo
 AND adc_manejo_factura1.almacen = rela_factura1_cglposteo.almacen
  AND adc_manejo_factura1.tipo = rela_factura1_cglposteo.tipo
   AND adc_manejo_factura1.num_documento = rela_factura1_cglposteo.num_documento
    AND rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
    AND adc_manifiesto.referencia = fact_referencias.referencia;


create view v_adc_facturas_x_master as
select adc_house_factura1.compania, adc_house_factura1.consecutivo, adc_house_factura1.linea_master, 
adc_house_factura1.almacen, adc_house_factura1.tipo, adc_house_factura1.num_documento
from adc_house_factura1, factmotivos
where adc_house_factura1.tipo = factmotivos.tipo
and factmotivos.factura = 'S'
union 
select adc_manejo_factura1.compania, adc_manejo_factura1.consecutivo, adc_manejo_factura1.linea_master, 
adc_manejo_factura1.almacen, adc_manejo_factura1.tipo, adc_manejo_factura1.num_documento
from adc_manejo_factura1, factmotivos
where adc_manejo_factura1.tipo = factmotivos.tipo
and factmotivos.factura = 'S';



/*
create view v_adc_manifiesto_contable as
select 'COSTOS' as rubro, adc_master.compania, adc_master.consecutivo, adc_master.linea_master, 
    adc_manifiesto.no_referencia,
    adc_master.no_bill, adc_master.container, cglposteo.cuenta, cglposteo.debito, 
    cglposteo.credito, 0 as factura, adc_manifiesto.fecha, adc_manifiesto.cod_naviera, 
    fact_referencias.descripcion, fact_referencias.tipo,
    adc_manifiesto.to_agent, adc_manifiesto.from_agent, adc_manifiesto.ciudad_origen, adc_manifiesto.ciudad_destino, adc_manifiesto.vapor
from adc_master, cglposteo, rela_adc_master_cglposteo, adc_manifiesto, fact_referencias
where adc_master.compania = rela_adc_master_cglposteo.compania
and adc_master.consecutivo = rela_adc_master_cglposteo.consecutivo
and adc_master.linea_master = rela_adc_master_cglposteo.linea_master
and rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
union
select 'INGRESOS', adc_master.compania, adc_master.consecutivo, adc_master.linea_master, adc_manifiesto.no_referencia,
    adc_master.no_bill, adc_master.container, cglposteo.cuenta, cglposteo.debito, cglposteo.credito, adc_house_factura1.num_documento,
    adc_manifiesto.fecha, adc_manifiesto.cod_naviera, fact_referencias.descripcion, fact_referencias.tipo,
    adc_manifiesto.to_agent, adc_manifiesto.from_agent, adc_manifiesto.ciudad_origen, adc_manifiesto.ciudad_destino, adc_manifiesto.vapor
from adc_manifiesto, adc_master, adc_house, adc_house_factura1, 
    rela_factura1_cglposteo, cglposteo, fact_referencias
where adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_house.compania = adc_house_factura1.compania
and adc_house.consecutivo = adc_house_factura1.consecutivo
and adc_house.linea_master = adc_house_factura1.linea_master
and adc_house.linea_house = adc_house_factura1.linea_house
and adc_house_factura1.almacen = rela_factura1_cglposteo.almacen
and adc_house_factura1.tipo = rela_factura1_cglposteo.tipo
and adc_house_factura1.num_documento = rela_factura1_cglposteo.num_documento
and rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
union
select 'INGRESOS', adc_master.compania, adc_master.consecutivo, adc_master.linea_master, adc_manifiesto.no_referencia,
    adc_master.no_bill, adc_master.container, cglposteo.cuenta, cglposteo.debito, cglposteo.credito, adc_manejo_factura1.num_documento,
    adc_manifiesto.fecha, adc_manifiesto.cod_naviera, fact_referencias.descripcion, fact_referencias.tipo,
    adc_manifiesto.to_agent, adc_manifiesto.from_agent, adc_manifiesto.ciudad_origen, adc_manifiesto.ciudad_destino, adc_manifiesto.vapor
from adc_manifiesto, adc_master, adc_house, adc_manejo, adc_manejo_factura1, 
    rela_factura1_cglposteo, cglposteo, fact_referencias
where adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_house.compania = adc_manejo.compania
and adc_house.consecutivo = adc_manejo.consecutivo
and adc_house.linea_master = adc_manejo.linea_master
and adc_house.linea_house = adc_manejo.linea_house
and adc_manejo.compania = adc_manejo_factura1.compania
and adc_manejo.consecutivo = adc_manejo_factura1.consecutivo
and adc_manejo.linea_master = adc_manejo_factura1.linea_master
and adc_manejo.linea_house = adc_manejo_factura1.linea_house
and adc_manejo.linea_manejo = adc_manejo_factura1.linea_manejo
and adc_manejo_factura1.almacen = rela_factura1_cglposteo.almacen
and adc_manejo_factura1.tipo = rela_factura1_cglposteo.tipo
and adc_manejo_factura1.num_documento = rela_factura1_cglposteo.num_documento
and rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia;
*/                                
