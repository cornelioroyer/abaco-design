insert into cgl_financiero 
select 14, cuenta, '4others' from cglcuentas, cglniveles
where cglcuentas.nivel = cglniveles.nivel
and cglniveles.recibe = 'S'
and cglcuentas.cuenta like '4%'
and cuenta not in
(select cuenta from cgl_financiero
where no_informe = 14);
