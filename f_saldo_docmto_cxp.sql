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
commit work;
