rollback work;
begin work;
alter table bcoctas add column moneda char(2);
alter table bcoctas add column pais char(10);

drop index i1_cf_monedas cascade;

drop table cf_monedas cascade;

create table cf_monedas (
moneda               char(2)              not null,
descripcion          char(60)             not null
);

alter table cf_monedas
   add constraint pk_cf_monedas primary key (moneda);

create unique index i1_cf_monedas on cf_monedas (
moneda
);


alter table bcoctas
   add constraint fk_bcoctas_reference_cf_moned foreign key (moneda)
      references cf_monedas (moneda)
      on delete restrict on update cascade;



drop index i1_cf_tasa_de_cambio cascade;

drop index i2_cf_tasa_de_cambio cascade;

drop index i3_cf_tasa_de_cambio cascade;

drop table cf_tasa_de_cambio cascade;

create table cf_tasa_de_cambio (
moneda               char(2)              not null,
desde                date                 not null,
hasta                date                 not null,
moneda_foranea       char(2)              not null,
factor               decimal(10,2)        not null
);

alter table cf_tasa_de_cambio
   add constraint pk_cf_tasa_de_cambio primary key (moneda, desde, hasta);

create unique index i1_cf_tasa_de_cambio on cf_tasa_de_cambio (
moneda,
desde,
hasta
);

create  index i2_cf_tasa_de_cambio on cf_tasa_de_cambio (
moneda
);

create  index i3_cf_tasa_de_cambio on cf_tasa_de_cambio (
moneda_foranea
);

alter table cf_tasa_de_cambio
   add constraint fk_cf_tasa__reference_cf_moned foreign key (moneda)
      references cf_monedas (moneda)
      on delete restrict on update restrict;

alter table cf_tasa_de_cambio
   add constraint fk2_cf_tasa__reference_cf_moned foreign key (moneda_foranea)
      references cf_monedas (moneda)
      on delete restrict on update restrict;
      
commit work;
      

