update nomhoras
set tasaporhora = (select tasaporhora from tmp_rhuempl
                    where tmp_rhuempl.codigo_empleado = nomhoras.codigo_empleado),
    forma_de_registro = 'M'
where tipo_planilla = '1'
and year = 2012
and numero_planilla = 1
and fecha_laborable <= '2011-12-31'
