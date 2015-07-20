

insert into cxc_saldos_iniciales (almacen, cliente, documento, motivo_cxc,
fecha, monto)
select '01', trim(cliente), trim(factura), '01', fecha, saldo
from cxc_coolhouse
