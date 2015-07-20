update nomctrac
set cod_ctabco = '22', motivo_bco = '01', no_cheque = 815
where compania = '02'
and tipo_calculo = '1'
and tipo_planilla = '2'
and year = 2006
and no_cheque is null;
