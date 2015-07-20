rollback work;
begin work;
alter table adc_si
add column c_final_destination char(2);

alter table adc_si
   add constraint fk_adc_si_ref2_destinos foreign key (c_final_destination)
      references destinos (cod_destino)
      on delete restrict on update cascade;


alter table adc_si
add column sh_peso decimal(12,4);

alter table adc_si
add column sh_unidad_medida_peso char(10);

alter table adc_si
   add constraint fk_adc_si_ref_unidad_m foreign key (sh_unidad_medida_peso)
      references unidad_medida (unidad_medida)
      on delete restrict on update restrict;

alter table adc_si
add column sh_mbl char(1);

alter table adc_si
add column sh_hbl char(1);

alter table adc_si
add column sh_fob_cif char(1);

alter table adc_si
add column t_agente_destino char(10);

alter table adc_si
   add constraint fk_adc_si_ref_clientes foreign key (t_agente_destino)
      references clientes (cliente)
      on delete restrict on update cascade;
commit work;