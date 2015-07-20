begin work;
delete from cglposteo;
commit work;

begin work;
delete from nomctrac;
commit work;

begin work;
delete from pla_saldo_acreedores;
delete from nom_ajuste_pagos_acreedores;
delete from nomdescuentos;
delete from nomdedu;
delete from nomacrem;
commit work;

begin work;
delete from cglsldocuenta;
delete from cglsldoaux1;
delete from cglsldoaux2;
delete from cglcomprobante1;
commit work;


begin work;
delete from cxpbalance;
delete from cxpfact1;
delete from cxpajuste1;
delete from cxpdocm;
commit work;


begin work;
delete from bcocircula;
delete from bcobalance;
delete from bcotransac1;
commit work;

begin work;
delete from bcocheck2;
delete from bcocheck3;
delete from bcocheck1;
commit work;


begin work;
delete from proveedores_agrupados;
delete from proveedores;
commit work;
