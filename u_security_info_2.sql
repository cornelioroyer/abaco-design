
rollback work;
begin work;

alter table security_template
add column ventana varchar(64);

update security_template
set ventana = window;



alter table security_info
add column ventana varchar(64);

update security_info
set ventana = window;




commit work;
