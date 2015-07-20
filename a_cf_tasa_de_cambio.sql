// alter table cf_tasa_de_cambio rename column factor to factor1;

alter table cf_tasa_de_cambio add column factor decimal(20,10);

update cf_tasa_de_cambio
set factor = factor1;

alter table cf_tasa_de_cambio drop column factor1;
