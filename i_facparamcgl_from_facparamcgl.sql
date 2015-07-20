insert into facparamcgl (almacen, codigo_valor_grupo,
cuenta_ingreso, cuenta_devolucion, cta_vta_exenta,
cuenta_costo, cuenta_gastos, auxiliar1_ingreso, 
auxiliar2_ingreso, auxiliar1_costo, auxiliar2_costo)
select '09', codigo_valor_grupo,
cuenta_ingreso, cuenta_devolucion, cta_vta_exenta,
cuenta_costo, cuenta_gastos, auxiliar1_ingreso, 
auxiliar2_ingreso, auxiliar1_costo, auxiliar2_costo from facparamcgl
where almacen = '01';
