
select no_cheque, f_bcocheck1_cglposteo(cod_ctabco, motivo_bco, no_cheque) from bcocheck1
where fecha_posteo between '2014-02-01' and '2015-01-31';
