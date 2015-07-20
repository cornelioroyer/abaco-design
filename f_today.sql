drop function today();
create function today() returns date
as 'select current_date as fecha' language 'sql';

