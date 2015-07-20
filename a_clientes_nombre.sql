

rollback work;

begin work;


    drop view v_adc_notificacion cascade;
    drop view v_adc_control_entrega cascade;
    drop view v_adc_cxc_1 cascade;
    drop view v_ventas_x_cliente_harinas cascade;
    drop view v_apc_refere cascade;
    drop view v_formulario_43_dgi cascade;
    drop view v_ventas_costos cascade;
    drop view v_list_cobros_airsea cascade;
    drop view v_f_conytram cascade;
    drop view v_fact_ventas_x_clase_detalladas cascade;
    drop view v_fact_ventas_x_clase cascade;
    drop view f_conytram_resumen cascade;
    drop view v_adc_estadisticas_venta cascade;
    drop view v_adc_estadisticas_x_cliente cascade;
    drop view v_adc_estadisticas cascade;
    drop view v_adc_eficiencia cascade;
    drop view v_adc_comisiones cascade;
    drop view v_adc_cargas_por_cliente_detallado cascade;


    
    alter table clientes alter column nomb_cliente type varchar(100);
commit work;
