
rollback work;

begin work;

alter table fac_cajas
add column puerto_fiscal varchar(10);

update fac_cajas
set puerto_fiscal = 'COM1';

alter table fac_cajas
alter column puerto_fiscal set not null;


alter table fac_cajas
add column sec_devolucion int4;

update fac_cajas
set sec_devolucion = 0;

alter table fac_cajas
alter column sec_devolucion set not null;

commit work;
