drop view v_cxp_facturas_por_rubros;
create view v_cxp_facturas_por_rubros as
select cxpfact1.compania,  gralcompanias.nombre,
        proveedores.nomb_proveedor, proveedores.proveedor,   
         cxpfact1.fecha_posteo_fact_cxp,   
         cxpfact1.fact_proveedor,   
         cxpfact2.rubro_fact_cxp,   
         cxpfact1.obs_fact_cxp,   
         rubros_fact_cxp.orden,   
         (cxpfact2.monto * rubros_fact_cxp.signo_rubro_fact_cxp) as monto
    FROM cxpfact1,   
         cxpfact2,   
         rubros_fact_cxp,   
         proveedores,   
         gralcompanias  
   WHERE cxpfact2.proveedor = cxpfact1.proveedor and  
         cxpfact1.compania = cxpfact2.compania and  
         cxpfact2.fact_proveedor = cxpfact1.fact_proveedor and  
         cxpfact2.rubro_fact_cxp = rubros_fact_cxp.rubro_fact_cxp and  
         proveedores.proveedor = cxpfact1.proveedor and  
         gralcompanias.compania = cxpfact1.compania
