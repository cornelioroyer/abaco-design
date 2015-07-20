drop view fac_facturas;
CREATE VIEW fac_facturas as 
SELECT 'FAC' AS aplicacion, factura1.almacen, factura1.tipo, factura1.documento, 
factura1.cliente, factura1.fecha_factura, factura1.hbl, 
(- sum(((factura4.monto * (rubros_fact_cxc.signo_rubro_fact_cxc)) * (factmotivos.signo)))) AS monto 
FROM factura1, factmotivos, factura4, rubros_fact_cxc 
WHERE factura1.tipo = factmotivos.tipo
AND factmotivos.factura = 'S'
AND factura1.status > 'A'
AND factura1.almacen = factura4.almacen
AND factura1.tipo = factura4.tipo
AND factura1.num_documento = factura4.num_documento
AND factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
GROUP BY factura1.almacen, factura1.tipo, factura1.documento, factura1.cliente, factura1.fecha_factura, factura1.hbl;

--
