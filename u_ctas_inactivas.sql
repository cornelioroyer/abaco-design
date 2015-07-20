update cglcuentas
set status = 'I'
where cuenta in (select cuenta from cgl_ctas_inactivas);

