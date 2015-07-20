drop index i3_factura2_eys2;

create  index i3_factura2_eys2 on factura2_eys2 (
almacen,
tipo,
num_documento,
factura2_linea
);
