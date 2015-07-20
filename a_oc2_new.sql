alter table oc2
drop column descripcion;

alter table oc2
add column d_articulo text;

update oc2
set d_articulo = articulos.desc_articulo
where oc2.articulo = articulos.articulo;

alter table oc2
alter column d_articulo set not null;


alter table fac_parametros_contables
add column cta_de_gasto char(24);

update fac_parametros_contables
set cta_de_gasto = '600039';

alter table fac_parametros_contables
alter column cta_de_gasto set not null;

alter table fac_parametros_contables
   add constraint fk_fac_para_reference_680_cglcuent foreign key (cta_de_gasto)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;
