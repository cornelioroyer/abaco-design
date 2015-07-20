delete from gralparaxcia;
insert into gralparaxcia 
select '01', parametro, aplicacion, valor 
from matame where compania = '03';