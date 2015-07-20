
select * from cxcdocm
where not exists
(select * from cxcdocm a
where a.documento = cxcdocm.docmto_aplicar
and a.caja = cxcdocm.caja_ref
and a.docmto_aplicar = cxcdocm.docmto_ref
and a.cliente = cxcdocm.cliente
and a.motivo_cxc = cxcdocm.motivo_ref
and a.almacen = cxcdocm.almacen_ref)




/*

alter table cxcdocm
   add constraint fk_cxcdocm_reference_cxcdocm foreign key (docmto_aplicar, caja_ref, docmto_ref, cliente, motivo_ref, almacen_ref)
      references cxcdocm (documento, caja, docmto_aplicar, cliente, motivo_cxc, almacen)
      on delete restrict on update restrict;

select * from cxcdocm
where (documento <> docmto_aplicar or motivo_cxc <> motivo_ref)
and not exists
(select * from cxcdocm a
where a.almacen = cxcdocm.almacen_ref
and a.caja = cxcdocm.caja_ref
and a.cliente = cxcdocm.cliente
and trim(a.documento) = trim(cxcdocm.docmto_aplicar)
and trim(a.docmto_aplicar) = trim(cxcdocm.docmto_ref)
and a.motivo_cxc = cxcdocm.motivo_ref);

select * from cxcdocm
where (documento <> docmto_aplicar or motivo_cxc <> motivo_ref)
and not exists
(select * from cxcdocm a
where a.almacen = cxcdocm.almacen_ref
and a.caja = cxcdocm.caja_ref
and a.cliente = cxcdocm.cliente
and trim(a.documento) = trim(cxcdocm.docmto_ref)
and trim(a.docmto_aplicar) = trim(cxcdocm.docmto_ref)
and a.motivo_cxc = cxcdocm.motivo_ref);
*/
