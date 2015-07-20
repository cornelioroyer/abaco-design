

rollback work;
begin work;
alter table clientes add column dv char(2);
alter table clientes add column tipo_de_persona char(1);
alter table clientes add column concepto char(1);
alter table clientes add column tipo_de_compra char(1);

update clientes
set dv = '00', tipo_de_persona = '1', concepto = '1', tipo_de_compra = '1';

/*
alter table clientes alter column dv set not null;
alter table clientes alter column tipo_de_persona set not null;
alter table clientes alter column concepto set not null;
alter table clientes alter column tipo_de_compra set not null;
*/
commit work;
