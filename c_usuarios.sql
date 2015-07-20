
drop table usuarios cascade;

create table usuarios(
id serial not null,
usuario varchar(50) not null,
email varchar(100) not null,
password varchar(200) not null,
created_at timestamp not null,
updated_at timestamp not null,
PRIMARY KEY (id)
);

