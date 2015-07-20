
drop table gral_usuarios_x_cia cascade;
create table gral_usuarios_x_cia (
compania             char(2)              not null,
usuario              char(30)             not null,
status               char(1)              not null
);

alter table gral_usuarios_x_cia
   add constraint pk_gral_usuarios_x_cia primary key (compania, usuario);

create unique index i1_gral_usuarios_x_cia on gral_usuarios_x_cia (
compania,
usuario
);

alter table gral_usuarios_x_cia
   add constraint fk_gral_usu_reference_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete cascade on update cascade;

alter table gral_usuarios_x_cia
   add constraint fk_gral_usu_reference_gral_usu foreign key (usuario)
      references gral_usuarios (usuario)
      on delete cascade on update cascade;
