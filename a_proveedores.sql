
alter table proveedores add column tipo_de_persona char(1);
alter table proveedores add column concepto char(1);
alter table proveedores add column tipo_de_compra char(1);



update proveedores set tipo_de_persona = '2', concepto = '1', tipo_de_compra = '1';
