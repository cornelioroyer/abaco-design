rollback work;

delete from fac_cajeros;
delete from fac_cajas;
delete from rubros_fact_cxc;
delete from afi_tipo_activo;
delete from impuestos_por_grupo;
delete from impuestos_facturacion;
delete from imp_oc;
delete from otros_cargos;
delete from rubros_fact_cxp;
delete from gral_impuestos;
delete from cajas_balance;
delete from caja_trx1;
delete from cajas;
delete from pla_afectacion_contable;
delete from fac_parametros_contables;
delete from tal_servicios;
delete from listas_de_precio_2;
delete from listas_de_precio_1;
delete from invbalance;
delete from inv_fisico1;
delete from articulos_por_almacen;
delete from articulos;
delete from cglctasxaplicacion;
delete from cgl_financiero;
delete from cgl_comprobante1;
delete from cglsldocuenta;
delete from cglcuentas;
delete from bcobalance;
delete from bcoctas;
delete from bancos;


delete from afi_trx1;
delete from afi_depreciacion;
delete from activos;

begin work;
delete from eys1;
commit work;


delete from pla_extemporaneo;
delete from pla_carta_ayt;
delete from pla_constancias;
delete from nom_otros_ingresos;
delete from pla_vacacion;
delete from pla_riesgos_profesionales;
delete from nom_ajuste_pagos_acreedores;
delete from nomacrem;
delete from rhuturno_x_dia;
delete from placertificadosmedico;
delete from pla_preelaborada;
delete from nomhrtrab;
delete from rhuempl;


delete from cxp_saldos_iniciales;
delete from cxpmorosidad;

begin work;
delete from bcocircula;
delete from bcotransac1;
commit work;

begin work;
delete from nomctrac;
commit work;

begin work;
delete from bcocheck1;
commit work;

begin work;
delete from cxcdocm
where documento <> docmto_aplicar or motivo_cxc <> motivo_ref;
commit work;

begin work;
delete from oc2;
delete from tal_ot1;
commit work;

begin work;
delete from cxpdocm
where documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref;
commit work;

delete from cxpdocm;

begin work;
delete from cxpfact1;
delete from oc1;
commit work;

delete from cxpbalance;
delete from cxpfact2;
delete from cxpajuste1;
delete from proveedores;


delete from gralperiodos where compania <> '01';
delete from gralparaxcia where compania <> '01';
delete from invparal where almacen in (select almacen from almacen where compania <> '01');
delete from almacen where compania <> '01';
delete from gralcompanias where compania <> '01';
