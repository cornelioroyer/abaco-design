select cuenta from cglcuentas, cglniveles
where cglcuentas.nivel = cglniveles.nivel
and cglniveles.recibe = 'S'
and cuenta like '41%'
and cuenta not in
(select cuenta from cgl_financiero
where no_informe = 41)