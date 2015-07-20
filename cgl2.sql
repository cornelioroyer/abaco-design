drop table cglperiodico1;
drop table cglperiodico2;
drop table cglperiodico3;
drop table cglperiodico4;
drop table cglpervalidos;

create table cglperiodico1
(
 compania char(2) not null references gralcompanias,
 num_transaccion integer not null,
 concepto char(3) not null references cglconceptos,
 estado char(1) not null,
 usuario_captura char(10) not null,
 usuario_actulizo char(10) not null,
 fecha_captura timestamp,
 fecha_actualizo timestamp,
 descripcion char(50) not null,
 primary key (compania, num_transaccion)
);

create table cglpervalidos
(
 compania char(2),
 num_transaccion integer,
 aplicacion char(3),
 year smallint,
 mes smallint,
 foreign key (compania, num_transaccion) references cglperiodico1,
 foreign key (aplicacion, year, mes) references gralperiodos,
 primary key (compania, num_transaccion, aplicacion, year, mes)
);


create table cglperiodico2
(
 compania char(2),
 num_transaccion integer,
 cuenta char(24) references cglcuentas,
 monto decimal(10,2) not null,
 foreign key(compania, num_transaccion) references cglperiodico1,
 primary key (compania, num_transaccion, cuenta) 
);

create table cglperiodico3
(
 compania char(2),
 num_transaccion integer,
 cuenta char(24),
 auxiliar1 char(10) not null references cglauxiliares,
 monto decimal(10,2) not null,
 foreign key(compania, num_transaccion, cuenta) references cglperiodico2,
 primary key (compania, num_transaccion, cuenta, auxiliar1) 
);

create table cglperiodico4
(
 compania char(2),
 num_transaccion integer,
 cuenta char(24),
 auxiliar2 char(10) not null references cglauxiliares,
 monto decimal(10,2) not null,
 foreign key(compania, num_transaccion, cuenta) references cglperiodico2,
 primary key (compania, num_transaccion, cuenta, auxiliar2) 
);

 
