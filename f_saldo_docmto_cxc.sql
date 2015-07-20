drop function f_saldo_docmto_cxc(char(2), char(6), char(10),  char(3), date);
create function f_saldo_docmto_cxc(char(2), char(6), char(10),  char(3), date) returns decimal(10,2)
as 'select  sum(a.monto*b.signo) as saldo from cxcdocm a, cxcmotivos b
where           a.motivo_cxc                    =       b.motivo_cxc
and             a.almacen                       =       $1
and             a.cliente                       =       $2
and             a.motivo_ref                    =       $4
and             a.docmto_ref                    =       $3
and             a.docmto_aplicar                =       $3
and             a.fecha_docmto                  <=      $5;' language 'sql';


