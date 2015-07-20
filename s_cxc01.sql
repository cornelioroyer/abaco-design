select f_cxc_recibo1_cglposteo(almacen, consecutivo) from cxc_recibo1
where fecha between  '2005-12-01' and '2005-12-02'
and not exists
(select * from rela_cxc_recibo1_cglposteo
where rela_cxc_recibo1_cglposteo.almacen = cxc_recibo1.almacen
and rela_cxc_recibo1_cglposteo.cxc_consecutivo = cxc_recibo1.consecutivo);



