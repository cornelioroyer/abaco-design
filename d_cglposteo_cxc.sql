

rollback work;

begin work;
    delete from cglposteo
    where compania = '01'
    and fecha_comprobante between '2014-08-01' and '2016-12-31'
    and aplicacion_origen in ('CXC');
commit work;

begin work;
    delete from cglposteo
    where compania = '01'
    and fecha_comprobante between '2014-08-01' and '2016-12-31'
    and aplicacion_origen in ('FAC');
commit work;


/*
begin work;
    select f_postea_fac('01');
commit work;

begin work;
    select f_postea_cxc('01');
commit work;

*/


