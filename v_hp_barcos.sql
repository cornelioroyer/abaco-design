

drop view v_hp_barcos_x_anio;

create view v_hp_barcos_x_anio as
select trim(hp_molinos.descripcion) as d_molino, 
hp_molinos.molino,
tipo_de_trigo, Anio(fecha) as anio,  
(sum(costo)/sum(toneladas)) as costo,
sum(costo) as sum_costo,
sum(toneladas) as sum_toneladas
from hp_barcos, hp_molinos
where hp_barcos.molino = hp_molinos.molino
group by 1, 2, 3, 4;




drop view v_hp_barcos;

create view v_hp_barcos as
select trim(hp_molinos.descripcion) as d_molino, hp_molinos.molino,
tipo_de_trigo, Anio(fecha), Mes(fecha), 
(sum(costo)/sum(toneladas)) as costo,
sum(costo) as sum_costo,
sum(toneladas) as sum_toneladas
from hp_barcos, hp_molinos
where hp_barcos.molino = hp_molinos.molino
group by 1, 2, 3, 4, 5;


drop function f_compra_anual(char(3), integer) cascade;

create function f_compra_anual(char(3), integer) returns decimal(12,4) as '
declare
    as_tipo_de_trigo alias for $1;
    ai_anio alias for $2;
    ldc_retorno decimal(12,4);
begin

    ldc_retorno = 0;
    
    select sum(toneladas) into ldc_retorno
    from hp_barcos
    where tipo_de_trigo = as_tipo_de_trigo
    and Anio(fecha) = ai_anio;
    
    if ldc_retorno is null then
        ldc_retorno = 0;
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;

drop function f_compra_anual(integer) cascade;

create function f_compra_anual(integer) returns decimal(12,4) as '
declare
    ai_anio alias for $1;
    ldc_retorno decimal(12,4);
begin

    ldc_retorno = 0;
    
    select sum(toneladas) into ldc_retorno
    from hp_barcos
    where Anio(fecha) = ai_anio;
    
    if ldc_retorno is null then
        ldc_retorno = 0;
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;

