select 'copy '||trim(relname)||' to ''/tmp1/'||trim(relname)||'.sql'';' from pg_class
where relkind = 'r'
order by relname
