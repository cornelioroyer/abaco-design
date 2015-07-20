rollback work;


begin work;
    delete from cxcbalance
    where compania = '03'
    and year = 2013 and periodo = 8;
commit work;



begin work;
    insert into cxcbalance (aplicacion, compania, cliente, year, periodo, saldo)
    select 'CXC', almacen.compania, cxcdocm.cliente, 2013, 8, sum(cxcmotivos.signo*cxcdocm.monto)
    from cxcdocm, almacen, cxcmotivos
    where cxcdocm.almacen = almacen.almacen
    and cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
    and cxcdocm.fecha_posteo <= '2013-08-31'
    and almacen.compania = '03'
    group by almacen.compania, cxcdocm.cliente;
commit work;

