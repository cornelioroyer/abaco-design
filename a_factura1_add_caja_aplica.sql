
rollback work;


begin work;
    alter table factura1 add column almacen_aplica char(2);
    alter table factura1 add column tipo_aplica char(3);
    alter table factura1 add column caja_aplica char(3);
commit work;


begin work;
    alter table cxcdocm add column almacen_ref char(2);
    alter table cxcdocm add column caja_ref char(3);
commit work;

/*
    update cxcdocm
    set almacen_ref = almacen, caja_ref = caja;


    alter table cxcdocm
       drop constraint fk_cxcdocm_reference_cxcdocm  cascade;

    alter table cxcdocm
       add constraint fk_cxcdocm_reference_cxcdocm foreign key (docmto_aplicar, caja_ref, docmto_ref, cliente, motivo_ref, almacen_ref)
          references cxcdocm (documento, caja, docmto_aplicar, cliente, motivo_cxc, almacen)
          on delete restrict on update restrict;


*/

