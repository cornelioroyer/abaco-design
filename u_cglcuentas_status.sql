

rollback work;

begin work;
    update cglcuentas
    set tipo_cuenta = 'B'
    where cuenta like '2%';
commit work;


/*


begin work;

    update cglcuentas
    set status = 'X'
    where status = 'I';

commit work;

begin work;

    update cglcuentas
    set status = 'X'
    where status = 'I';

commit work;

update articulos
set status_articulo = 'I'
where status_articulo = 'X';

update cglcuentas
set status = 'X'
where status = 'I';

update articulos
set status_articulo = 'X'
where status_articulo = 'I';

*/
