
begin work;
delete from cxcdocm
where almacen in (select almacen from almacen where compania = '01')
and fecha_posteo >= '2006-11-01';
commit work;

begin work;
delete from factura1
where almacen in (select almacen from almacen where compania = '01')
and tipo in (select tipo from factmotivos where factura = 'S')
and fecha_factura >= '2006-11-01';
commit work;

begin work;
delete from cglposteo
where compania = '01'
and fecha_comprobante >= '2006-11-01';
commit work;