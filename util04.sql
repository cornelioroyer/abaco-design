
drop table cxcmov;

create table cxcmov  (
   cliente              char(10)                        default '254',
   motivo               int4                            default 11,
   fecha                date                            default '254',
   documento            char(10)                        default '254',
   monto                decimal(10,2)                   default 22,
   aplicar              char(10)                        default '254',
   primary key (no_registro)
)
;

insert into cxcmov (cliente, motivo, documento, monto, aplicar)
select cliente, motivo, documento, monto, aplicar
from tmp_cxcmov

drop table tmp_cxcmov;


