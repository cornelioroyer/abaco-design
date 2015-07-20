
rollback work;

begin work;

alter table div_movimientos
add column compania char(2);

update div_movimientos
set compania = '03';

alter table div_movimientos
alter column compania set not null;

alter table div_movimientos
   drop constraint pk_div_movimientos;

alter table div_movimientos
   add constraint pk_div_movimientos primary key (compania, socio, fecha);

alter table div_movimientos
   add constraint fk_div_movi_reference_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete cascade on update cascade;

commit work;

