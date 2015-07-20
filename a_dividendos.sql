begin work;
alter table div_socios add column compania char(2);


alter table div_socios
   drop constraint pk_div_socios cascade;

alter table div_socios
   add constraint pk_div_socios primary key (compania, socio);


commit work;
