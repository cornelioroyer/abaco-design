drop table formulario_72_dgi;

create table formulario_72_dgi as
select trim(cglposteo.cuenta) as cuenta,
f_cglposteo(consecutivo, 'TIPO_DE_PERSONA') as tipo_de_persona, 
f_cglposteo(consecutivo, 'RUC') as ruc, 
f_cglposteo(consecutivo, 'DV') as dv, 
f_cglposteo(consecutivo, 'NOMBRE') as nombre, 
(debito-credito) as monto
from cglposteo
where (cuenta like '8%' or cuenta like '9%' or cuenta like '5%')
and fecha_comprobante between '2012-01-01' and '2012-12-31'
and periodo <> 13
and compania = '03'





