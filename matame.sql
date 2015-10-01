select bcoctas.compania, bcotransac1.proveedor, bcotransac1.no_docmto,
bcotransac3.aplicar_a, bcomotivos.motivo_cxp, bcotransac3.motivo_cxp, 'BCO',
bcotransac1.fecha_posteo, bcotransac1.fecha_posteo, bcotransac3.monto,
bcotransac1.usuario, trim(bcotransac1.obs_transac_bco)
from bcotransac1, bcotransac3, bcoctas, cxpdocm, bcomotivos
where bcotransac1.cod_ctabco = bcotransac3.cod_ctabco
and bcotransac1.sec_transacc = bcotransac3.sec_transacc
and bcotransac1.cod_ctabco = bcoctas.cod_ctabco
and cxpdocm.compania = bcoctas.compania
and trim(cxpdocm.proveedor) = trim(bcotransac1.proveedor)
and cxpdocm.motivo_cxp = bcotransac3.motivo_cxp 
and bcotransac1.proveedor is not null
and bcotransac1.motivo_bco = bcomotivos.motivo_bco
and bcomotivos.motivo_cxp is not null
and bcotransac1.sec_transacc = 16392

/*
and trim(cxpdocm.documento) = trim(bcotransac3.aplicar_a)
and trim(cxpdocm.docmto_aplicar) = trim(bcotransac3.aplicar_a)
*/
