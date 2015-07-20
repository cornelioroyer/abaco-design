
drop table tmp_cxcmov;
create table tmp_cxcmov  (
   cliente              varchar(254)                    default '254',
   motivo               int4                            default 11,
   fecha                varchar(254)                    default '254',
   documento            varchar(254)                    default '254',
   monto                float8                          default 22,
   aplicar              varchar(254)                    default '254'
)
;

insert into tmp_cxcmov (cliente, motivo, fecha, documento, monto, aplicar)
select cliente, motivo, fecha, documento, monto, aplicar
from cxcmov




