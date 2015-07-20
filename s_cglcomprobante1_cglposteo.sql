
delete from cglposteo where fecha_comprobante >= '2005-05-01'
and aplicacion_origen = 'CGL';

select f_cglcomprobante1_cglposteo(compania, aplicacion, year, periodo, secuencia)
from cglcomprobante1
where fecha_comprobante >= '2005-05-01';