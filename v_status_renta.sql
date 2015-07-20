drop view v_status_renta;

create view v_status_renta as
SELECT pla_companias.nombre as nombre_cia, pla_companias.compania, 
Trim(pla_empleados.nombre) || ' ' || Trim(pla_empleados.apellido) as nombre_empleado, 
pla_empleados.codigo_empleado, 
Round(f_periodos_pago(pla_empleados.compania, pla_empleados.codigo_empleado, pla_empleados.tipo_de_planilla, 2010),2) as periodos_pagos,
Round(f_acumulado_para(pla_empleados.compania, pla_empleados.codigo_empleado, '106', 2010),2) as acumulado,
Round(-f_concepto_pagado(pla_empleados.compania, pla_empleados.codigo_empleado, '106', 2010) 
+ f_isr(pla_empleados.compania,pla_empleados.codigo_empleado,pla_empleados.tipo_de_planilla,2010),2) as impuesto_causado,
Round(f_concepto_pagado(pla_empleados.compania, pla_empleados.codigo_empleado, '106', 2010),2) as impuesto_retenido,
Round(f_isr(pla_empleados.compania,pla_empleados.codigo_empleado,pla_empleados.tipo_de_planilla,2010),2) as renta_pagar
FROM planilla.pla_empleados pla_empleados, pla_companias
WHERE pla_empleados.compania = pla_companias.compania
and pla_empleados.fecha_terminacion_real Is Null 
and pla_empleados.status In ('A','V')
ORDER BY 1, 2, 3

