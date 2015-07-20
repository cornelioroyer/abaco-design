drop view v_pwc;
drop view v_pwc_usuarios;
drop view v_pwc_2012;
drop view v_conytram_2011;

create view v_conytram_2011 as 
select Anio(cglposteo.fecha_comprobante) as anio,
Mes(cglposteo.fecha_comprobante) as mes,
cglposteo.fecha_comprobante as fecha,
cglposteo.aplicacion_origen,
trim(cglcuentas.nombre) as nombre_cuenta, trim(cglposteo.cuenta) as cuenta, 
trim(cglposteo.descripcion) as descripcion, (cglposteo.debito-cglposteo.credito) as monto
from cglposteo, cglcuentas
where cglposteo.cuenta = cglcuentas.cuenta
and Anio(cglposteo.fecha_comprobante) >= 2011
and cglposteo.compania = '01';

create view v_pwc_2012 as 
select trim(cglcuentas.nombre) as nombre_cuenta, trim(cglposteo.cuenta) as numero_cuenta, 
trim(cglposteo.descripcion) as descripcion, (cglposteo.debito-cglposteo.credito) as monto,
(case when (cglposteo.debito-cglposteo.credito) >= 0 then 1 else -1 end) as debito_credito,
cglposteo.fecha_comprobante as fecha_transaccion, cglposteo.fecha_comprobante as fecha_contabilizacion, 
null as numero_cuenta_contrapartida,
cglposteo.usuario_captura as usuario_ingreso, cglposteo.usuario_captura as usuario_aprobo
from cglposteo, cglcuentas
where cglposteo.cuenta = cglcuentas.cuenta
and Anio(cglposteo.fecha_comprobante) = 2012
and cglposteo.compania = '03';


create view v_pwc as 
select consecutivo as numreg, compania as codcom, ' ' as coduni,cuenta as numcta,
year as anocon, periodo as mescon, fecha_captura as fecing,
fecha_captura as horing, fecha_comprobante as feccon,
' ' as stspos, secuencia as comcon, tipo_comp as tipcom,
' ' as tipent, descripcion as desmvt, descripcion as desdet,
usuario_captura as usuing,
usuario_actualiza as usuapr, ' ' as numbat, ' ' as codrev,
' ' as codmon, 'D' as debcre,
(debito-credito) as valorm
from cglposteo
where year = 2012
and compania = '03'
and (debito-credito) > 0
union
select consecutivo as numreg, compania as codcom, ' ' as coduni,cuenta as numcta,
year as anocon, periodo as mescon, fecha_captura as fecing,
fecha_captura as horing, fecha_comprobante as feccon,
' ' as stspos, secuencia as comcon, tipo_comp as tipcom,
' ' as tipent, descripcion as desmvt, descripcion as desdet,
usuario_captura as usuing,
usuario_actualiza as usuapr, ' ' as numbat, ' ' as codrev,
' ' as codmon, 'C' as debcre,
-(debito-credito) as valorm
from cglposteo
where year = 2012
and compania = '03'
and (debito-credito) < 0;


create view v_pwc_usuarios as 
select usuario, nombre, null as departamento, null as tipo_de_registro,
null as unidad_de_negocios,
null as nombre_unidad_negocios
from gral_usuarios;

