drop index i1_pla_vacacion cascade;

alter table pla_vacacion
   drop constraint pk_pla_vacacion;

alter table pla_vacacion
   add constraint pk_pla_vacacion primary key (codigo_empleado, compania, f_corte, pagar_desde, pagar_hasta);

create unique index i1_pla_vacacion on pla_vacacion (
compania,
codigo_empleado,
f_corte,
pagar_desde,
pagar_hasta
);

alter table pla_vacacion
   drop constraint fk_pla_vaca_reference_rhuempl;


alter table pla_vacacion
   add constraint fk_pla_vaca_reference_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;