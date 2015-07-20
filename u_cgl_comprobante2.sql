update cgl_comprobante2
set auxiliar = '0000'
where cglcuentas.cuenta = cgl_comprobante2.cuenta
and cglcuentas.auxiliar_1 = 'S'
and cgl_comprobante2.auxiliar is null;
