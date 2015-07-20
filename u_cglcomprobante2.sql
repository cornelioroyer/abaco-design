update cglcomprobante2
set cuenta = '2604'
where cuenta = '2221'
and exists 
(select * from cglcomprobante1
where cglcomprobante1.secuencia = cglcomprobante2.secuencia
and cglcomprobante1.compania = cglcomprobante2.compania
and cglcomprobante1.aplicacion = cglcomprobante2.aplicacion
and cglcomprobante1.year = cglcomprobante2.year
and cglcomprobante1.periodo = cglcomprobante2.periodo
and cglcomprobante1.compania = '01'
and cglcomprobante1.fecha_comprobante >= '2004-01-01');
