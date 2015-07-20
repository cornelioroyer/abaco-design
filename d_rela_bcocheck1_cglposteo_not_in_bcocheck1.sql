delete from rela_bcocheck1_cglposteo
where exists
(select * from bcocheck1
where bcocheck1.cod_ctabco = rela_bcocheck1_cglposteo.cod_ctabco
and bcocheck1.no_cheque = rela_bcocheck1_cglposteo.no_cheque
and bcocheck1.motivo_bco = rela_bcocheck1_cglposteo.motivo_bco
and bcocheck1.fecha_posteo >= '2015-03-01');
