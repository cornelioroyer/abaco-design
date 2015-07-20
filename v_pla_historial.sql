drop view v_pla_historial;
create view v_pla_historial as
SELECT nomctrac.compania, nomctrac.codigo_empleado, nomtpla2.dia_d_pago AS fecha,
nomctrac.cod_concepto_planilla,  nom_tipo_de_calculo.descripcion, 
sum(nomctrac.monto * nomconce.signo) AS monto 
FROM nomctrac, nomconce, nom_tipo_de_calculo, nomtpla2
WHERE nomctrac.tipo_planilla = nomtpla2.tipo_planilla
AND nomctrac.numero_planilla = nomtpla2.numero_planilla
AND nomctrac.year = nomtpla2.year
AND nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
AND nomctrac.tipo_calculo = nom_tipo_de_calculo.tipo_calculo
GROUP BY nomctrac.compania, nomctrac.codigo_empleado, nomtpla2.dia_d_pago,
nomctrac.cod_concepto_planilla,  nom_tipo_de_calculo.descripcion
UNION 
SELECT pla_preelaborada.compania, pla_preelaborada.codigo_empleado, pla_preelaborada.fecha,
pla_preelaborada.cod_concepto_planilla, 'SALARIOS' AS descripcion, 
sum(pla_preelaborada.monto * nomconce.signo) AS monto 
FROM pla_preelaborada, nomconce
WHERE pla_preelaborada.cod_concepto_planilla = nomconce.cod_concepto_planilla
GROUP BY pla_preelaborada.compania, pla_preelaborada.codigo_empleado, pla_preelaborada.fecha,
pla_preelaborada.cod_concepto_planilla
union
SELECT pla_riesgos_profesionales.compania, pla_riesgos_profesionales.codigo_empleado, pla_riesgos_profesionales.hasta AS fecha, 
'100', 'RIESGOS PROF.' as descripcion, sum(pla_riesgos_profesionales.monto)
FROM pla_riesgos_profesionales
GROUP BY pla_riesgos_profesionales.compania, pla_riesgos_profesionales.codigo_empleado, pla_riesgos_profesionales.hasta;



