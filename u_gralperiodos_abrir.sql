
update gralperiodos 
set estado = 'A'
where compania = '07'
and final >= '2005-07-31';

update gralparaxcia
set valor = '2005'
where compania = '07'
and parametro = 'anio_actual';


update gralparaxcia
set valor = '7'
where compania = '07'
and parametro = 'periodo_actual';

update gralparaxcia
set valor = '0'
where parametro = 'sec_comprobante';