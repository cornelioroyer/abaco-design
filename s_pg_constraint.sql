select pg_constraint.* from pg_class, pg_constraint
where pg_class.relname = 'cglposteo'
and pg_constraint.confrelid = pg_class.oid;