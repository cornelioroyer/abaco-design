select pg_attribute.* from pg_constraint, pg_class, pg_attribute
where conname = 'fk_rela_adc_reference_cglposte'
and pg_class.oid = pg_constraint.conrelid
and pg_class.oid = pg_attribute.attrelid
and pg_attribute.attnum = pg_constraint.conkey[1]