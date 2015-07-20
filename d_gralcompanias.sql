delete from cglposteo where compania = '02';


delete from cxpdocm
where compania = '02';


delete from gralparaxcia
where compania = '02';

delete from cxp_saldos_iniciales
where compania = '02';

delete from gralperiodos
where compania = '02';


delete from cxpfact1
where compania = '02';

delete from cxpajuste1
where compania = '02';

delete from cglcomprobante1
where compania = '02';

delete from bcotransac1
where cod_ctabco in
(select cod_ctabco from bcoctas
where compania = '02');



delete from bcocheck1
where cod_ctabco in
(select cod_ctabco from bcoctas
where compania = '02');



delete from bcocircula
where cod_ctabco in
(select cod_ctabco from bcoctas
where compania = '02');


delete from bcoctas
where compania = '02';

delete from invparal
where almacen in
(select almacen from almacen
where compania = '02');


delete from cxctrx1
where almacen in
(select almacen from almacen
where compania = '02');


delete from cxcfact1
where almacen in
(select almacen from almacen
where compania = '02');



delete from cxcdocm
where almacen in
(select almacen from almacen
where compania = '02');


delete from almacen
where compania = '02';

delete from gralcompanias 
where compania = '02';