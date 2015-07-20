

delete from rela_cxc_recibo1_cglposteo
using cxc_recibo1, cglposteo, almacen
where rela_cxc_recibo1_cglposteo.consecutivo = cglposteo.consecutivo
and rela_cxc_recibo1_cglposteo.almacen = cxc_recibo1.almacen
and rela_cxc_recibo1_cglposteo.caja = cxc_recibo1.caja
and rela_cxc_recibo1_cglposteo.cxc_consecutivo = cxc_recibo1.consecutivo
and rela_cxc_recibo1_cglposteo.almacen = almacen.almacen
and almacen.compania = '02'
and cxc_recibo1.fecha >= '2015-01-01'

/*

and cxc_recibo1.fecha <> cglposteo.fecha_comprobante;

*/

