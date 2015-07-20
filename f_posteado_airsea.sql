rollback work;

begin work;
update cxpfact1
set status = 'P'
where fecha_posteo_fact_cxp <= '2003-6-30';

update cxpajuste1
set status = 'P'
where fecha_posteo_ajuste_cxp <= '2003-6-30';
commit work;


begin work;
update factura1
set status = 'P'
where status not in ('A', 'P')
and fecha_factura <= '2003-6-30';
commit work;

begin work;
update bcocheck1
set status = 'P'
where fecha_posteo <= '2003-6-30'
and status not in ('A', 'P');

update bcotransac1
set status = 'P'
where fecha_posteo <= '2003-6-30';
commit work;

begin work;
update caja_trx1
set status = 'P'
where fecha_posteo <= '2003-6-30';
commit work;

begin work;
update cxctrx1
set status = 'P'
where fecha_posteo_ajuste_cxc <= '2003-6-30';
commit work;

