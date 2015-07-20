alter table adc_house add column fecha_retencion date;

alter table adc_house add column co_loader_destino varchar(100);

alter table adc_house add column co_loader_naviera char(2);


alter table adc_house
   add constraint fk_adc_hous_reference_navieras foreign key (co_loader_naviera)
      references navieras (cod_naviera)
      on delete restrict on update restrict;
