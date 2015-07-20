alter table oc2 
add column no_orden int4;

alter table oc2
add column tipo char(1);

alter table oc2
add column almacen char(2);

alter table oc2
add column linea integer;

alter table oc2
   add constraint fk_oc2_reference_tal_ot2 foreign key (no_orden, tipo, almacen, linea, articulo)
      references tal_ot2 (no_orden, tipo, almacen, linea, articulo)
      on delete restrict on update cascade;
