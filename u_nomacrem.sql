update nomacrem
set status = 'E'
where exists
(select * from rhuempl
where rhuempl.compania = nomacrem.compania
and rhuempl.codigo_empleado = nomacrem.codigo_empleado
and rhuempl.status = 'I');

update nomacrem
set status = 'I'
where cod_acreedores in ('HP-127','HP-129')
and exists
(select * from rhuempl
where rhuempl.compania = nomacrem.compania
and rhuempl.codigo_empleado = nomacrem.codigo_empleado
and rhuempl.status in ('A','V'));