

rollback work;

begin work;

alter table rhuempl add column cds_expedido date;
alter table rhuempl add column cds_vencimiento date;

/*
update rhuempl
set cdm_expedido = licencia_expedida, cdm_vencimiento = licencia_vencimiento;
*/

commit work;
