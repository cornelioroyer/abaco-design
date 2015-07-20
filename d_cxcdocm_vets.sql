begin work;
delete from cxcdocm
where fecha_posteo >= '2007-07-01'
and documento <> docmto_aplicar;
commit work;

begin work;
delete from cxcdocm
where fecha_posteo >= '2007-07-01';
commit work;


begin work;
    select f_update_cxcdocm_fac('02');
commit work;

begin work;
    select f_update_cxcdocm_cxc('02');
commit work;