select cuenta from cglcuentas, cglniveles
where cglcuentas.nivel = cglniveles.nivel
and tipo_cuenta = 'B'
and cglniveles.recibe = 'S'
and cuenta not in
(select cuenta from cgl_financiero 
where no_informe = 4)
order by 1