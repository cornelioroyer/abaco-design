rollback work;
begin work;
delete from cxcdocm
where almacen in
(select almacen from almacen where compania = '03')
and fecha_posteo >= '2006-04-01'
and documento <> docmto_aplicar;
commit work;

begin work;
delete from cxcdocm
where almacen in
(select almacen from almacen where compania = '03')
and fecha_posteo >= '2006-04-01';
commit work;

begin work;
delete from cxpdocm
where compania = '03'
and fecha_posteo >= '2006-04-01'
and documento <> docmto_aplicar;
commit work;

begin work;
delete from cxpdocm
where compania = '03'
and fecha_posteo >= '2006-04-01';
commit work;

begin work;
select f_update_cxpdocm('03');
commit work;

begin work;
select f_update_cxcdocm_fac('03');
commit work;

begin work;
select f_update_cxcdocm_cxc('03');
commit work;