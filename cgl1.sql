drop table cglniveles;
drop table cglcuentas;
drop table cglsecuencias;
drop table cglauxiliares;
drop table cglconceptos;
drop table cglcomprobante1;
drop table cglcomprobante2;
drop table cglcomprobante3;
drop table cglcomprobante4;
drop table cglposteo;
drop table cglhistposteo;


create table cglsecuencias
(
 compania char(2) not null references gralcompanias,
 aplicacion char(3),
 year smallint,
 mes smallint,
 secuencia integer not null,
 foreign key(aplicacion, year, mes) references gralperiodos,
 primary key(compania, aplicacion, year, mes) 
);

create table cglniveles
(
 nivel char(2) not null primary key,
 descripcion char(30) not null,
 posicion_inicial smallint not null,
 posicion_final smallint not null
);
 

create table cglcuentas
(
 cuenta char(24) not null primary key,
 nombre char(30) not null,
 nivel char(2) not null references cglniveles,
 naturaleza smallint not null,
 recibe char(1) not null,
 auxiliar_1 char(1) not null,
 auxiliar_2 char(1) not null,
 efectivo char(1) not null,
 tipo_cuenta char(1) not null,
 check (auxiliar_1 = 'S' or auxiliar_1 = 'N'),
 check (auxiliar_2 = 'S' or auxiliar_2 = 'N'),
 check (efectivo = 'S' or efectivo = 'N'),
 check (naturaleza = 1 or naturaleza = -1),
 check (tipo_cuenta = 'B' or tipo_cuenta = 'R')
);

create table cglauxiliares
(
 codigo char(10) not null primary key,
 nombre char(30) not null
);


create table cglconceptos
(
 codigo char(3) not null primary key,
 descripcion char(50) not null
);

create table cglcomprobante1
(
 compania char(2) not null references gralcompanias,
 num_comprobante char(10) not null,
 aplicacion_origen char(3) not null,
 concepto char(3) not null references cglconceptos,
 estado char(1) not null,
 usuario_captura char(10) not null,
 usuario_actualiza char(10) not null,
 fecha_comprobante date not null,
 fecha_captura timestamp,
 fecha_actualiza timestamp,
 descripcion char(50) not null,
 primary key(compania, num_comprobante)
);

create table cglcomprobante2
(
 compania char(2),
 num_comprobante char(10),
 cuenta char(24) references cglcuentas,
 monto decimal(10,2) not null,
 foreign key(compania, num_comprobante) references cglcomprobante1,
 primary key (compania, num_comprobante, cuenta) 
);

create table cglcomprobante3
(
 compania char(2),
 num_comprobante char(10),
 cuenta char(24),
 auxiliar1 char(10) not null references cglauxiliares,
 monto decimal(10,2) not null,
 foreign key(compania, num_comprobante, cuenta) references cglcomprobante2,
 primary key (compania, num_comprobante, cuenta, auxiliar1) 
);

create table cglcomprobante4
(
 compania char(2),
 num_comprobante char(10),
 cuenta char(24),
 auxiliar2 char(10) not null references cglauxiliares,
 monto decimal(10,2) not null,
 foreign key(compania, num_comprobante, cuenta) references cglcomprobante2,
 primary key (compania, num_comprobante, cuenta, auxiliar2) 
);

 
create table cglposteo
(
 consecutivo integer not null default autoincrement primary key,
 compania char(2) not null references gralcompanias,
 cuenta char(24) not null references cglcuentas,
 auxiliar_1 char(10) references cglauxiliares,
 auxiliar_2 char(10) references cglauxiliares,
 monto decimal(10,2) not null,
 comprobante char(10) not null,
 fecha_posteo date not null,
 concepto char(3) not null references cglconceptos,
 descripcion char(50) not null,
 usuario_capturo char(10) not null,
 usuario_actualizo char(10) not null,
 fecha_captura timestamp,
 fecha_actualiza timestamp,
 aplicacion_origen char(3) not null,
 referencia integer not null,
 estado char(1) not null
);

create table cglhistposteo
(
 consecutivo integer not null primary key,
 compania char(2) not null references gralcompanias,
 cuenta char(24) not null references cglcuentas,
 auxiliar_1 char(10) references cglauxiliares,
 auxiliar_2 char(10) references cglauxiliares,
 monto decimal(10,2) not null,
 comprobante char(10) not null,
 fecha_posteo date not null,
 concepto char(3) not null references cglconceptos,
 descripcion char(50) not null,
 usuario_capturo char(10) not null,
 usuario_actualizo char(10) not null,
 fecha_captura timestamp,
 fecha_actualiza timestamp,
 aplicacion_origen char(3) not null,
 referencia integer not null,
 estado char(1) not null
);
