begin work;
alter table gralcompanias
rename column mensaje to mensa;

alter table gralcompanias
add column mensaje text;

update gralcompanias
set mensaje = mensa;

alter table gralcompanias
drop column mensa;

commit work;