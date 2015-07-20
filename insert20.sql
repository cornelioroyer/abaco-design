insert into bcocheck1
select '01', 0, no_cheque, '0000', 'CH', beneficiario,
fecha, fecha, fecha, 'dba', today(), no_cheque, observacion,
'R', monto from divicheque where no_cheque
not in 
(select no_cheque from bcocheck1);
