select 'drop table ' || trim(relname) || ' cascade;'
from pg_class
where relkind = 'r'
and relname like '%tmp%'
order by relname
