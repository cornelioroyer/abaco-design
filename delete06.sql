delete from rela_eys1_cglposteo;
delete from rela_cxpfact1_cglposteo;
delete from rela_cxpajuste1_cglposteo;
delete from rela_cxctrx1_cglposteo;
delete from rela_cxcfact1_cglposteo;
delete from rela_bcocheck1_cglposteo;
delete from rela_bcotransac1_cglposteo;
delete from bcocheck1;
delete from bcotransac1;
delete from cglposteo where aplicacion_origen not in ('CGL');
delete from cglcomprobante1 where aplicacion_origen not in ('CGL');


