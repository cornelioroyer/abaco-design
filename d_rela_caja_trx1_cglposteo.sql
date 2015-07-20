delete from rela_caja_trx1_cglposteo
where exists
(select * from caja_trx1
where caja_trx1.caja = rela_caja_trx1_cglposteo.caja
and caja_trx1.numero_trx = rela_caja_trx1_cglposteo.numero_trx
and caja_trx1.fecha_posteo >= '2013-01-01');

delete from cglposteo
where fecha_comprobante >= '2013-01-01'
and aplicacion_origen = 'CAJ';

select f_postea_caja_menuda('02');


