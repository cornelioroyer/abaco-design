drop view v_salarios_harinas;
create view v_salarios_harinas as
SELECT rhuempl.nombre_del_empleado, rhuempl.grup_impto_renta, 
rhuempl.num_dependiente, 
(f_acumulado_para(compania,codigo_empleado,2009,'106')+(rhuempl.salario_bruto*7)+
(rhuempl.salario_bruto*2/3)) as salario_anual,
(select monto from nomctrac
where nomctrac.compania = rhuempl.compania
and nomctrac.codigo_empleado = rhuempl.codigo_empleado
and nomctrac.year = 2008
and nomctrac.cod_concepto_planilla = '260') as bono
FROM rhuempl rhuempl
WHERE (rhuempl.tipo_planilla='2') AND (rhuempl.status In ('A','V'))
ORDER BY 4 DESC