select f_bcotransac1_cglposteo(bcotransac1.cod_ctabco, bcotransac1.sec_transacc) 
from bcoctas, bcotransac1
where bcoctas.cod_ctabco = bcotransac1.cod_ctabco
and bcotransac1.fecha_posteo between '2014-04-20' and '2015-04-20'
and bcoctas.compania = '03';
