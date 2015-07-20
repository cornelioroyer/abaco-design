delete from cglposteoaux1;
delete from rela_bcocheck1_cglposteo;
delete from rela_caja_trx1_cglposteo;
delete from rela_cxpajuste1_cglposteo;
delete from rela_cxpfact1_cglposteo;
delete from rela_eys1_cglposteo;

alter table adc_manifiesto_contable
   drop constraint fk_adc_mani_reference_cglposte ;
alter table adc_manifiesto_contable
   add constraint fk_adc_mani_reference_cglposte foreign key (cgl_consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table cglposteoaux1
   drop constraint fk_cglposte_ref_8370_cglposte ;
alter table cglposteoaux1
   add constraint fk_cglposte_ref_8370_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table cglposteoaux2
   drop constraint fk_cglposte_ref_8374_cglposte ;
alter table cglposteoaux2
   add constraint fk_cglposte_ref_8374_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_activos_cglposteo
   drop constraint fk_rela_act_reference_cglposte ;
alter table rela_activos_cglposteo
   add constraint fk_rela_act_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_adc_cxc_1_cglposteo
   drop constraint fk_rela_adc_reference_cglposte ;
alter table rela_adc_cxc_1_cglposteo
   add constraint fk_rela_adc_reference_cglposte foreign key (cgl_consecutivo)
      references cglposteo (consecutivo)
      on delete restrict on update cascade;

alter table rela_adc_cxp_1_cglposteo
   drop constraint fk_rela_adc_reference_cglposte ;
alter table rela_adc_cxp_1_cglposteo
   add constraint fk_rela_adc_reference_cglposte foreign key (cgl_consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_adc_master_cglposteo
   drop constraint fk_rela_adc_reference_cglposte ;
alter table rela_adc_master_cglposteo
   add constraint fk_rela_adc_reference_cglposte foreign key (cgl_consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_afi_cglposteo
   drop constraint fk_rela_afi_ref_12219_cglposte ;
alter table rela_afi_cglposteo
   add constraint fk_rela_afi_ref_12219_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_afi_trx1_cglposteo
   drop constraint fk_rela_afi_reference_cglposte ;
alter table rela_afi_trx1_cglposteo
   add constraint fk_rela_afi_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_bcocheck1_cglposteo
   drop constraint fk_rela_bco_ref_70281_cglposte ;
alter table rela_bcocheck1_cglposteo
   add constraint fk_rela_bco_ref_70281_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_bcotransac1_cglposteo
   drop constraint fk_rela_bco_ref_70293_cglposte ;
alter table rela_bcotransac1_cglposteo
   add constraint fk_rela_bco_ref_70293_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_caja_trx1_cglposteo
   drop constraint fk_rela_caj_ref_11997_cglposte ;
alter table rela_caja_trx1_cglposteo
   add constraint fk_rela_caj_ref_11997_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_cgl_comprobante1_cglposteo
   drop constraint fk_rela_cgl_reference_cglposte ;
alter table rela_cgl_comprobante1_cglposteo
   add constraint fk_rela_cgl_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_cglcomprobante1_cglposteo
   drop constraint fk_rela_cgl_reference_cglposte ;
alter table rela_cglcomprobante1_cglposteo
   add constraint fk_rela_cgl_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_cxc_recibo1_cglposteo
   drop constraint fk_rela_cxc_reference_cglposte ;
alter table rela_cxc_recibo1_cglposteo
   add constraint fk_rela_cxc_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_cxcfact1_cglposteo
   drop constraint fk_rela_cxc_ref_70298_cglposte ;
alter table rela_cxcfact1_cglposteo
   add constraint fk_rela_cxc_ref_70298_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_cxctrx1_cglposteo
   drop constraint fk_rela_cxc_ref_71933_cglposte ;
alter table rela_cxctrx1_cglposteo
   add constraint fk_rela_cxc_ref_71933_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_cxpajuste1_cglposteo
   drop constraint fk_rela_cxp_ref_70325_cglposte ;
alter table rela_cxpajuste1_cglposteo
   add constraint fk_rela_cxp_ref_70325_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_cxpfact1_cglposteo
   drop constraint fk_rela_cxp_ref_70310_cglposte ;
alter table rela_cxpfact1_cglposteo
   add constraint fk_rela_cxp_ref_70310_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_eys1_cglposteo
   drop constraint fk_rela_eys_ref_71945_cglposte ;
alter table rela_eys1_cglposteo
   add constraint fk_rela_eys_ref_71945_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_factura1_cglposteo
   drop constraint fk_rela_fac_ref_11999_cglposte ;
alter table rela_factura1_cglposteo
   add constraint fk_rela_fac_ref_11999_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_nomctrac_cglposteo
   drop constraint fk_rela_nom_reference_cglposte ;
alter table rela_nomctrac_cglposteo
   add constraint fk_rela_nom_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
alter table rela_pla_reservas_cglposteo
   drop constraint fk_rela_pla_reference_cglposte ;
alter table rela_pla_reservas_cglposteo
   add constraint fk_rela_pla_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
