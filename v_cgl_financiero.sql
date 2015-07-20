drop view v_cgl_financiero;
create view v_cgl_financiero as
SELECT a.compania, b.no_informe, a.year, a.periodo, b.d_fila, Sum(a.debito-a.credito) as corriente, Sum(a.balance_inicio+a.debito-a.credito) as acumulado
FROM dba.cglsldocuenta a, dba.cgl_financiero b
WHERE (a.cuenta=b.cuenta)
GROUP BY a.compania, b.no_informe, a.year, a.periodo, b.d_fila
ORDER BY a.compania, b.no_informe, a.year, a.periodo, b.d_fila