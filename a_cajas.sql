alter table cajas
add column status char(1);

update cajas
set status = 'A';

alter table cajas
alter column status set not null;

