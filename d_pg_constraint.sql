select 'delete from ' || pg_class.relname || ' where compania <> ''02'';' from pg_class
where relkind = 'r'
and oid in (select pg_constraint.conrelid from pg_class, pg_constraint
                        where pg_class.relname = 'gralcompanias'
                        and pg_constraint.confrelid = pg_class.oid)
