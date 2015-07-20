alter table pla_tarjeta_tiempo
   drop constraint fk_pla_tarj_reference_pla_empl ;
alter table pla_tarjeta_tiempo
   add constraint fk_pla_tarj_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update cascade;
alter table pla_retenciones
   drop constraint fk_pla_rete_reference_pla_empl ;
alter table pla_retenciones
   add constraint fk_pla_rete_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update cascade;
alter table pla_dinero
   drop constraint fk_pla_dine_reference_pla_empl ;
alter table pla_dinero
   add constraint fk_pla_dine_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update cascade;
alter table pla_turnos_rotativos
   drop constraint fk_pla_turn_reference_pla_empl ;
alter table pla_turnos_rotativos
   add constraint fk_pla_turn_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update cascade;
alter table pla_horarios
   drop constraint fk_pla_hora_reference_pla_empl ;
alter table pla_horarios
   add constraint fk_pla_hora_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete cascade on update cascade;
alter table pla_otros_ingresos_variables
   drop constraint fk_pla_otro_reference_pla_empl ;
alter table pla_otros_ingresos_variables
   add constraint fk_pla_otro_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update cascade;
alter table pla_riesgos_profesionales
   drop constraint fk_pla_ries_reference_pla_empl ;
alter table pla_riesgos_profesionales
   add constraint fk_pla_ries_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update cascade;
alter table pla_preelaboradas
   drop constraint fk_pla_pree_reference_pla_empl ;
alter table pla_preelaboradas
   add constraint fk_pla_pree_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update cascade;
alter table pla_vacaciones
   drop constraint fk_pla_vaca_reference_pla_empl ;
alter table pla_vacaciones
   add constraint fk_pla_vaca_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update cascade;
alter table pla_otros_ingresos_fijos
   drop constraint fk_pla_otro_reference_pla_empl ;
alter table pla_otros_ingresos_fijos
   add constraint fk_pla_otro_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update cascade;
alter table pla_certificados_medico
   drop constraint fk_pla_cert_reference_pla_empl ;
alter table pla_certificados_medico
   add constraint fk_pla_cert_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update cascade;
alter table pla_permisos
   drop constraint fk_pla_perm_reference_pla_empl ;
alter table pla_permisos
   add constraint fk_pla_perm_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update cascade;
alter table pla_liquidacion
   drop constraint fk_pla_liqu_reference_pla_empl ;
alter table pla_liquidacion
   add constraint fk_pla_liqu_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update cascade;
alter table pla_auxiliares
   drop constraint fk_pla_auxi_reference_pla_empl ;
alter table pla_auxiliares
   add constraint fk_pla_auxi_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update cascade;
alter table pla_asignacion_de_proyectos
   drop constraint fk_pla_asig_reference_pla_empl ;
alter table pla_asignacion_de_proyectos
   add constraint fk_pla_asig_reference_pla_empl foreign key (compania, codigo_empleado)
      references pla_empleados (compania, codigo_empleado)
      on delete restrict on update restrict;
