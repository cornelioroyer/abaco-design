drop function f_monto_factura(char(2), char(2), int4);
create function f_monto_factura(char(2), char(6), int4) returns decimal(10,2)
as 'select -sum(d.monto*a.signo*b.signo_rubro_fact_cxc) from factmotivos a, rubros_fact_cxc b, factura1 c, factura4 d
where c.almacen = d.almacen
and c.tipo = d.tipo
and c.num_documento = d.num_documento
and c.tipo = a.tipo
and d.rubro_fact_cxc = b.rubro_fact_cxc
and c.almacen = $1
and c.tipo = $2
and c.num_documento = $3;' language 'sql';









