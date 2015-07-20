

rollback work;
begin work;
alter table div_parametros_de_pago add column compania char(2);

update div_parametros_de_pago set compania = '03';

alter table div_parametros_de_pago
   drop constraint pk_div_parametros_de_pago cascade;

alter table div_parametros_de_pago
   add constraint pk_div_parametros_de_pago primary key (compania, fecha);

commit work;
