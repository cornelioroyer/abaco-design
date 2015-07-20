select pla_dinero.codigo_empleado
from pla_dinero, pla_periodos
where pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.tipo_de_calculo = '1'
and pla_dinero.compania in (1286, 1287, 1288, 1289, 1290, 1292, 1293, 1294, 1295, 1296, 1297, 1298, 1299, 1300, 1302, 1303, 1305, 1321, 1322, 1340, 1347)
and Anio(pla_periodos.dia_d_pago) = 2015
and Mes(pla_periodos.dia_d_pago) = 6
group by pla_dinero.codigo_empleado
order by pla_dinero.codigo_empleado
