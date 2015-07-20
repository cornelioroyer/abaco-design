drop view v_adc_facturacion;
drop view v_adc_facturacion_carga_suelta;

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