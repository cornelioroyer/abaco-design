select * from pla_empleados, pla_proyectos
where pla_empleados.id_pla_proyectos = pla_proyectos.id
and pla_proyectos.compania in (select compania from tmp_cias_expiradas);
