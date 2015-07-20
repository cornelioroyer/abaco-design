
update gralparaxcia
set valor = 'N'
where parametro = 'validar_fecha'
and aplicacion = 'CXP';

begin work;
    delete from cxpdocm 
    where compania = '03'
    and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref);
commit work;


begin work;
    delete from cxpdocm
    where compania = '03';
commit work;

begin work;
    insert into cxpdocm
    select * from tmp_cxpdocm
    where compania = '03'
    and (documento = docmto_aplicar and motivo_cxp = motivo_cxp_ref);
commit work;

begin work;
    insert into cxpdocm
    select * from tmp_cxpdocm
    where compania = '03'
    and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref);
commit work;


update gralparaxcia
set valor = 'S'
where parametro = 'validar_fecha'
and aplicacion = 'CXP';