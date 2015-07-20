drop function dayofweek;
create function today() returns date
as 'select current_date as fecha' language 'sql';

