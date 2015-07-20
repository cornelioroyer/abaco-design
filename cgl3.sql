drop table cglsctas_anual;
drop table cglsctas_mensual;
drop table cglsaux1_anual;
drop table cglsaux1_mensual;
drop table cglsaux2_anual;
drop table cglsaux2_mensual;

create table cglsctas_anual
(
 compania char(2) not null references gralcompanias,
 cuenta char(24) not null references cglcuentas,
 year smallint not null,
 saldo_inicial decimal(10,2) not null,
 primary key  (compania, cuenta, year)
);


create table cglsctas_mensual
(
 compania char(2),
 cuenta char(24),
 year smallint,
 mes smallint not null,
 debito decimal(10,2) not null,
 credito decimal(10,2) not null,
 balance decimal(10,2) not null,
 foreign key (compania, cuenta, year) references cglsctas_anual,
 primary key (compania, cuenta, year, mes)
);


create table cglsaux1_anual
(
 compania char(2) not null references gralcompanias,
 cuenta char(24) not null references cglcuentas,
 auxiliar char(10) not null references cglauxiliares,
 year smallint not null,
 saldo_inicial decimal(10,2) not null,
 primary key  (compania, cuenta, auxiliar, year)
);


create table cglsaux1_mensual
(
 compania char(2),
 cuenta char(24),
 auxiliar char(10),
 year smallint,
 mes smallint not null,
 debito decimal(10,2) not null,
 credito decimal(10,2) not null,
 balance decimal(10,2) not null,
 foreign key (compania, cuenta, auxiliar, year) references cglsaux1_anual,
 primary key (compania, cuenta, auxiliar, year, mes)
);


create table cglsaux2_anual
(
 compania char(2) not null references gralcompanias,
 cuenta char(24) not null references cglcuentas,
 auxiliar char(10) not null references cglauxiliares,
 year smallint not null,
 saldo_inicial decimal(10,2) not null,
 primary key  (compania, cuenta, auxiliar, year)
);


create table cglsaux2_mensual
(
 compania char(2),
 cuenta char(24),
 auxiliar char(10),
 year smallint,
 mes smallint not null,
 debito decimal(10,2) not null,
 credito decimal(10,2) not null,
 balance decimal(10,2) not null,
 foreign key (compania, cuenta, auxiliar, year) references cglsaux2_anual,
 primary key (compania, cuenta, auxiliar, year, mes)
);

