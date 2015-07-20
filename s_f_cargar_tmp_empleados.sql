

rollback work;

/*
begin work;
    select f_cargar_tmp_empleados(1300);
commit work;
*/

begin work;
    select f_cargar_tmp_acumulados(1287);
commit work;
