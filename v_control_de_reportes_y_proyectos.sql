drop view v_control_de_reportes_y_proyectos;

create view v_control_de_reportes_y_proyectos as 
select no_orden, observacion as descripcion_del_reporte, nombre_cliente,
direccion_1, direccion_2, rhuempl.nombre_del_empleado as autorizado_por,
tal_ot1.fecha as fecha_asignado, tal_ot1.fecha_entrega as fecha_final,
(tal_ot1.fecha_entrega - tal_ot1.fecha) as dias,
fact_referencias.descripcion as asignado_a,
tal_ot1.e_mail_1 as email_inicial_enviado,
tal_ot1.garantia as garantia,
tal_ot1.no_cotizacion,
tal_ot1.no_orden as no_orden_servicio,
tal_ot1.numero_factura,
f_saldo_documento_cxc(tal_ot1.almacen, cliente, tipo_factura, trim(to_char(numero_factura, '99999999')), '2100-01-01') as saldo,
tal_ot1.reportes_enviados,
tal_ot1.reportes_finales,
tal_ot1.trabajo_visitado,
tal_ot1.trabajo_realizado
from tal_ot1, rhuempl, fact_referencias, almacen
where tal_ot1.compania = rhuempl.compania
and tal_ot1.empleado_responsable = rhuempl.codigo_empleado
and fact_referencias.referencia = tal_ot1.referencia
and tal_ot1.almacen = almacen.almacen
and almacen.compania = '03';


create view v_tal_piezas_por_departamento as
select 
from tal_ot1, tal_ot2, fact_referencias, almacen
where tal_ot1.referencia = fact_referencias.referencia
and tal_ot1.almacen = tal_ot2.almacen
and tal_ot1.tipo = tal_ot2.tipo
and tal_ot1.no_orden = tal_ot2.no_orden
and tal_ot1.almacen = almacen.almacen
and almacen.compania = '03'

