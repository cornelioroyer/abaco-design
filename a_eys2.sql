alter table eys2
add column compania char(2);
alter table eys2
add column proveedor char(6);
alter table eys2
add column fact_proveedor char(25);
alter table eys2
   add constraint fk_eys2_reference_682_cxpfact1 foreign key (proveedor, fact_proveedor, compania)
      references cxpfact1 (proveedor, fact_proveedor, compania)
      on delete cascade on update cascade;
