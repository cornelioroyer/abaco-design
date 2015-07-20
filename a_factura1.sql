alter table factura1 add column caja char(3);
alter table factura1
   add constraint fk_factura1_ref_fac_cajas foreign key (caja, almacen)
      references fac_cajas (caja, almacen)
      on delete restrict on update cascade;
      
alter table factura1 add column cajero char(4);
alter table factura1
   add constraint fk_factura1_ref_fac_cajeros foreign key (cajero)
      references fac_cajeros (cajero)
      on delete restrict on update restrict;
      
alter table factura1 add column sec_z int4;