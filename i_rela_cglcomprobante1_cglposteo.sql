insert into rela_cglcomprobante1_cglposteo
select secuencia, compania, aplicacion, year, periodo, consecutivo
from cglposteo
where fecha_comprobante <= '2005-04-30'
and aplicacion_origen = 'CGL'