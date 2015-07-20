drop view v_oc1_oc2;
create view v_oc1_oc2 as
select oc1.numero_oc, oc1.proveedor, oc1.compania, oc1.status,
oc1.fecha, oc2.articulo, oc2.cantidad, oc2.costo, oc2.descuento,
articulos.desc_articulo, gralcompanias.nombre,
proveedores.nomb_proveedor, oc1.observacion
from oc1, oc2, articulos, gralcompanias, proveedores
where oc1.compania = oc2.compania
and oc1.numero_oc = oc2.numero_oc
and articulos.articulo = oc2.articulo
and oc1.compania = gralcompanias.compania
and oc1.proveedor = proveedores.proveedor