insert into gralperiodos (compania, aplicacion, year, periodo, descripcion, inicio, final, estado)
select '05', aplicacion, year, periodo, descripcion, inicio, final, estado
from gralperiodos
where  compania = '01'
and aplicacion = 'TAL'
and not exists
(select * from gralperiodos c
where c.compania = gralperiodos.compania
and c.aplicacion = gralperiodos.aplicacion
and c.year = gralperiodos.year
and c.periodo = gralperiodos.periodo);

