alter table navieras
add column proveedor char(6) references proveedores;

update navieras
set proveedor = '1841';

alter table navieras
alter column proveedor set not null;

alter table fact_referencias
add column tipo char(1);

update fact_referencias
set tipo = 'I';

alter table fact_referencias
alter column tipo set not null;

drop index i1_as_parametros_contables cascade;

drop table as_parametros_contables cascade;

create table as_parametros_contables (
referencia           char(2)              not null,
ciudad               char(10)             not null,
cta_ingreso          char(24)             not null,
cta_costo            char(24)             not null
);

alter table as_parametros_contables
   add constraint pk_as_parametros_contables primary key (referencia, ciudad);

create unique index i1_as_parametros_contables on as_parametros_contables (
referencia,
ciudad
);

alter table as_parametros_contables
   add constraint fk_as_param_reference_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update cascade;

alter table as_parametros_contables
   add constraint fk_as_param_reference_fac_ciud foreign key (ciudad)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;

alter table as_parametros_contables
   add constraint fk_as_param_reference_cglcuent foreign key (cta_ingreso)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table as_parametros_contables
   add constraint fk_as_param_reference_cglcuent foreign key (cta_costo)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;





