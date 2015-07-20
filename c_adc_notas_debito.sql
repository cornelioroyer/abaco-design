drop table adc_notas_debito_2 cascade;
drop table adc_notas_debito_1 cascade;

/*==============================================================*/
/* Table: adc_notas_debito_1                                    */
/*==============================================================*/
create table adc_notas_debito_1 (
compania             char(2)              not null,
secuencia            int4                 not null,
consecutivo          int4                 not null,
cliente              char(10)             not null,
documento            char(10)             not null,
observacion_1        char(60)             null,
observacion_2        char(60)             null,
observacion_3        char(60)             null,
observacion_4        char(60)             null,
almacen              char(2)              null,
tipo                 char(3)              null,
num_documento        int4                 null,
fecha                date                 not null,
usuario              char(10)             not null,
fecha_captura        timestamp            not null
);

create table adc_notas_debito_2 (
compania             char(2)              not null,
secuencia            int4                 not null,
linea                int4                 not null,
almacen              char(2)              null,
articulo             char(15)             null,
observacion          char(60)             null,
monto                decimal(12,2)        not null
);

alter table adc_notas_debito_2
   add constraint pk_adc_notas_debito_2 primary key (compania, secuencia, linea);

/*==============================================================*/
/* Index: i1_adc_notas_debito_2                                 */
/*==============================================================*/
create unique index i1_adc_notas_debito_2 on adc_notas_debito_2 (
compania,
secuencia,
linea
);

/*==============================================================*/
/* Index: i2_adc_notas_debito_2                                 */
/*==============================================================*/
create  index i2_adc_notas_debito_2 on adc_notas_debito_2 (
compania,
secuencia
);

/*==============================================================*/
/* Index: i3_adc_notas_debito_2                                 */
/*==============================================================*/
create  index i3_adc_notas_debito_2 on adc_notas_debito_2 (
almacen,
articulo
);


alter table adc_notas_debito_1
   add constraint pk_adc_notas_debito_1 primary key (compania, secuencia);

/*==============================================================*/
/* Index: i1_adc_notas_debito_1                                 */
/*==============================================================*/
create unique index i1_adc_notas_debito_1 on adc_notas_debito_1 (
secuencia,
compania
);

/*==============================================================*/
/* Index: i2_adc_notas_debito_1                                 */
/*==============================================================*/
create  index i2_adc_notas_debito_1 on adc_notas_debito_1 (
cliente
);

/*==============================================================*/
/* Index: i3_adc_notas_debito_1                                 */
/*==============================================================*/
create  index i3_adc_notas_debito_1 on adc_notas_debito_1 (
almacen,
tipo,
num_documento
);

alter table adc_notas_debito_1
   add constraint fk_adc_nota_reference_adc_mani foreign key (compania, consecutivo)
      references adc_manifiesto (compania, consecutivo)
      on delete restrict on update restrict;

alter table adc_notas_debito_1
   add constraint fk_adc_nota_reference_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update restrict;

alter table adc_notas_debito_1
   add constraint fk_adc_nota_reference_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete restrict on update cascade;

alter table adc_notas_debito_2
   add constraint fk_adc_nota_reference_adc_nota foreign key (compania, secuencia)
      references adc_notas_debito_1 (compania, secuencia)
      on delete restrict on update cascade;
