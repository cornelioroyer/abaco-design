select descripcion, sum(monto) from v_pla_costos_x_proyecto
where compania = 745
and tipo_de_planilla = '1'
and tipo_de_calculo = '1'
and year = 2009
and numero_planilla = 16
group by 1, 2
order by 1, 2;

select desc_concepto, sum(monto) from v_pla_dinero_detallado
where compania = 745
and tipo_de_planilla = '1'
and tipo_de_calculo = '1'
and year = 2009
and numero_planilla = 16
group by 1
order by 1;