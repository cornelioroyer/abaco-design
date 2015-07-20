
insert into cxp_saldos_iniciales (compania, proveedor,
factura, fecha, saldo, motivo_cxp)
select '02', proveedor, trim(factura), fecha, sum(saldo), '01' from cxp_coolhouse
where proveedor is not null
group by proveedor, factura, fecha
