drop function f_saldo_docmto_cxc;
create function f_saldo_docmto_cxc(as_almacen char(2), as_cliente char(6), as_documento char(10), 
 as_motivo char(2), ad_fecha date) returns decimal(10,2)
begin
declare saldo decimal(10,2);
set saldo = 0;
select  sum(a.monto*b.signo) into saldo from cxcdocm a, cxcmotivos b
where           a.motivo_cxc                    =       b.motivo_cxc
and             a.almacen                               =       as_almacen
and             a.cliente                               =       as_cliente
and             a.motivo_ref                    =       as_motivo
and             a.docmto_ref                    =       as_documento
and             a.docmto_aplicar                =       as_documento
and             a.fecha_docmto                  <=      ad_fecha;
return saldo;
end
