select 'copy '||trim(relname)||' from ''/tmp1/'||trim(relname)||'.sql'';' from pg_class
where relkind = 'r'
order by relname
