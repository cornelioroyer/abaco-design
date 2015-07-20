
rollback work;


begin work;
    delete from cxpdocm
    where compania = '02'
    and fecha_posteo >= '2015-02-01'
    and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref);
commit work;


/*

select * from cxpdocm
where documento = docmto_aplicar
and motivo_cxp = motivo_cxp_ref
and fecha_posteo >= '2015-02-01'
and exists
(select * from cxpdocm a
where a.compania = cxpdocm.compania
and a.proveedor = cxpdocm.proveedor
and a.docmto_aplicar = cxpdocm.documento
and a.docmto_aplicar_ref = cxpdocm.documento
and a.motivo_cxp_ref = cxpdocm.motivo_cxp
and a.fecha_posteo < cxpdocm.fecha_posteo
and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref))


*/

