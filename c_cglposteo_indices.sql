drop index i1_cglposteo cascade;

drop index i2_cglposteo cascade;

drop index i3_cglposteo cascade;

drop index i4_cglposteo cascade;

drop index i5_cglposteo cascade;

drop index i6_cglposteo cascade;

drop index i7_cglposteo cascade;

drop index i8_cglposteo cascade;

drop index i9_cglposteo cascade;


create unique index i1_cglposteo on cglposteo (
consecutivo
);

create  index i2_cglposteo on cglposteo (
cuenta
);

create  index i3_cglposteo on cglposteo (
fecha_comprobante
);

create  index i4_cglposteo on cglposteo (
compania,
aplicacion,
year,
periodo
);

create  index i5_cglposteo on cglposteo (
linea,
cuenta
);

create  index i6_cglposteo on cglposteo (
cuenta,
compania,
aplicacion,
year,
periodo,
linea
);

create  index i7_cglposteo on cglposteo (
cuenta,
compania,
fecha_comprobante
);

create  index i8_cglposteo on cglposteo (
tipo_comp
);

create  index i9_cglposteo on cglposteo (
debito,
credito
);
