

drop index i_fk_cglposte_ref_8370_cglposte cascade;

create index i_fk_cglposte_ref_8370_cglposte on cglposteoaux1 (consecutivo);


alter table cglposteoaux1
   drop constraint fk_cglposte_ref_8370_cglposte  cascade;

alter table cglposteoaux1
   add constraint fk_cglposte_ref_8370_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

/*
drop index i_fk_cglposte_ref_8374_cglposte cascade;

create index i_fk_cglposte_ref_8374_cglposte on cglposteoaux2 (consecutivo);


alter table cglposteoaux2
   drop constraint fk_cglposte_ref_8374_cglposte  cascade;

alter table cglposteoaux2
   add constraint fk_cglposte_ref_8374_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;



drop index i_fk_rela_act_reference_cglposte cascade;

create index i_fk_rela_act_reference_cglposte on rela_activos_cglposteo (consecutivo);


alter table rela_activos_cglposteo
   drop constraint fk_rela_act_reference_cglposte  cascade;

alter table rela_activos_cglposteo
   add constraint fk_rela_act_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_adc_reference_cglposte cascade;

create index i_fk_rela_adc_reference_cglposte on rela_adc_cxc_1_cglposteo (cgl_consecutivo);


alter table rela_adc_cxc_1_cglposteo
   drop constraint fk_rela_adc_reference_cglposte  cascade;

alter table rela_adc_cxc_1_cglposteo
   add constraint fk_rela_adc_reference_cglposte foreign key (cgl_consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_adc_reference_cglposte cascade;

create index i_fk_rela_adc_reference_cglposte on rela_adc_cxp_1_cglposteo (cgl_consecutivo);


alter table rela_adc_cxp_1_cglposteo
   drop constraint fk_rela_adc_reference_cglposte  cascade;

alter table rela_adc_cxp_1_cglposteo
   add constraint fk_rela_adc_reference_cglposte foreign key (cgl_consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_adc_reference_cglposte cascade;

create index i_fk_rela_adc_reference_cglposte on rela_adc_master_cglposteo (cgl_consecutivo);


alter table rela_adc_master_cglposteo
   drop constraint fk_rela_adc_reference_cglposte  cascade;

alter table rela_adc_master_cglposteo
   add constraint fk_rela_adc_reference_cglposte foreign key (cgl_consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_afi_ref_12219_cglposte cascade;

create index i_fk_rela_afi_ref_12219_cglposte on rela_afi_cglposteo (consecutivo);


alter table rela_afi_cglposteo
   drop constraint fk_rela_afi_ref_12219_cglposte  cascade;

alter table rela_afi_cglposteo
   add constraint fk_rela_afi_ref_12219_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_afi_reference_cglposte cascade;

create index i_fk_rela_afi_reference_cglposte on rela_afi_trx1_cglposteo (consecutivo);


alter table rela_afi_trx1_cglposteo
   drop constraint fk_rela_afi_reference_cglposte  cascade;

alter table rela_afi_trx1_cglposteo
   add constraint fk_rela_afi_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_bco_ref_70281_cglposte cascade;

create index i_fk_rela_bco_ref_70281_cglposte on rela_bcocheck1_cglposteo (consecutivo);


alter table rela_bcocheck1_cglposteo
   drop constraint fk_rela_bco_ref_70281_cglposte  cascade;

alter table rela_bcocheck1_cglposteo
   add constraint fk_rela_bco_ref_70281_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_bco_ref_70293_cglposte cascade;

create index i_fk_rela_bco_ref_70293_cglposte on rela_bcotransac1_cglposteo (consecutivo);


alter table rela_bcotransac1_cglposteo
   drop constraint fk_rela_bco_ref_70293_cglposte  cascade;

alter table rela_bcotransac1_cglposteo
   add constraint fk_rela_bco_ref_70293_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_caj_ref_11997_cglposte cascade;

create index i_fk_rela_caj_ref_11997_cglposte on rela_caja_trx1_cglposteo (consecutivo);


alter table rela_caja_trx1_cglposteo
   drop constraint fk_rela_caj_ref_11997_cglposte  cascade;

alter table rela_caja_trx1_cglposteo
   add constraint fk_rela_caj_ref_11997_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_cgl_reference_cglposte cascade;

create index i_fk_rela_cgl_reference_cglposte on rela_cgl_comprobante1_cglposteo (consecutivo);


alter table rela_cgl_comprobante1_cglposteo
   drop constraint fk_rela_cgl_reference_cglposte  cascade;

alter table rela_cgl_comprobante1_cglposteo
   add constraint fk_rela_cgl_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_cgl_reference_cglposte cascade;

create index i_fk_rela_cgl_reference_cglposte on rela_cglcomprobante1_cglposteo (consecutivo);


alter table rela_cglcomprobante1_cglposteo
   drop constraint fk_rela_cgl_reference_cglposte  cascade;

alter table rela_cglcomprobante1_cglposteo
   add constraint fk_rela_cgl_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_cxc_reference_cglposte cascade;

create index i_fk_rela_cxc_reference_cglposte on rela_cxc_recibo1_cglposteo (consecutivo);


alter table rela_cxc_recibo1_cglposteo
   drop constraint fk_rela_cxc_reference_cglposte  cascade;

alter table rela_cxc_recibo1_cglposteo
   add constraint fk_rela_cxc_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_cxc_ref_70298_cglposte cascade;

create index i_fk_rela_cxc_ref_70298_cglposte on rela_cxcfact1_cglposteo (consecutivo);


alter table rela_cxcfact1_cglposteo
   drop constraint fk_rela_cxc_ref_70298_cglposte  cascade;

alter table rela_cxcfact1_cglposteo
   add constraint fk_rela_cxc_ref_70298_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_cxc_ref_71933_cglposte cascade;

create index i_fk_rela_cxc_ref_71933_cglposte on rela_cxctrx1_cglposteo (consecutivo);


alter table rela_cxctrx1_cglposteo
   drop constraint fk_rela_cxc_ref_71933_cglposte  cascade;

alter table rela_cxctrx1_cglposteo
   add constraint fk_rela_cxc_ref_71933_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_cxp_ref_70325_cglposte cascade;

create index i_fk_rela_cxp_ref_70325_cglposte on rela_cxpajuste1_cglposteo (consecutivo);


alter table rela_cxpajuste1_cglposteo
   drop constraint fk_rela_cxp_ref_70325_cglposte  cascade;

alter table rela_cxpajuste1_cglposteo
   add constraint fk_rela_cxp_ref_70325_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_cxp_ref_70310_cglposte cascade;

create index i_fk_rela_cxp_ref_70310_cglposte on rela_cxpfact1_cglposteo (consecutivo);


alter table rela_cxpfact1_cglposteo
   drop constraint fk_rela_cxp_ref_70310_cglposte  cascade;

alter table rela_cxpfact1_cglposteo
   add constraint fk_rela_cxp_ref_70310_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_eys_ref_71945_cglposte cascade;

create index i_fk_rela_eys_ref_71945_cglposte on rela_eys1_cglposteo (consecutivo);


alter table rela_eys1_cglposteo
   drop constraint fk_rela_eys_ref_71945_cglposte  cascade;

alter table rela_eys1_cglposteo
   add constraint fk_rela_eys_ref_71945_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_fac_ref_11999_cglposte cascade;

create index i_fk_rela_fac_ref_11999_cglposte on rela_factura1_cglposteo (consecutivo);


alter table rela_factura1_cglposteo
   drop constraint fk_rela_fac_ref_11999_cglposte  cascade;

alter table rela_factura1_cglposteo
   add constraint fk_rela_fac_ref_11999_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_nom_reference_cglposte cascade;

create index i_fk_rela_nom_reference_cglposte on rela_nomctrac_cglposteo (consecutivo);


alter table rela_nomctrac_cglposteo
   drop constraint fk_rela_nom_reference_cglposte  cascade;

alter table rela_nomctrac_cglposteo
   add constraint fk_rela_nom_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

drop index i_fk_rela_pla_reference_cglposte cascade;

create index i_fk_rela_pla_reference_cglposte on rela_pla_reservas_cglposteo (consecutivo);


alter table rela_pla_reservas_cglposteo
   drop constraint fk_rela_pla_reference_cglposte  cascade;

alter table rela_pla_reservas_cglposteo
   add constraint fk_rela_pla_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;
*/
