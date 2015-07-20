alter table rhuempl
add column viaticos decimal(10,2);

update rhuempl
set viaticos = 0;

alter table rhuempl
alter column viaticos set not null;
