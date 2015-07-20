
alter table tal_ot2
add column autorizar char(1);

alter table tal_ot2
add column usuario_autorizo char(10);

alter table tal_ot2
add column fecha_autorizo timestamp;

update tal_ot2
set autorizar = 'S', usuario_autorizo = current_user, fecha_autorizo = current_date;

alter table tal_ot2
alter column autorizar set not null;

