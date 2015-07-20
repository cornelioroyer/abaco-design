drop function anio(date);
create function anio(date) returns float
as 'select extract("year" from $1) as anio' language 'sql';


drop function mes(date);
create function mes(date) returns float
as 'select extract("month" from $1) as mes' language 'sql';


drop function f_saldo_docmto_cxc(char(2), char(6), char(10),  char(3), date);
create function f_saldo_docmto_cxc(char(2), char(6), char(10),  char(3), date) returns decimal(10,2)
as 'select  sum(a.monto*b.signo) as saldo from cxcdocm a, cxcmotivos b
where           a.motivo_cxc                    =       b.motivo_cxc
and             a.almacen                               =       $1
and             a.cliente                               =       $2
and             a.motivo_ref                    =       $4
and             a.docmto_ref                    =       $3
and             a.docmto_aplicar                =       $3
and             a.fecha_docmto                  <=      $5;' language 'sql';



drop function f_saldo_docmto_cxp(char(2), char(6), char(10),  char(3), date);
create function f_saldo_docmto_cxp(char(2), char(6), char(10),  char(3), date) returns decimal(10,2)
as 
'select sum(a.monto*b.signo*-1) as saldo from cxpdocm a, cxpmotivos b
where		a.motivo_cxp			=	b.motivo_cxp
and		a.compania				=	$1
and		a.proveedor				=	$2
and		a.motivo_cxp_ref		=	$4
and		a.docmto_aplicar_ref	=	$3
and		a.docmto_aplicar		=	$3
and		a.fecha_docmto			<= $5;' language 'sql';

drop function today();
create function today() returns date
as 'select current_date as fecha' language 'sql';

