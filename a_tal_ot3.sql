alter table tal_ot3
add column fecha date;

update tal_ot3
set fecha = current_date;

alter table tal_ot3
alter column fecha set not null;
