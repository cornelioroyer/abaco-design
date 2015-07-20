CREATE VIEW v_adc_top_ten AS
    SELECT v_adc_eficiencia.anio, v_adc_eficiencia.import_export, 
    v_adc_eficiencia.nombre_cliente, sum(v_adc_eficiencia.kgs) AS kgs, 
    sum(v_adc_eficiencia.teus) AS teus, sum(v_adc_eficiencia.cbm) AS cbm, 
    sum(v_adc_eficiencia.monto_factura_flete) AS venta 
    FROM v_adc_eficiencia 
    GROUP BY v_adc_eficiencia.anio, v_adc_eficiencia.import_export, 
    v_adc_eficiencia.nombre_cliente;
