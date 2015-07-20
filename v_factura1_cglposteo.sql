drop view v_factura1_cglposteo;
create view v_factura1_cglposteo as
select rela_factura1_cglposteo.almacen, rela_factura1_cglposteo.tipo,
rela_factura1_cglposteo.num_documento, cglposteo.cuenta, cglposteo.debito, cglposteo.credito
from rela_factura1_cglposteo, cglposteo
where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo