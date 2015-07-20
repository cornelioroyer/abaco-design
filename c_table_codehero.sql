

drop table producto;
drop table vendedor;



CREATE TABLE  vendedor (
id serial not null,
nombre varchar( 100 ) NOT NULL ,
apellido varchar( 100 ) NOT NULL ,
created_at TIMESTAMP NOT NULL ,
updated_at TIMESTAMP NOT NULL,
primary key(id)
);

create table producto (
id serial not null,
vendedor_id integer not null references vendedor,
descripcion varchar(255) NOT NULL ,
precio decimal( 10, 2 ) NOT NULL ,
created_at TIMESTAMP NOT NULL ,
updated_at TIMESTAMP NOT NULL,
primary key(id)
)


 
