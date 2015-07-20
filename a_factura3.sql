
rollback work;

begin work;

alter table factura3 rename column monto to monto_old;

alter table factura3 add column monto decimal(12,4);

update factura3
set monto = monto_old;

alter table factura3 drop column monto_old cascade;

commit work;
