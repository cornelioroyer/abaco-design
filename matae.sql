  SELECT cxcdocm.documento,   
         cxcdocm.docmto_aplicar,   
         cxcdocm.cliente,   
         cxcdocm.motivo_cxc,   
         cxcdocm.almacen,   
         cxcdocm.docmto_ref,   
         cxcdocm.motivo_ref,   
         cxcdocm.fecha_docmto,   
         f_saldo_documento_cxc(cxcdocm.almacen, cxcdocm.caja, cxcdocm.cliente,cxcdocm.motivo_cxc,cxcdocm.documento, current_date) as saldo,   
         cxcdocm.caja  
    FROM clientes,   
         cxcdocm,   
         cxcmotivos,   
         gralcompanias,   
         almacen  
   WHERE clientes.cliente = cxcdocm.cliente  and  
         cxcmotivos.motivo_cxc = cxcdocm.motivo_cxc  and  
         cxcdocm.almacen = almacen.almacen  and  
         almacen.compania = gralcompanias.compania and  
         cxcdocm.fecha_posteo <= current_date  AND  
         cxcdocm.documento = cxcdocm.docmto_aplicar  AND  
         cxcdocm.motivo_cxc = cxcdocm.motivo_ref  
         AND cxcdocm.cliente = '0022'
         and cxcdocm.documento = '4702'
ORDER BY cxcdocm.cliente ASC,   
         cxcdocm.fecha_docmto ASC,   
         cxcdocm.documento ASC   
