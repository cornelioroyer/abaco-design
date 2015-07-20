select f_stock('01', '41313', '2011-07-07', 0, 0, 'CANTIDAD') as cantidad,
f_stock('01', '41313', '2011-07-07', 0, 0, 'COSTO') as costo,
f_stock('01', '41313', '2011-07-07', 0, 0, 'CU') as cu,


select sum(cantidad) as cantidad, sum(costo)
from v_eys1_eys2
where articulo = '41313'
and fecha <= '2011-07-07';

