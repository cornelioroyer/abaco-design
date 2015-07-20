drop function f_saldo_cliente_x_cia(char(2), char(6), date);
create function f_saldo_cliente_x_cia(char(2), char(6), date) returns decimal(10,2)
as 'select  sum(a.monto*b.signo) as saldo from cxcdocm a, cxcmotivos b, almacen c
where a.motivo_cxc                    =       b.motivo_cxc
and   a.cliente                               =       $2
and   a.almacen = c.almacen
and   c.compania = $1
and   a.fecha_docmto                  <=      $3;' language 'sql';



