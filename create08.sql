// drop function today();
create function anio(date) returns char
as 'select to_char($1, "YYYY") as year' language 'sql';

