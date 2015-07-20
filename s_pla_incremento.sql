select pla_proyectos.descripcion, pla_cargos.descripcion, pla_incremento.recargo
from pla_proyectos, pla_incremento, pla_cargos
where pla_proyectos.id = pla_incremento.id_pla_proyectos
and pla_incremento.id_pla_cargos = pla_cargos.id
order by 1, 2
