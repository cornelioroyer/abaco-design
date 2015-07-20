select apellido, nombre, codigo_empleado, 1
from v_pla_dinero_resumido
where compania = 1142
and fecha between '2014-05-01' and '2014-05-31'
group by 1, 2, 3
order by 1, 2, 3
