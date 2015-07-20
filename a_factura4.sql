rollback work;
begin work;
alter table factura4 rename column monto to monto2;
alter table factura4 add column monto decimal(10,2);
update factura4 set monto = monto2;
alter table factura4 alter column monto set not null;
alter table factura4 drop column monto2 cascade;
commit work;



