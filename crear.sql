
drop table bco_cuentas_cheque cascade;
create table bco_cuentas_cheque (
cod_ctabco           char(2)              not null,
no_cheque            int4                 not null,
motivo_bco           char(2)              not null,
linea                int4                 not null,
cuenta_debito        char(24)             null,
monto_debito         decimal(12,2)        not null,
cuenta_credito       char(24)             null,
monto_credito        decimal(12,2)        not null
);

alter table bco_cuentas_cheque
   add constraint pk_bco_cuentas_cheque primary key (cod_ctabco, no_cheque, motivo_bco, linea);

alter table bco_cuentas_cheque
   add constraint fk_bco_cuen_reference_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete cascade on update cascade;
