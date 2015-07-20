alter table eys4
rename column fact_proveedor to borrar;

alter table eys4
add column fact_proveedor char(25);

update eys4
set fact_proveedor = borrar;

alter table eys4
alter column fact_proveedor set not null;

/*
alter table eys4
drop constraint fk_eys4_ref_17158_cxpfact2;
*/

alter table eys4
   add constraint fk_eys4_ref_17158_cxpfact2 foreign key (proveedor, fact_proveedor, rubro_fact_cxp, cxp_linea, compania)
      references cxpfact2 (proveedor, fact_proveedor, rubro_fact_cxp, linea, compania)
      on delete cascade on update cascade;

alter table eys4
drop column borrar;