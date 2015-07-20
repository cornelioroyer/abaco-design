insert into bcocheck2 
select '2', cta2, '01', no_cheque,null,null, 'CH',
dr_cta2-cr_cta2 from divicheque
where no_cheque not in
(select no_cheque from bcocheck2) and 
cta2 is not null;
