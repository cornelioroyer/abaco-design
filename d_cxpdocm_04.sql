rollback work;

    update gralparaxcia
    set valor = 'N'
    where compania = '04'
    and parametro = 'validar_fecha'
    and aplicacion = 'CXP';

begin work;
    delete from cxpdocm
    where compania = '04'
    and fecha_posteo >= '1987-07-01'
    and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref);
commit work;




begin work;
    delete from cxpdocm
    where compania = '04'
    and fecha_posteo >= '1987-07-01';
commit work;


/*
begin work;
    select f_update_cxpdocm('04');
commit work;
*/
