delete from inv_fisico1;
delete from tal_ot1;
delete from factura1;
delete from eys1;
delete from cxcdocm;
delete from cglsldocuenta where compania <> '02';
delete from cxp_saldos_iniciales where compania <> '02';
delete from gralperiodos where compania <> '02';
delete from adc_manifiesto where compania <> '02';
delete from cajas where compania <> '02';
delete from cgl_presupuesto where compania <> '02';
delete from cxpajuste1 where compania <> '02';
delete from pat where compania <> '02';
delete from bcoctas where compania <> '02';
delete from cglcomprobante1 where compania <> '02';
delete from gralparaxcia where compania <> '02';
delete from almacen where compania <> '02';
delete from cxpfact1 where compania <> '02';
delete from oc1 where compania <> '02';
delete from pat_listado where compania <> '02';
delete from comparacion_ventas where compania <> '02';
delete from cxpdocm where compania <> '02';
delete from periodos_depre where compania <> '02';
delete from activos where compania <> '02';
delete from cgl_comprobante1 where compania <> '02';
delete from cglperiodico1 where compania <> '02';
delete from cos_trx where compania <> '02';
delete from cxpmorosidad where compania <> '02';
delete from articulos_abc where compania <> '02';
delete from rhuempl where compania <> '02';
delete from fact_estadisticas;
delete from precios_por_cliente_1;
delete from listas_de_precio_2;
delete from oc1;
delete from tal_ot2;
delete from inv_fisico2;
delete from factura2;
delete from eys2;
delete from articulos_por_almacen;
delete from invbalance;
delete from cxpbalance;
delete from cxcbalance;
delete from cajas_balance;

delete from caja_trx1
where caja in (select caja from cajas where compania <> '02');
delete from cxpmorosidad;

delete from cajas where compania <> '02';

delete from cglposteo where compania <> '02';

delete from gralperiodos where compania <> '02';

delete from cxpbalance;
delete from cxcbalance where compania <> '02';

delete from afi_depreciacion where compania <> '02';


delete from gralparaxcia where compania <> '02';

delete from cxpdocm where compania <> '02';

delete from cxpfact1 where compania <> '02';


delete from cxpajuste1 where compania <> '02';

delete from cxp_saldos_iniciales where compania <> '02';

delete from cglsldocuenta
where compania <> '02';

delete from cgl_comprobante1
where compania <> '02';

delete from bcotransac1
where cod_ctabco in (select cod_ctabco from bcoctas where compania <> '02');

delete from bcocheck1
where cod_ctabco in (select cod_ctabco from bcoctas where compania <> '02');

delete from bcocircula
where cod_ctabco in (select cod_ctabco from bcoctas where compania <> '02');


delete from bcobalance;

delete from bcoctas
where compania <> '02';

delete from fac_parametros_contables where almacen <> '02';
delete from invparal where almacen <> '02';

delete from cxc_saldos_iniciales where almacen <> '02';

delete from cxc_recibo1
where almacen <> '02';

delete from cxctrx1
where almacen <> '02';


delete from almacen
where compania <> '02';

delete from activos
where compania <> '02';

delete from pla_riesgos_profesionales;

delete from pla_vacacion
where compania <> '02';

delete from rhuturno_x_dia
where compania <> '02';



delete from placertificadosmedico
where compania <> '02';

delete from nom_otros_ingresos
where compania <> '02';

delete from pla_resumen_planilla
where compania <> '02';

delete from nom_ajuste_pagos_acreedores
where compania <> '02';

delete from nomacrem
where compania <> '02';

delete from pla_preelaborada;

delete from nomhoras
where compania <> '02';

delete from nomhrtrab
where compania <> '02';

delete from nomctrac
where compania <> '02';

delete from rhuempl
where compania <> '02';

delete from gralcompanias
where compania <> '02';