drop index i1_aranceles_grupo cascade;

drop table aranceles_grupo cascade;

create table aranceles_grupo (
grupo                char(2)              not null,
descripcion          char(100)            not null
);

alter table aranceles_grupo
   add constraint pk_aranceles_grupo primary key (grupo);

create unique index i1_aranceles_grupo on aranceles_grupo (
grupo
);




drop index i1_aranceles_sub_grupo cascade;

drop index i2_aranceles_sub_grupo cascade;

drop table aranceles_sub_grupo cascade;

create table aranceles_sub_grupo (
sub_grupo            char(4)              not null,
grupo                char(2)              not null,
descripcion          char(100)            not null
);

alter table aranceles_sub_grupo
   add constraint pk_aranceles_sub_grupo primary key (sub_grupo);

create unique index i1_aranceles_sub_grupo on aranceles_sub_grupo (
sub_grupo
);

create  index i2_aranceles_sub_grupo on aranceles_sub_grupo (
sub_grupo
);

alter table aranceles_sub_grupo
   add constraint fk_aranceles_sub_g_ref_aranceles_grupo foreign key (grupo)
      references aranceles_grupo (grupo)
      on delete restrict on update restrict;


drop index i1_aranceles cascade;

drop index i2_aranceles cascade;

drop table aranceles cascade;

create table aranceles (
partida              char(8)              not null,
sub_grupo            char(4)              not null,
descripcion          char(100)            not null,
arancel              decimal(10,2)        not null
);

alter table aranceles
   add constraint pk_aranceles primary key (partida);

create unique index i1_aranceles on aranceles (
partida
);

create  index i2_aranceles on aranceles (
sub_grupo
);

alter table aranceles
   add constraint fk_aranceles_ref_aranceles_sub_g foreign key (sub_grupo)
      references aranceles_sub_grupo (sub_grupo)
      on delete restrict on update restrict;

