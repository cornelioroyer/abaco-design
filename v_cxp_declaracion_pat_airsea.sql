drop view v_cxp_declaracion_pat_airsea;
drop function f_monto_pat_airsea(char(2), int4, int4) cascade;

create function f_monto_pat_airsea(char(2), int4, int4) returns decimal as '
declare
    as_cia alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ldc_retorno decimal;
    r_adc_master record;
begin
    select into r_adc_master * from adc_master
    where compania = as_cia
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    
    ldc_retorno = 0;
    if r_adc_master.cargo_prepago = ''N'' then
        ldc_retorno = ldc_retorno + r_adc_master.cargo;
    end if;
    
    if r_adc_master.gtos_prepago = ''N'' then
        ldc_retorno = ldc_retorno + r_adc_master.gtos_destino;
    end if;
    
    if r_adc_master.dthc_prepago = ''N'' then
        ldc_retorno = ldc_retorno + r_adc_master.dthc;
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;


create view v_cxp_declaracion_pat_airsea as
select '2' as tipo_de_persona,proveedores.id_proveedor,proveedores.dv_proveedor, proveedores.nomb_proveedor,
cxpfact1.fact_proveedor, cxpfact1.fecha_posteo_fact_cxp, '1' as concepto,'1' as local_importacion,0 as monto, (cglposteo.debito-cglposteo.credito) as itbms
from cxpfact1, rela_cxpfact1_cglposteo, cglposteo, proveedores, 
gralcompanias, cxpmotivos
where cxpfact1.proveedor = rela_cxpfact1_cglposteo.proveedor
and cxpfact1.compania = rela_cxpfact1_cglposteo.compania
and cxpfact1.fact_proveedor = rela_cxpfact1_cglposteo.fact_proveedor
and rela_cxpfact1_cglposteo.consecutivo = cglposteo.consecutivo
and cxpfact1.proveedor = proveedores.proveedor
and cxpfact1.motivo_cxp = cxpmotivos.motivo_cxp
and cglposteo.cuenta not in (select cuenta from proveedores group by 1)
and cglposteo.cuenta in (select cuenta from gral_impuestos)
union
select '2',proveedores.id_proveedor,proveedores.dv_proveedor, proveedores.nomb_proveedor,
cxpfact1.fact_proveedor, cxpfact1.fecha_posteo_fact_cxp, '1','1', (cglposteo.debito-cglposteo.credito), 0
from cxpfact1, rela_cxpfact1_cglposteo, cglposteo, proveedores, 
gralcompanias, cxpmotivos
where cxpfact1.proveedor = rela_cxpfact1_cglposteo.proveedor
and cxpfact1.compania = rela_cxpfact1_cglposteo.compania
and cxpfact1.fact_proveedor = rela_cxpfact1_cglposteo.fact_proveedor
and rela_cxpfact1_cglposteo.consecutivo = cglposteo.consecutivo
and cxpfact1.proveedor = proveedores.proveedor
and cxpfact1.motivo_cxp = cxpmotivos.motivo_cxp
and cglposteo.cuenta not in (select cuenta from proveedores group by 1)
and cglposteo.cuenta not in (select cuenta from gral_impuestos)
union
select '2', proveedores.id_proveedor, proveedores.dv_proveedor, proveedores.nomb_proveedor,
adc_master.no_bill, adc_manifiesto.fecha, '1','1', 
f_monto_pat_airsea(adc_master.compania, adc_master.consecutivo, adc_master.linea_master), 0
from adc_manifiesto, adc_master, navieras, proveedores
where adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and navieras.proveedor = proveedores.proveedor;



