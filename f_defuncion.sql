set search_path to dba;

drop function f_defuncion(char(1)) cascade;

create function f_defuncion(char(1)) returns integer as '
declare
    as_status alias for $1;
    r_rhuempl record;
begin
    update nomacrem
    set status = as_status
    where cod_acreedores = ''DEFUNCION'';
    
    if as_status <> ''A'' then
        return 1;
    end if;
    
    for r_rhuempl in select * from rhuempl
                        where not exists
                            (select * nomacrem
                                where compania = rhuempl.compania
                                and codigo_empleado = rhuempl.codigo_empleado
                                and cod_acreedores = ''DEFUNCION'')
                    order by codigo_empleado
    loop
        insert into nomacrem(compania, codigo_empleado, cod_concepto_planilla, numero_documento,
            cod_acreedores, descripcion_descuento, monto_original_deuda, letras_a_pagar,
            fecha_ini_descto, fecha_final_descto, status, observacion, hacer_cheque, incluir_deduc_
    end loop;
   
    return 1; 
end;
' language plpgsql;    


select f_defuncion('A');
