

drop view v_formulario_72_dgi;

create view v_formulario_72_dgi as
select cglposteo.compania, 
cglposteo.fecha_comprobante, 
trim(cglposteo.cuenta) as cuenta,
f_cglposteo(consecutivo, 'TIPO_DE_PERSONA') as tipo_de_persona, 
f_cglposteo(consecutivo, 'RUC') as ruc, 
f_cglposteo(consecutivo, 'DV') as dv, 
f_cglposteo(consecutivo, 'NOMBRE') as nombre, 
(debito-credito) as monto
from cglposteo, cglcuentas
where cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
and fecha_comprobante >= '2012-01-01'
and periodo <> 13
order by fecha_comprobante, cuenta
