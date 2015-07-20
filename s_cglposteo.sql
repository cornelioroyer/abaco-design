select cglposteo.cuenta, cglcuentas.nombre, cglposteo.fecha_comprobante, 
trim(cglposteo.descripcion), cglposteo.debito, cglposteo.credito
from cglcuentas, cglposteo
where cglcuentas.cuenta = cglposteo.cuenta
and Anio(cglposteo.fecha_comprobante) = 2004
order by 1, 2, 3, 4