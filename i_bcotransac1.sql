rollback work;

begin work;
    insert into bcotransac1(cod_ctabco, sec_transacc, motivo_bco,
        fecha_transacc, fecha_posteo, usuario, fecha_captura, obs_transac_bco,
        status, monto, no_docmto, aplicacion)
    select cod_ctabco, (secuencia + 1000), motivo_bco,
        fecha, fecha, current_user, current_date, observacion, 'R', monto1,
        to_char((secuencia+1000), '99999'), 'BCO'
    from cf_bco_1;


    insert into bcotransac2(cod_ctabco, sec_transacc, line, cuenta, monto)
    select cod_ctabco, (secuencia+1000), 1, cuenta, monto1
    from cf_bco_2;
commit work; 
