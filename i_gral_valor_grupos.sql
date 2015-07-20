insert into gral_valor_grupos(grupo, aplicacion, codigo_valor_grupo,
gra_codigo_valor_grupo, desc_valor_grupo, status)
select 'CLA', 'INV', clase, categoria, descripcion, 'A'
from tmp_clases
where clase not in
(select codigo_valor_grupo from gral_valor_grupos)
