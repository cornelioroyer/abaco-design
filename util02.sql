
create table tmp_cxcmov  (
   no_registro          numeric                            not null,
   cliente              varchar(254)                    default '254',
   motivo               int4                            default 11,
   fecha                varchar(254)                    default '254',
   documento            varchar(254)                    default '254',
   monto                float8                          default 22,
   aplicar              varchar(254)                    default '254'
)
;

insert into tmp_cxcmov (no_registro, cliente, motivo, fecha, documento, monto, aplicar)
select oid, cliente, motivo, fecha, documento, monto, aplicar
from cxcmov

drop table cxcmov;

create table cxcmov  (
   no_registro                 numeric                        not null default 10,
   cliente              char(10)                        default '254',
   motivo               int4                            default 11,
   fecha                date                            default '254',
   documento            char(10)                        default '254',
   monto                decimal(10,2)                   default 22,
   aplicar              char(10)                        default '254',
   primary key (no_registro)
)
;

insert into cxcmov (no_registro, cliente, motivo, documento, monto, aplicar)
select 10, cliente, motivo, documento, monto, aplicar
from tmp_cxcmov

drop table tmp_cxcmov;

