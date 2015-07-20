alter table nomconce
rename column porcentaje to porcentaje_old;

alter table nomconce
add column porcentaje decimal(15,5);

update nomconce
set porcentaje = porcentaje_old;

alter table nomconce
alter column porcentaje set not null;

alter table nomconce
drop column porcentaje_old;
