

update pla_retenciones
set hacer_cheque = 'S'
where compania = 1261;

update pla_retenciones
set hacer_cheque = 'N'
from pla_acreedores
where pla_retenciones.compania = pla_acreedores.compania
and pla_retenciones.acreedor = pla_acreedores.acreedor
and trim(pla_acreedores.nombre) like '%SECTEC%'
and pla_retenciones.compania = 1261;







