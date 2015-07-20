drop view cxc_cxcfact1;

/*==============================================================*/
/* View: cxc_cxcfact1                                           */
/*==============================================================*/
create view cxc_cxcfact1 as
select 'CXC' as aplicacion, a.almacen, a.cliente, a.no_factura, a.motivo_cxc, a.fecha_posteo_fact as fecha_posteo, a.fecha_vence_fact as fecha_vencimiento, -sum(b.monto*c.signo_rubro_fact_cxc) as monto
from cxcfact1 a, cxcfact2 b, rubros_fact_cxc c
where a.almacen = b.almacen and a.no_factura = b.no_factura and b.rubro_fact_cxc = c.rubro_fact_cxc
group by a.aplicacion, a.almacen, a.cliente, a.no_factura, a.motivo_cxc, fecha_posteo, fecha_vencimiento;

