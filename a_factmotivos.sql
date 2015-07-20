
begin work;
alter table factmotivos
add column factura_fiscal char(1);

update factmotivos
set factura_fiscal = 'N';

alter table factmotivos
alter column factura_fiscal set not null;

commit work;
