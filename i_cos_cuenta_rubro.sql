insert into cos_cuenta_rubro (cuenta, rubro, status, costos)
select cuenta, 'OTR', 'A', 'S' from cglcuentas, cglniveles
where cglcuentas.nivel = cglniveles.nivel
and cglniveles.recibe = 'S'
and cglcuentas.cuenta like '5%'
and cuenta not in
(select cuenta from cos_cuenta_rubro)

