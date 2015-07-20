drop view v_estado_d_resultado;
create view v_estado_d_resultado as
select c.compania, c.year, c.periodo, b.cuenta, b.nombre, 
-(c.debito-c.credito) as corriente, -(c.balance_inicio+c.debito-c.credito) as acumulado
from cglniveles a, cglcuentas b, cglsldocuenta c
where a.nivel = b.nivel
and b.cuenta = c.cuenta
and b.tipo_cuenta = 'R'
and a.recibe = 'S';