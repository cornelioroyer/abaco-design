select bcocheck1.no_cheque, bcocheck3.aplicar_a from bcocheck1, bcocheck3, bcoctas
where bcocheck1.cod_ctabco = bcocheck3.cod_ctabco
and bcocheck1.motivo_bco = bcocheck3.motivo_bco
and bcocheck1.no_cheque = bcocheck3.no_cheque
and bcocheck1.cod_ctabco = bcoctas.cod_ctabco
and bcocheck1.fecha_cheque >= '2010-11-01'
and not exists
(select * from cxpdocm
where cxpdocm.compania = bcoctas.compania
and cxpdocm.proveedor = bcocheck1.proveedor
and documento = bcocheck3.aplicar_a
and docmto_aplicar = bcocheck3.aplicar_a
and motivo_cxp = bcocheck3.motivo_cxp)
group by 1, 2
order by 1, 2;
