
--delete from pla_cheques_setup where id = 33;



insert into pla_cheques_setup(compania, banco, nombre, descripcion,
propiedades, renderer)
select 1304, 105, nombre, descripcion, propiedades, renderer
from pla_cheques_setup
where compania = 749
