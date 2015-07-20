















drop index i_fk_pla_rese_reference_pla_conc cascade;

create index i_fk_pla_rese_reference_pla_conc on pla_reservas_pp (concepto);

alter table pla_reservas_pp
   drop constraint fk_pla_rese_reference_pla_conc cascade;

alter table pla_reservas_pp
   add constraint fk_pla_rese_reference_pla_conc foreign key (concepto)
      references pla_conceptos (concepto)
      on delete restrict on update restrict;

/*
drop index i_fk_pla_rete_reference_pla_conc cascade;

create index i_fk_pla_rete_reference_pla_conc on pla_retenciones (concepto);

alter table pla_retenciones
   drop constraint fk_pla_rete_reference_pla_conc cascade;

alter table pla_retenciones
   add constraint fk_pla_rete_reference_pla_conc foreign key (concepto)
      references pla_conceptos (concepto)
      on delete restrict on update restrict;


drop index i_fk_pla_ries_reference_pla_conc cascade;

create index i_fk_pla_ries_reference_pla_conc on pla_riesgos_profesionales (concepto);

alter table pla_riesgos_profesionales
   drop constraint fk_pla_ries_reference_pla_conc cascade;

alter table pla_riesgos_profesionales
   add constraint fk_pla_ries_reference_pla_conc foreign key (concepto)
      references pla_conceptos (concepto)
      on delete restrict on update cascade;
*/
