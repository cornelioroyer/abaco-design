drop view v_pla_acumulados;
create view v_pla_acumulados as
SELECT nom_conceptos_para_calculo.cod_concepto_planilla, nomctrac.compania, 
nomctrac.codigo_empleado, nomtpla2.dia_d_pago AS fecha, nom_tipo_de_calculo.descripcion, 
sum(nomctrac.monto * nomconce.signo) AS monto 
FROM nomctrac, nomconce, nom_tipo_de_calculo, nomtpla2, nom_conceptos_para_calculo 
WHERE nomctrac.tipo_planilla = nomtpla2.tipo_planilla
AND nomctrac.numero_planilla = nomtpla2.numero_planilla
AND nomctrac.year = nomtpla2.year
AND nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
AND nomctrac.tipo_calculo = nom_tipo_de_calculo.tipo_calculo
AND nomctrac.cod_concepto_planilla = nom_conceptos_para_calculo.concepto_aplica
GROUP BY nom_conceptos_para_calculo.cod_concepto_planilla, nomctrac.compania, nomctrac.codigo_empleado, 
nomtpla2.dia_d_pago, nom_tipo_de_calculo.descripcion
UNION 
SELECT nom_conceptos_para_calculo.cod_concepto_planilla, pla_preelaborada.compania, 
pla_preelaborada.codigo_empleado, pla_preelaborada.fecha, 'SALARIOS' AS descripcion, 
sum(pla_preelaborada.monto * nomconce.signo) AS monto 
FROM pla_preelaborada, nomconce, nom_conceptos_para_calculo 
WHERE pla_preelaborada.cod_concepto_planilla = nomconce.cod_concepto_planilla
AND pla_preelaborada.cod_concepto_planilla = nom_conceptos_para_calculo.concepto_aplica
GROUP BY nom_conceptos_para_calculo.cod_concepto_planilla, pla_preelaborada.compania, 
pla_preelaborada.codigo_empleado, pla_preelaborada.fecha
union
SELECT nom_conceptos_para_calculo.cod_concepto_planilla, 
pla_riesgos_profesionales.compania, 
pla_riesgos_profesionales.codigo_empleado, 
pla_riesgos_profesionales.hasta AS fecha, 
'RIESGOS PROF.' as descripcion, 
pla_riesgos_profesionales.monto 
FROM pla_riesgos_profesionales, nom_conceptos_para_calculo 
GROUP BY nom_conceptos_para_calculo.cod_concepto_planilla, 
pla_riesgos_profesionales.compania, 
pla_riesgos_profesionales.codigo_empleado, 
pla_riesgos_profesionales.hasta,
pla_riesgos_profesionales.monto
