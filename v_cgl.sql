drop view cgl_cglposteo;
drop view cgl_saldo_aux1;
drop view cxp_ajustes_madres;
drop view cxc_cxcfact1;
drop view cxc_madres;


CREATE VIEW cgl_cglposteo AS
    SELECT cglposteo.compania, cglposteo.cuenta, cglcuentas.nombre, 
    cglposteo."year", 
    cglposteo.periodo, sum((cglposteo.debito - cglposteo.credito)) AS monto 
FROM cglposteo, cglcuentas 
WHERE ((cglcuentas.cuenta = cglposteo.cuenta) 
AND (cglcuentas.tipo_cuenta = 'R'::bpchar)) 
GROUP BY cglposteo.compania, cglposteo.cuenta, cglcuentas.nombre, 
cglposteo."year", cglposteo.periodo;

 CREATE VIEW cgl_saldo_aux1 AS
    SELECT a.compania, a.cuenta, b.auxiliar, sum((b.debito - b.credito)) AS saldo 
    FROM cglposteo a, cglposteoaux1 b 
    WHERE (a.consecutivo = b.consecutivo) 
    GROUP BY a.compania, a.cuenta, b.auxiliar;
    
    
    
CREATE VIEW cxc_cxcfact1 AS
SELECT 'CXC' AS aplicacion, a.almacen, a.cliente, a.no_factura, 
a.motivo_cxc, a.fecha_posteo_fact AS fecha_posteo, 
a.fecha_vence_fact AS fecha_vencimiento, 
(- sum((b.monto * "numeric"(c.signo_rubro_fact_cxc)))) AS monto 
FROM cxcfact1 a, cxcfact2 b, rubros_fact_cxc c 
WHERE (((a.almacen = b.almacen) AND (a.no_factura = b.no_factura)) 
AND (b.rubro_fact_cxc = c.rubro_fact_cxc)) 
GROUP BY a.aplicacion, a.almacen, a.cliente, a.no_factura, a.motivo_cxc, 
a.fecha_posteo_fact, a.fecha_vence_fact;


CREATE VIEW cxc_madres AS
SELECT 'CXC' AS aplicacion, cxctrx1.almacen, cxctrx1.cliente, 
cxctrx1.docm_ajuste_cxc AS documento, cxctrx1.motivo_cxc, 
cxctrx1.fecha_posteo_ajuste_cxc AS fecha_posteo, 
sum((cxctrx1.cheque + cxctrx1.efectivo)) AS monto, cxctrx1.referencia 
FROM cxctrx1 
WHERE (NOT (EXISTS (SELECT cxctrx2.aplicar_a, cxctrx2.sec_ajuste_cxc, cxctrx2.almacen, 
cxctrx2.motivo_cxc, cxctrx2.monto 
FROM cxctrx2 
WHERE ((cxctrx2.almacen = cxctrx1.almacen) 
AND (cxctrx2.sec_ajuste_cxc = cxctrx1.sec_ajuste_cxc))))) 
GROUP BY cxctrx1.almacen, cxctrx1.cliente, cxctrx1.docm_ajuste_cxc, 
cxctrx1.motivo_cxc, cxctrx1.fecha_posteo_ajuste_cxc, cxctrx1.referencia;

CREATE VIEW cxp_ajustes_madres AS    
SELECT cxpajuste1.aplicacion, cxpajuste1.compania, cxpajuste1.proveedor, 
cxpajuste1.docm_ajuste_cxp, cxpajuste1.motivo_cxp, sum(cxpajuste3.monto) AS monto, 
cxpajuste1.fecha_posteo_ajuste_cxp 
FROM cxpajuste1, cxpajuste3 
WHERE (((cxpajuste1.compania = cxpajuste3.compania) 
AND (cxpajuste1.sec_ajuste_cxp = cxpajuste3.sec_ajuste_cxp)) 
AND (NOT (EXISTS (SELECT cxpajuste2.compania, cxpajuste2.sec_ajuste_cxp, 
cxpajuste2.aplicar_a, cxpajuste2.motivo_cxp, cxpajuste2.monto 
FROM cxpajuste2 WHERE ((cxpajuste2.compania = cxpajuste1.compania) 
AND (cxpajuste2.sec_ajuste_cxp = cxpajuste1.sec_ajuste_cxp)))))) 
GROUP BY cxpajuste1.aplicacion, cxpajuste1.compania, cxpajuste1.proveedor, 
cxpajuste1.docm_ajuste_cxp, cxpajuste1.motivo_cxp, cxpajuste1.fecha_posteo_ajuste_cxp;





