drop function mes(date);
create function mes(date) returns float
as 'select extract("month" from $1) as mes' language 'sql';


