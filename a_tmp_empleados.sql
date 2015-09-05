
set search_path to planilla;

rollback work;

    alter table tmp_empleados
    drop column tipo_planilla;
    
    alter table tmp_empleados
    add column tipo_de_planilla char(2);
    
    update tmp_empleados
    set tipo_de_planilla = '2';

    
select f_cargar_tmp_empleados(1380);




/*

    alter table tmp_empleados
    add column cargo char(100);


    alter table tmp_empleados
    add column sindicalizado char(1);

    alter table tmp_empleados
    add column compania integer;

    update tmp_empleados
    set compania = 1380;


    alter table tmp_empleados
    drop column dv;

    alter table tmp_empleados
    add column dv char(2);

    alter table tmp_empleados
    drop column sindicalizado;

    alter table tmp_empleados
    add column sindicalizado char(1);

    alter table tmp_empleados
    add column compania integer;

    update tmp_empleados
    set compania = 1379;



    alter table tmp_empleados
    add column sindicalizado char(1);


begin work;

commit work;



alter table tmp_descuentos
add column compania integer;

update tmp_descuentos
set compania = 1299;

alter table tmp_acumulados
drop column compania;

alter table tmp_acumulados
add column compania integer;

update tmp_acumulados
set compania = 1299;

commit work;
*/
