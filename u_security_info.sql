
rollback work;
begin work;

   

alter table security_template
add column ventana varchar(64);

update security_template
set ventana = window;

alter table security_template
drop column window;

create unique index i1_security_template on security_template (
application,
ventana,
control
);


alter table security_info
add column ventana varchar(64);

update security_info
set ventana = window;

alter table security_info
drop column window;


create unique index i1_security_info on security_info (
application,
ventana,
control,
user_name
);



commit work;
