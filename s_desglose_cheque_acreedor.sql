  SELECT  gralcompanias.nombre ,           rhuempl.apellido_paterno ,           
  rhuempl.primer_nombre ,           rhuacre.nombre_acreedores ,           
  rhuacre.cod_acreedores ,           nomctrac.monto ,           
  nomtpla2.dia_d_pago ,           rhuempl.codigo_empleado ,           
  nomtpla2.year ,           nomacrem.numero_documento ,           
  nomdescuentos.no_cheque ,           nomctrac.tipo_planilla ,           
  nomacrem.hacer_cheque ,           nomdescuentos.tipo_calculo     
  FROM gralcompanias ,           nomacrem ,           rhuacre ,           
  rhuempl ,           nomdescuentos ,           nomctrac ,           nomtpla2     
  WHERE ( gralcompanias.compania = rhuempl.compania ) 
  and          ( nomacrem.cod_acreedores = rhuacre.cod_acreedores ) 
  and          ( nomacrem.codigo_empleado = rhuempl.codigo_empleado ) 
  and          ( nomacrem.compania = rhuempl.compania ) 
  and          ( nomacrem.numero_documento = nomdescuentos.numero_documento ) 
  and          ( nomacrem.codigo_empleado = nomdescuentos.codigo_empleado ) 
  and          ( nomacrem.compania = nomdescuentos.compania ) 
  and          ( nomdescuentos.cod_concepto_planilla = nomacrem.cod_concepto_planilla ) 
  and          ( nomctrac.codigo_empleado = nomdescuentos.codigo_empleado ) 
  and          ( nomctrac.compania = nomdescuentos.compania ) 
  and          ( nomdescuentos.tipo_calculo = nomctrac.tipo_calculo ) 
  and          ( nomctrac.cod_concepto_planilla = nomdescuentos.cod_concepto_planilla ) 
  and          ( nomdescuentos.tipo_planilla = nomctrac.tipo_planilla ) 
  and          ( nomctrac.numero_planilla = nomdescuentos.numero_planilla ) 
  and          ( nomdescuentos.year = nomctrac.year ) 
  and          ( nomctrac.numero_documento = nomdescuentos.numero_documento ) 
  and          ( nomtpla2.tipo_planilla = nomctrac.tipo_planilla ) 
  and          ( nomctrac.numero_planilla = nomtpla2.numero_planilla ) 
  and          ( nomtpla2.year = nomctrac.year ) 
  and          ( ( gralcompanias.compania = :as_cia ) 
  And          ( nomtpla2.dia_d_pago between :ad_desde and :ad_hasta ) 
  and          ( nomacrem.hacer_cheque = 'S' ) )  
