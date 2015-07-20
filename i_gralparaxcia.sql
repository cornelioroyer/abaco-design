insert into gralparaxcia (compania, parametro, aplicacion, valor)
select '07', parametro, aplicacion, valor
from gralparaxcia
where compania = '01';