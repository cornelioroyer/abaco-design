
rollback work;

begin work;

alter table rhuempl add column cds_expedido date;
alter table rhuempl add column cds_vencimiento date;
alter table rhuempl add column dependientes int4;
alter table rhuempl add column emergencia_nombre varchar(100);
alter table rhuempl add column emergencia_telefono varchar(30);
alter table rhuempl add column tipo_licencia_manejar varchar(2);
alter table rhuempl add column licencia_expedida date;
alter table rhuempl add column licencia_vencimiento date;

commit work;
