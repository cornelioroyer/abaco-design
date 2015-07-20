drop function f_saldo_docmto_cxp;
create function f_saldo_docmto_cxp(as_cia char(2), as_proveedor char(6), as_documento char(10),  as_motivo char(3), ad_fecha date) 
returns decimal(10,2)
begin
declare saldo decimal(10,2);
select sum(a.monto*b.signo*-1) into saldo from cxpdocm a, cxpmotivos b
where           a.motivo_cxp                    =       b.motivo_cxp
and             a.compania                              =       as_cia
and             a.proveedor                             =       as_proveedor
and             a.motivo_cxp_ref                =       as_motivo
and             a.docmto_aplicar_ref    =       as_documento
and             a.docmto_aplicar                =      as_documento
and             a.fecha_docmto                  <= ad_fecha;
return saldo;
end
