

drop view v_factura1_factura2_harinas cascade;

create view v_factura1_factura2_harinas as
select gralcompanias.nombre, almacen.compania, factura1.fecha_factura, Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, factura1.almacen, 
gral_valor_grupos.desc_valor_grupo as tipo_de_harina,
factura1.cliente, 
clientes.nomb_cliente as nombre_cliente, 
factura1.tipo, articulos.orden_impresion, 
factura2.articulo, articulos.desc_articulo,
factura2.cantidad,
f_desglose_factura_x_linea(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.linea, '100LBS') as quintales,
f_desglose_factura_x_linea(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.linea, 'VENTA_NETA') as venta,
f_precio_x_tipo_de_harina(almacen.compania, factura1.cliente, Trim(gral_valor_grupos.desc_valor_grupo), current_date) as precio_vigente
from factura1, factura2, clientes, articulos_agrupados, articulos,
        gral_valor_grupos, factmotivos, almacen, gralcompanias
where almacen.compania = gralcompanias.compania
and factura1.almacen = almacen.almacen
and clientes.cliente = factura1.cliente
and gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and factmotivos.tipo = factura1.tipo
and (factmotivos.factura = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S'
or factmotivos.promocion = 'S')
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and articulos_agrupados.articulo = articulos.articulo
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and factura1.status <> 'A'
and Anio(factura1.fecha_factura) = 2010;

drop function f_meses(char(10), char(50)) cascade;

create function f_meses(char(10), char(50)) returns integer as '
declare
    as_cliente alias for $1;
    as_tipo_de_harina alias for $2;
    r_work record;
    li_meses integer;
begin
    li_meses = 0;
    for r_work in select mes from v_factura1_factura2_harinas
                    where trim(tipo_de_harina) = trim(as_tipo_de_harina)
                    and trim(cliente) = trim(as_cliente)
                    group by 1
                    order by 1
    loop
        li_meses = li_meses + 1;
    end loop;
    
    return li_meses;
    
end;
' language plpgsql;



create view v_especial_harinas as
select nombre_cliente, cliente, tipo_de_harina, Sum(quintales)/f_meses(cliente, tipo_de_harina) as venta_promedio_quintales, 
Round(sum(venta)/sum(quintales),2) as precio_promedio_2010,
(Sum(quintales)/f_meses(cliente, tipo_de_harina))*(Round(sum(venta)/sum(quintales),2)) as venta_mensual_promedio_con_precio_promedio,
Max(precio_vigente) as precio_vigente, 
Max(precio_vigente) * (Sum(quintales)/f_meses(cliente, tipo_de_harina)) as venta_mensual_promedio_con_precio_vigente
from v_factura1_factura2_harinas
group by 1, 2, 3
