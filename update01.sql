begin work;
update nomdescuentos
set cod_ctabco = null,
no_cheque = null,
motivo_bco = null
where motivo_bco = 'SC';


update nomctrac
set cod_ctabco = null,
no_cheque = null,
motivo_bco = null
where motivo_bco = 'SC';
commit work;