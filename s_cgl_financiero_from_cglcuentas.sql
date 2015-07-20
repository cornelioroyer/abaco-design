
select 14, cuenta, '4others' from cglcuentas, cglniveles
where cglcuentas.nivel = cglniveles.nivel
and cglniveles.recibe = 'S'
and cglcuentas.tipo_cuenta = 'B'
and cuenta not in 
(select cuenta from cgl_financiero
where no_informe = 13);
