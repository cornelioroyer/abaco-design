delete from fac_z
where not exists
(select * from factura1
where factura1.almacen = fac_z.almacen
and factura1.caja = fac_z.caja
and factura1.sec_z = fac_z.sec_z);