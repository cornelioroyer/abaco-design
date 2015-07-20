drop table pedidos_3 cascade;

drop table pedidos_1 cascade;

drop table pedidos_2 cascade;


create table pedidos_1 (
compania             char(2)              not null,
no_pedido            int4                 not null,
fecha                date                 not null,
cliente              char(10)             not null,
observacion          varchar(100)         null,
usuario              char(10)             not null,
fecha_captura        timestamp            not null
);

create table pedidos_2 (
compania             char(2)              not null,
no_pedido            int4                 not null,
linea                int4                 not null,
proveedor            varchar(100)         not null,
bultos               int4                 not null,
contacto             varchar(100)         null,
celular              varchar(50)          null,
telefono             varchar(50)          null,
observacion          varchar(100)         null,
status               char(1)              not null
);



create table pedidos_3 (
compania             char(2)              not null,
no_pedido            int4                 not null,
linea                int4                 not null,
fecha                date                 not null,
evento               varchar(100)         not null
);



alter table pedidos_1
   add constraint pk_pedidos_1 primary key (compania, no_pedido);

alter table pedidos_2
   add constraint pk_pedidos_2 primary key (compania, no_pedido, linea);

alter table pedidos_3
   add constraint pk_pedidos_3 primary key (compania, no_pedido, linea, fecha);

alter table pedidos_1
   add constraint fk_pedidos__reference_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update restrict;

alter table pedidos_1
   add constraint fk_pedidos__reference_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update restrict;

alter table pedidos_2
   add constraint fk_pedidos__reference_pedidos_ foreign key (compania, no_pedido)
      references pedidos_1 (compania, no_pedido)
      on delete restrict on update restrict;



alter table pedidos_3
   add constraint fk_pedidos__reference_pedidos_ foreign key (compania, no_pedido, linea)
      references pedidos_2 (compania, no_pedido, linea)
      on delete restrict on update restrict;




create unique index i1_pedidos_1 on pedidos_1 (
compania,
no_pedido
);

create unique index i1_pedidos_2 on pedidos_2 (
compania,
no_pedido,
linea
);

/*==============================================================*/
/* Index: i2_pedidos_2                                          */
/*==============================================================*/
create  index i2_pedidos_2 on pedidos_2 (
compania,
no_pedido
);

create unique index i1_pedidos_3 on pedidos_3 (
compania,
no_pedido,
linea,
fecha
);

create  index i2_pedidos_3 on pedidos_3 (
compania,
no_pedido,
linea
);
