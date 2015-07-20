alter table rhuempl add column gasto_de_representacion decimal(10,2);

update rhuempl
set gasto_de_representacion = 0;

alter table rhuempl alter column gasto_de_representacion set not null;