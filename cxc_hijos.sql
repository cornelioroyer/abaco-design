drop view cxc_hijos;
CREATE VIEW cxc_hijos AS
    SELECT 'CXC' AS aplicacion, a.almacen, a.cliente, a.docm_ajuste_cxc, b.aplicar_a, 
    a.motivo_cxc, b.motivo_cxc AS motivo_ref, a.fecha_posteo_ajuste_cxc AS fecha_posteo, 
    sum(b.monto) AS monto FROM cxctrx1 a, cxctrx2 b, cxcdocm c 
    WHERE a.sec_ajuste_cxc = b.sec_ajuste_cxc 
    AND a.almacen = b.almacen
    AND c.almacen = b.almacen
    AND c.cliente = a.cliente
    AND trim(c.documento) = trim(b.aplicar_a)
    AND trim(c.docmto_aplicar) = trim(b.aplicar_a)
    AND c.motivo_cxc = b.motivo_cxc
    and cxctrx2.monto <> 0
    GROUP BY a.almacen, a.cliente, a.docm_ajuste_cxc, b.aplicar_a, 
    a.motivo_cxc, b.motivo_cxc, a.fecha_posteo_ajuste_cxc;