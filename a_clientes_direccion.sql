

rollback work;
begin work;
drop view v_apc_clientes;
drop view v_apc_refere;
drop view v_adc_notificacion;
alter table clientes alter column direccion1 type varchar(80);
alter table clientes alter column direccion2 type varchar(80);
alter table clientes alter column direccion3 type varchar(80);
alter table clientes add column contacto varchar(100);
commit work;
