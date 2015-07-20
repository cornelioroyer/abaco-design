begin work;
delete from fact_comparativo_de_ventas;
commit work;

begin work;
insert into fact_comparativo_de_ventas
select cliente, nomb_cliente, 2003, 2004, 7, 0, 0, 0, 0, 0, 0, 0, 0
from clientes;
commit work;

begin work;
update fact_comparativo_de_ventas
set q_hd_a1 = v_fact_ventas_x_clase.quintales,
v_hd_a1 = v_fact_ventas_x_clase.venta
where fact_comparativo_de_ventas.cliente = v_fact_ventas_x_clase.cliente
and mes = 7 and v_fact_ventas_x_clase.anio = 2003
and v_fact_ventas_x_clase.descripcion like '%DURA%';
commit work;

begin work;
update fact_comparativo_de_ventas
set q_hd_a2 = v_fact_ventas_x_clase.quintales,
v_hd_a2 = v_fact_ventas_x_clase.venta
where fact_comparativo_de_ventas.cliente = v_fact_ventas_x_clase.cliente
and mes = 7 and v_fact_ventas_x_clase.anio = 2004
and v_fact_ventas_x_clase.descripcion like '%DURA%';
commit work;

begin work;
update fact_comparativo_de_ventas
set q_hs_a1 = v_fact_ventas_x_clase.quintales,
v_hs_a1 = v_fact_ventas_x_clase.venta
where fact_comparativo_de_ventas.cliente = v_fact_ventas_x_clase.cliente
and mes = 7 and v_fact_ventas_x_clase.anio = 2003
and v_fact_ventas_x_clase.descripcion like '%SUAVE%';
commit work;

begin work;
update fact_comparativo_de_ventas
set q_hs_a2 = v_fact_ventas_x_clase.quintales,
v_hs_a2 = v_fact_ventas_x_clase.venta
where fact_comparativo_de_ventas.cliente = v_fact_ventas_x_clase.cliente
and mes = 7 and v_fact_ventas_x_clase.anio = 2004
and v_fact_ventas_x_clase.descripcion like '%SUAVE%';
commit work;


begin work;
delete from fact_comparativo_de_ventas
where q_hd_a1 + q_hd_a2 + q_hs_a1 + q_hd_a2 = 0;
commit work;