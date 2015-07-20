insert into cxchdocm
select * from tmp_cxcdocm
where not exists
(select * from cxchdocm
where cxchdocm.almacen = tmp_cxcdocm.almacen
and cxchdocm.documento = tmp_cxcdocm.documento
and cxchdocm.docmto_aplicar = tmp_cxcdocm.docmto_aplicar
and cxchdocm.motivo_cxc = tmp_cxcdocm.motivo_cxc
and cxchdocm.cliente = tmp_cxcdocm.cliente)