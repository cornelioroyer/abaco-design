insert into gralparaxcia (compania, parametro, aplicacion, valor)
select '05', parametro, aplicacion, valor
from gralparaxcia
where compania = '02'
and not exists
(select * from gralparaxcia c
where c.compania = '05'
and c.parametro = gralparaxcia.parametro
and c.aplicacion = gralparaxcia.aplicacion);
