begin work;

delete from cglsldocuenta
where year = 2001 and
periodo <= 3;

delete from cglposteo
where fecha_comprobante
between '2001-3-1' and '2001-3-31';

update cglctasxaplicacion 
set status = 'I';

commit work;