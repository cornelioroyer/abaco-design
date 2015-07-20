select 'drop table ' || trim(relname) || ' cascade;'
from pg_class
where relkind = 'r'
and relname not like 'pg%'
order by relname