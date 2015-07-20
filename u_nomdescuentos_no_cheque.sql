update nomdescuentos
set cod_ctabco = '01', no_cheque = 65036, motivo_bco = 'CH'
from nomacrem
where nomacrem.numero_documento = nomdescuentos.numero_documento
and nomacrem.codigo_empleado = nomdescuentos.codigo_empleado
and nomacrem.cod_concepto_planilla = nomdescuentos.cod_concepto_planilla
and nomacrem.compania = nomdescuentos.compania
and nomdescuentos.year <= 2011
and nomacrem.hacer_cheque = 'S'
and nomdescuentos.no_cheque is null



