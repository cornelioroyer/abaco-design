drop function dia(timestamp);

create function dia(timestamp) returns float
as 'select extract(day from $1) as dia' language 'sql';

select entrada, dia(entrada)
from pla_marcaciones
where compania = 992
and dia(entrada) = 27;

delete from pla_marcaciones
where compania = 992
and dia(entrada) = 27;
