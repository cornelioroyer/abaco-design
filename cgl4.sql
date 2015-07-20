drop table cglcomprobante1;
drop table cglcomprobante2;
drop table cglcomprobante3;
drop table cglcomprobante4;
drop table cglsecuencias;
drop table gralperiodos;

create table gralperiodos
(
  compania char(2) not null references gralcompanias,
  aplicacion char(3) not null,
  year char(4) not null,
  mes char(2) not null,
  descripcion char(20) not null,
  inicio date not null,
  final date not null,
  estado char(1)  not null,
  primary key(compania, aplicacion, year, mes),
  check (estado = 'A' or estado = 'I')
);



create table cglsecuencias
(
 compania char(2) not null,
 aplicacion char(3) not  null,
 year char(4) not null,
 mes char(2) not null,
 secuencia integer not null,
 foreign key(compania, aplicacion, year, mes) references gralperiodos,
 primary key(compania, aplicacion, year, mes) 
);

 
create table cglcomprobante1
(
 compania char(2) not null,
 aplicacion char(3) not null,
 year char(4) not null,
 mes char(2) not null,
 secuencia char(10) not null,
 aplicacion_origen char(3) not null references gralaplicaciones,
 concepto char(3) not null references cglconceptos,
 estado char(1) not null,
 usuario_captura char(10) not null,
 usuario_actualiza char(10) not null,
 fecha_comprobante date not null,
 fecha_captura timestamp,
 fecha_actualiza timestamp,
 descripcion char(50) not null,
 foreign key(compania, aplicacion, year, mes) references cglsecuencias,
 primary key(compania, aplicacion, year, mes, secuencia)
);

create table cglcomprobante2
(
 compania char(2) not null,
 aplicacion char(3) not null,
 year char(4) not null,
 mes char(2) not null,
 secuencia char(10) not null,
 cuenta char(24) references cglcuentas,
 monto decimal(10,2) not null,
 foreign key(compania, aplicacion, year, mes, secuencia) references cglcomprobante1,
 primary  key(compania, aplicacion, year, mes, secuencia, cuenta) 
);

create table cglcomprobante3
(
 compania char(2) not null,
 aplicacion char(3) not null,
 year char(4) not null,
 mes char(2) not null,
 secuencia char(10) not null,
 cuenta char(24) not null,
 auxiliar1 char(10) not null references cglauxiliares,
 monto decimal(10,2) not null,
 foreign key(compania, aplicacion, year, mes, secuencia, cuenta) references cglcomprobante2,
 primary key(compania, aplicacion, year, mes, secuencia, cuenta, auxiliar1)
);

create table cglcomprobante4
(
 compania char(2) not null,
 aplicacion char(3) not null,
 year char(4) not null,
 mes char(2) not null,
 secuencia char(10) not null,
 cuenta char(24) not null,
 auxiliar2 char(10) not null references cglauxiliares,
 monto decimal(10,2) not null,
 foreign key(compania, aplicacion, year, mes, secuencia, cuenta) references cglcomprobante2,
 primary key(compania, aplicacion, year, mes, secuencia, cuenta, auxiliar2)
);
 
