


insert into cgl_financiero(no_informe, cuenta, d_fila)
select 2, cuenta, 'varios' from cglcuentas, cglniveles
where cglcuentas.nivel = cglniveles.nivel
and cglniveles.recibe = 'S'
and cglcuentas.cuenta like '6%'
and cuenta not in 
(select cuenta from cgl_financiero
where no_informe = 2);

/*
and cglcuentas.tipo_cuenta = 'B'

delete from cgl_financiero
where no_informe = 1;


and trim(cglcuentas.cuenta) like '6%'

insert into cgl_financiero(no_informe, cuenta, d_fila)
select 14, cuenta, '4others' from cglcuentas, cglniveles
where cglcuentas.nivel = cglniveles.nivel
and cglniveles.recibe = 'S'
and cglcuentas.tipo_cuenta = 'R'
and trim(cglcuentas.cuenta) like '4%'
and cuenta not in 
(select cuenta from cgl_financiero
where no_informe = 14);


insert into cgl_financiero(no_informe, cuenta, d_fila)
select 3, cuenta, '8850205' from cglcuentas, cglniveles
where cglcuentas.nivel = cglniveles.nivel
and cglniveles.recibe = 'S'
and cglcuentas.tipo_cuenta = 'R'
and trim(cglcuentas.cuenta) = '8850205'
and cuenta not in 
(select cuenta from cgl_financiero
where no_informe = 3);





*/
