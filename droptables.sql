select 'drop table ', relname , ' cascade;' from pg_class
where relname like 'tmp%' and relkind = 'r'