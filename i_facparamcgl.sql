insert into facparamcgl (almacen, codigo_valor_grupo, cuenta_ingreso, cta_vta_exenta,
cuenta_costo, cuenta_gastos)
select '01', codigo_valor_grupo, '6100100', '6100100', '6100100', '6100100'
from gral_valor_grupos
where grupo = 'CAT'
