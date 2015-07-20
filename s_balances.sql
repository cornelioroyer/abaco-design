SELECT a.compania, b.no_informe, a.year, a.periodo, b.d_fila, Sum(a.debito-a.credito), Sum(a.balance_inicio+a.debito-a.credito)
FROM dba.cglsldocuenta a, dba.cgl_financiero b
WHERE (a.cuenta=b.cuenta)
GROUP BY a.compania, b.no_informe, a.year, a.periodo, b.d_fila
ORDER BY a.compania, b.no_informe, a.year, a.periodo, b.d_fila