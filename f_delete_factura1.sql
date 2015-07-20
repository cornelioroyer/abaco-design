select * from factura1
where not exists
(select * from f_conytram_resumen
where f_conytram_resumen.almacen = factura1.almacen
and f_conytram_resumen.tipo = factura1.tipo
and f_conytram_resumen.documento = factura1.documento)