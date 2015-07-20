drop table gralcompanias;
drop table gralperiodos;
drop table gralparametros;
drop table gralclavecia;

create table gralcompanias
(
  compania char(2) not null primary key,
  nombre char(30) not null,
  direccion char(30) not null,
  id_tributario char(20) not null
  );

create table gralclavecia
(
 compania char(2) not null references gralcompanias,
 clave char(10) not null,
 primary key (compania, clave)
);

create table gralparametros
(
  compania char(2) not null references gralcompanias,
  aplicacion char(3) not null,
  parametro char(20) not null,
  descripcion char(40) not null,
  valor char(20) not null,
  primary key (compania, aplicacion, parametro)
);

create table gralperiodos
(
  aplicacion char(3) not null,
  year smallint not null,
  mes smallint not null,
  inicio date not null,
  final date not null,
  estado char(1)  not null,
  primary key(aplicacion, year, mes),
  check (estado = 'A' or estado = 'I')
);

