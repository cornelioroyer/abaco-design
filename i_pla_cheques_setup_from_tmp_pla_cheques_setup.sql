
--delete from pla_cheques_setup where id = 33;


delete from pla_cheques_setup where compania = 1261;

insert into pla_cheques_setup(compania, banco, nombre, descripcion,
propiedades, renderer)
select compania, banco, nombre, descripcion, propiedades, renderer
from tmp_pla_cheques_setup
where compania = 1261;

