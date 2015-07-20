update cglcuentas
set tipo_cuenta = 'R';

update cglcuentas
set tipo_cuenta = 'B'
where cuenta like '1%'
or cuenta like '2%'
or cuenta like '3%';
