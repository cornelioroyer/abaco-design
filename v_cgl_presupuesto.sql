drop view v_cgl_presupuesto;
create view v_cgl_presupuesto as
SELECT cgl_presupuesto.compania, cgl_financiero.no_informe, 
cgl_presupuesto.anio, cgl_presupuesto.mes, 
cgl_financiero.d_fila, 
Sum(cgl_presupuesto.monto * cglcuentas.naturaleza) as monto
FROM cgl_presupuesto, cgl_financiero, cglcuentas
WHERE cgl_presupuesto.cuenta = cgl_financiero.cuenta
and cgl_presupuesto.cuenta = cglcuentas.cuenta
GROUP BY 1, 2, 3, 4, 5