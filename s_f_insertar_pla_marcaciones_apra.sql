

set search_path to planilla;

select f_insertar_pla_marcaciones_apra(compania, codigo_empleado, 
                numero_de_planilla,
                turno, id_pla_proyectos, fecha, entrada1, salida1, 
                implemento, entrada2, salida2,
                entrada3, salida3, status)
from pla_horarios_suntracs;
                


/*
select f_insertar_pla_marcaciones_apra(1341, codigo_empleado, numero_de_planilla,
    turno, proyecto, fecha, f_extract_time(entrada), f_extract_time(salida), 
    f_extract_time(entrada2), f_extract_time(salida2), 
    f_extract_time(entrada3), f_extract_time(salida3), status)
from tmp_horarios_apra

where codigo_empleado = '0035'


select *
from tmp_apra
where codigo_empleado = '0105'

*/
