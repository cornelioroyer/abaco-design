drop function f_crear_auxiliares();

create function f_crear_auxiliares() returns integer as '
declare
    r_clientes record;
    r_proveedores record;
    r_rhuempl record;
    r_cglauxiliares record;
begin

    for r_clientes in select * from clientes 
    where nomb_cliente is not null
    order by cliente
    loop
        select into r_cglauxiliares * from cglauxiliares
        where Trim(auxiliar) = trim(r_clientes.cliente);
        if not found then
            insert into cglauxiliares(auxiliar, nombre, status, tipo_persona, id, dv)
            values (Trim(r_clientes.cliente), Trim(r_clientes.nomb_cliente), ''A'', 
            r_clientes.tipo_de_persona, r_clientes.id, substring(trim(r_clientes.dv) from 1 for 2));
        else
            update cglauxiliares
            set nombre = Trim(r_clientes.nomb_cliente), id = r_clientes.id, dv = substring(trim(r_clientes.dv) from 1 for 2), tipo_persona = r_clientes.tipo_de_persona
            where Trim(auxiliar) = trim(r_clientes.cliente);
        end if;
    end loop;


    for r_proveedores in select * from proveedores 
    where nomb_proveedor is not null
    order by proveedor
    loop
        select into r_cglauxiliares * from cglauxiliares
        where Trim(auxiliar) = trim(r_proveedores.proveedor);
        if not found then
            insert into cglauxiliares(auxiliar, nombre, status, tipo_persona, id, dv)
            values (Trim(r_proveedores.proveedor), Trim(r_proveedores.nomb_proveedor), ''A'', r_proveedores.tipo_de_persona, r_proveedores.id_proveedor, Substring(Trim(r_proveedores.dv_proveedor) from 1 for 2));
        else
            update cglauxiliares
            set nombre = Trim(r_proveedores.nomb_proveedor),
            id = r_proveedores.id_proveedor, dv = substring(trim(r_proveedores.dv_proveedor) from 1 for 2), tipo_persona = r_proveedores.tipo_de_persona
            where Trim(auxiliar) = trim(r_proveedores.proveedor);
        end if;
        
    end loop;


    for r_rhuempl in select * from rhuempl 
    where nombre_del_empleado is not null
    order by codigo_empleado
    loop
        select into r_cglauxiliares * from cglauxiliares
        where Trim(auxiliar) = trim(r_rhuempl.codigo_empleado);
        if not found then
            insert into cglauxiliares(auxiliar, nombre, status, tipo_persona, id, dv)
            values (Trim(r_rhuempl.codigo_empleado), Trim(r_rhuempl.nombre_del_empleado), ''A'', ''1'', r_rhuempl.numero_cedula, r_rhuempl.dv);
        else
            update cglauxiliares
            set nombre = Trim(r_rhuempl.nombre_del_empleado),
            id = r_rhuempl.numero_cedula, dv = r_rhuempl.dv, tipo_persona = ''1''
            where Trim(auxiliar) = trim(r_rhuempl.codigo_empleado);
        end if;
    end loop;

    
    return 1;
end;
' language plpgsql;

select f_crear_auxiliares()
