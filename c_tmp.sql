drop table tmp_rela_factura1_cglposteo;
drop table tmp_rela_nomctrac_cglposteo;
drop table tmp_rela_cxctrx1_cglposteo;
drop table tmp_rela_cxcfact1_cglposteo; 
drop table tmp_rela_cxc_recibo1_cglposteo;
drop table tmp_rela_bcotransac1_cglposteo;
drop table tmp_rela_bcocheck1_cglposteo;
drop table tmp_rela_cxpajuste1_cglposteo;
drop table tmp_rela_cxpfact1_cglposteo;


create table tmp_rela_bcocheck1_cglposteo
as select * from rela_bcocheck1_cglposteo;

create table tmp_rela_bcotransac1_cglposteo
as select * from rela_bcotransac1_cglposteo;

create table tmp_rela_cxc_recibo1_cglposteo
as select * from rela_cxc_recibo1_cglposteo;

create table tmp_rela_cxcfact1_cglposteo 
as select * from rela_cxcfact1_cglposteo;

create table tmp_rela_cxctrx1_cglposteo
as select * from rela_cxctrx1_cglposteo;

create table tmp_rela_cxpajuste1_cglposteo
as select * from rela_cxpajuste1_cglposteo;

create table tmp_rela_cxpfact1_cglposteo
as select * from rela_cxpfact1_cglposteo;

create table tmp_rela_factura1_cglposteo
as select * from rela_factura1_cglposteo;

create table tmp_rela_nomctrac_cglposteo
as select * from rela_nomctrac_cglposteo;



