alter table pla_acreedores
   drop constraint fk_pla_acre_reference_pla_comp ;
alter table pla_acreedores
   add constraint fk_pla_acre_reference_pla_comp foreign key (compania)
      references pla_companias (compania)
      on delete restrict on update restrict;
alter table pla_bancos
   drop constraint fk_pla_banc_reference_pla_comp ;
alter table pla_bancos
   add constraint fk_pla_banc_reference_pla_comp foreign key (compania)
      references pla_companias (compania)
      on delete restrict on update restrict;
alter table pla_cargos
   drop constraint fk_pla_carg_reference_pla_comp ;
alter table pla_cargos
   add constraint fk_pla_carg_reference_pla_comp foreign key (compania)
      references pla_companias (compania)
      on delete restrict on update cascade;
alter table pla_cuentas
   drop constraint fk_pla_cuen_reference_pla_comp ;
alter table pla_cuentas
   add constraint fk_pla_cuen_reference_pla_comp foreign key (compania)
      references pla_companias (compania)
      on delete restrict on update restrict;
alter table pla_departamentos
   drop constraint fk_pla_depa_reference_pla_comp ;
alter table pla_departamentos
   add constraint fk_pla_depa_reference_pla_comp foreign key (compania)
      references pla_companias (compania)
      on delete restrict on update cascade;
alter table pla_dias_feriados
   drop constraint fk_pla_dias_reference_pla_comp ;
alter table pla_dias_feriados
   add constraint fk_pla_dias_reference_pla_comp foreign key (compania)
      references pla_companias (compania)
      on delete restrict on update cascade;
alter table pla_empleados
   drop constraint fk_pla_empl_reference_pla_comp ;
alter table pla_empleados
   add constraint fk_pla_empl_reference_pla_comp foreign key (compania)
      references pla_companias (compania)
      on delete restrict on update cascade;
alter table pla_parametros
   drop constraint fk_pla_para_reference_pla_comp ;
alter table pla_parametros
   add constraint fk_pla_para_reference_pla_comp foreign key (compania)
      references pla_companias (compania)
      on delete restrict on update restrict;
alter table pla_parametros_contables
   drop constraint fk_pla_para_reference_pla_comp ;
alter table pla_parametros_contables
   add constraint fk_pla_para_reference_pla_comp foreign key (compania)
      references pla_companias (compania)
      on delete restrict on update cascade;
alter table pla_proyectos
   drop constraint fk_pla_proy_reference_pla_comp ;
alter table pla_proyectos
   add constraint fk_pla_proy_reference_pla_comp foreign key (compania)
      references pla_companias (compania)
      on delete restrict on update restrict;
alter table pla_tipos_de_planilla
   drop constraint fk_pla_tipo_reference_pla_comp ;
alter table pla_tipos_de_planilla
   add constraint fk_pla_tipo_reference_pla_comp foreign key (compania)
      references pla_companias (compania)
      on delete restrict on update cascade;
alter table pla_turnos
   drop constraint fk_pla_turn_reference_pla_comp ;
alter table pla_turnos
   add constraint fk_pla_turn_reference_pla_comp foreign key (compania)
      references pla_companias (compania)
      on delete restrict on update cascade;
