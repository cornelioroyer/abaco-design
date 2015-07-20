drop table tmp_factmotivos;

create table tmp_factmotivos  (
   tipo                 char(3)                        not null,
   descripcion          char(30)                       not null,
   factura              char(1)                        not null,
   cotizacion           char(1)                        not null,
   nota_credito         char(1)                        not null,
   devolucion           char(1)                        not null,
   signo                int4                           not null,
   tipo_comp            char(3)                        not null
)
;

insert into tmp_factmotivos (tipo, descripcion, factura, cotizacion, nota_credito, devolucion, signo, tipo_comp)
select tipo, descripcion, factura, cotizacion, nota_credito, devolucion, signo, tipo_comp
from factmotivos

drop table factmotivos;

create table factmotivos  (
   tipo                 char(3)                        not null,
   descripcion          char(30)                       not null,
   factura              char(1)                        not null  
         check (factura in ('S','N')),
   cotizacion           char(1)                        not null  
         check (cotizacion in ('S','N')),
   nota_credito         char(1)                        not null  
         check (nota_credito in ('S','N')),
   devolucion           char(1)                        not null  
         check (devolucion in ('S','N')),
   signo                int4                           not null  
         check (signo in (1,-1)),
   tipo_comp            char(3)                        not null,
   motivo               char(2),
   primary key (tipo)
)
;

insert into factmotivos (tipo, descripcion, factura, cotizacion, nota_credito, devolucion, signo, tipo_comp)
select tipo, descripcion, factura, cotizacion, nota_credito, devolucion, signo, tipo_comp
from tmp_factmotivos

drop table tmp_factmotivos;

alter table factmotivos
   add constraint FK_REFERENCE_387_INVMOTIVOS foreign key (motivo)
      references invmotivos (motivo)
 on update restrict
 on delete restrict;

alter table factmotivos
   add constraint FK_REF_152276_CGLTIPOCOMP foreign key (tipo_comp)
      references cgltipocomp (tipo_comp)
 on update restrict
 on delete restrict;

