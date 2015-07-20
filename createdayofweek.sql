drop function dayofweek(date);
create function dayofweek(date) returns float
as 'select extract(dow from $1) as dia' language 'sql';

