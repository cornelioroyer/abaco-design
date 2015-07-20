drop function anio(date);
create function anio(date) returns float
as 'select extract("year" from $1) as anio' language 'sql';


