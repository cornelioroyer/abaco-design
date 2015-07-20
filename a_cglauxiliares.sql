
rollback work;
begin work;
alter table cglauxiliares
add column concepto char(1);

alter table cglauxiliares
add column tipo_de_compra char(1);

update cglauxiliares
set concepto = '1', tipo_de_compra = '1';

alter table cglauxiliares
alter column concepto set not null;

alter table cglauxiliares
alter column tipo_de_compra set not null;

commit work;
