rollback work;
begin work;
update factura1
set fecha_despacho = fecha_factura
where fecha_despacho <> fecha_factura
and fecha_factura >= '2006-04-01'
and fecha_despacho >= '2006-04-01'
and despachar = 'S';
commit work;

/*
begin work;
delete from cxcdocm
where fecha_posteo >= '2006-04-01';
commit work;

begin work;
delete from cxpdocm
where fecha_posteo >= '2006-04-01'
and documento = docmto_aplicar;
commit work;
*/
