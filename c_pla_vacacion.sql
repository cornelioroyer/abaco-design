create table tmp_pla_vacacion as select * from pla_vacacion;

drop table pla_vacacion cascade;

create table pla_vacacion (
compania             char(2)              not null,
codigo_empleado      char(7)              not null,
f_corte              date                 not null,
pagar_desde          date                 not null,
pagar_hasta          date                 not null,
status               char(1)              not null,
constraint pk_pla_vacacion primary key (codigo_empleado, compania, f_corte)
);

alter table pla_vacacion
   add constraint fk_pla_vaca_reference_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

insert into pla_vacacion (compania, codigo_empleado, f_corte,
pagar_desde, pagar_hasta, status)
select compania, codigo_empleado, pagar_desde, pagar_desde, pagar_hasta, status
from tmp_pla_vacacion;
