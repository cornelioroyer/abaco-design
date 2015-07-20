drop view v_cgl_presupuesto_detallado;

create view v_cgl_presupuesto_detallado as
SELECT cgl_presupuesto.compania, 
cgl_presupuesto.cuenta, cglcuentas.nombre,   
cgl_presupuesto.anio, cgl_presupuesto.mes, 
-(cgl_presupuesto.monto * cglcuentas.naturaleza) as monto
FROM cgl_presupuesto, cglcuentas
WHERE cgl_presupuesto.cuenta = cglcuentas.cuenta
