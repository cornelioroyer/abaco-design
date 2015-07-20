select docm_ajuste_cxc, aplicar_a, motivo_cxc,
almacen, cliente, count(*)
from cxc_hijos
group by 1, 2, 3, 4, 5
having count(*) > 1