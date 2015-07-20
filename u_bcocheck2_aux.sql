update bcocheck2
set auxiliar1 = '0000'
where cglcuentas.cuenta = bcocheck2.cuenta
and cglcuentas.auxiliar_1 = 'S'
and bcocheck2.auxiliar1 is null
and cod_ctabco = '41';
