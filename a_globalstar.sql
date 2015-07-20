alter table cf_tasa_de_cambio drop column factor;
alter table cf_tasa_de_cambio add column factor decimal(15,5);
update cf_tasa_de_cambio set factor = 1;
alter table cf_tasa_de_cambio alter column factor set not null;
alter table cf_recibos_1 drop column pais cascade;
alter table bcoctas add column pais char(10);
alter table bcoctas
   add constraint fk_bcoctas_ref_fac_paises foreign key (pais)
      references fac_paises (pais)
      on delete restrict on update restrict;
