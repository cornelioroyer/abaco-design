if exists(select 1 from sys.systable where table_name='Activos' and table_type='BASE') then
    drop table Activos
end if;

if exists(select 1 from sys.systable where table_name='Almacen' and table_type='BASE') then
    drop table Almacen
end if;

if exists(select 1 from sys.systable where table_name='Articulos_Agrupados' and table_type='BASE') then
    drop table Articulos_Agrupados
end if;

if exists(select 1 from sys.systable where table_name='Cajas' and table_type='BASE') then
    drop table Cajas
end if;

if exists(select 1 from sys.systable where table_name='Departamentos' and table_type='BASE') then
    drop table Departamentos
end if;

if exists(select 1 from sys.systable where table_name='Encuesta' and table_type='BASE') then
    drop table Encuesta
end if;

if exists(select 1 from sys.systable where table_name='Listas_de_Precio_2' and table_type='BASE') then
    drop table Listas_de_Precio_2
end if;

if exists(select 1 from sys.systable where table_name='Marcas' and table_type='BASE') then
    drop table Marcas
end if;

if exists(select 1 from sys.systable where table_name='Otros_Cargos' and table_type='BASE') then
    drop table Otros_Cargos
end if;

if exists(select 1 from sys.systable where table_name='Precios_por_Cliente_1' and table_type='BASE') then
    drop table Precios_por_Cliente_1
end if;

if exists(select 1 from sys.systable where table_name='Precios_por_Cliente_2' and table_type='BASE') then
    drop table Precios_por_Cliente_2
end if;

if exists(select 1 from sys.systable where table_name='Proveedores' and table_type='BASE') then
    drop table Proveedores
end if;

if exists(select 1 from sys.systable where table_name='Proveedores_Agrupados' and table_type='BASE') then
    drop table Proveedores_Agrupados
end if;

if exists(select 1 from sys.systable where table_name='Secciones' and table_type='BASE') then
    drop table Secciones
end if;

if exists(select 1 from sys.systable where table_name='Status' and table_type='BASE') then
    drop table Status
end if;

if exists(select 1 from sys.systable where table_name='Unidad_Medida' and table_type='BASE') then
    drop table Unidad_Medida
end if;

if exists(select 1 from sys.systable where table_name='Vendedores' and table_type='BASE') then
    drop table Vendedores
end if;

if exists(select 1 from sys.systable where table_name='afi_depreciacion' and table_type='BASE') then
    drop table afi_depreciacion
end if;

if exists(select 1 from sys.systable where table_name='afi_grupos_1' and table_type='BASE') then
    drop table afi_grupos_1
end if;

if exists(select 1 from sys.systable where table_name='afi_grupos_2' and table_type='BASE') then
    drop table afi_grupos_2
end if;

if exists(select 1 from sys.systable where table_name='afi_tipo_activo' and table_type='BASE') then
    drop table afi_tipo_activo
end if;

if exists(select 1 from sys.systable where table_name='afi_tipo_trx' and table_type='BASE') then
    drop table afi_tipo_trx
end if;

if exists(select 1 from sys.systable where table_name='articulos' and table_type='BASE') then
    drop table articulos
end if;

if exists(select 1 from sys.systable where table_name='articulos_por_almacen' and table_type='BASE') then
    drop table articulos_por_almacen
end if;

if exists(select 1 from sys.systable where table_name='bancos' and table_type='BASE') then
    drop table bancos
end if;

if exists(select 1 from sys.systable where table_name='bcobalance' and table_type='BASE') then
    drop table bcobalance
end if;

if exists(select 1 from sys.systable where table_name='bcocheck1' and table_type='BASE') then
    drop table bcocheck1
end if;

if exists(select 1 from sys.systable where table_name='bcocheck2' and table_type='BASE') then
    drop table bcocheck2
end if;

if exists(select 1 from sys.systable where table_name='bcocheck3' and table_type='BASE') then
    drop table bcocheck3
end if;

if exists(select 1 from sys.systable where table_name='bcocircula' and table_type='BASE') then
    drop table bcocircula
end if;

if exists(select 1 from sys.systable where table_name='bcoctas' and table_type='BASE') then
    drop table bcoctas
end if;

if exists(select 1 from sys.systable where table_name='bcomotivos' and table_type='BASE') then
    drop table bcomotivos
end if;

if exists(select 1 from sys.systable where table_name='bcotransac1' and table_type='BASE') then
    drop table bcotransac1
end if;

if exists(select 1 from sys.systable where table_name='bcotransac2' and table_type='BASE') then
    drop table bcotransac2
end if;

if exists(select 1 from sys.systable where table_name='bcotransac3' and table_type='BASE') then
    drop table bcotransac3
end if;

if exists(select 1 from sys.systable where table_name='caja_tipo_trx' and table_type='BASE') then
    drop table caja_tipo_trx
end if;

if exists(select 1 from sys.systable where table_name='caja_trx1' and table_type='BASE') then
    drop table caja_trx1
end if;

if exists(select 1 from sys.systable where table_name='caja_trx2' and table_type='BASE') then
    drop table caja_trx2
end if;

if exists(select 1 from sys.systable where table_name='cajas_balance' and table_type='BASE') then
    drop table cajas_balance
end if;

if exists(select 1 from sys.systable where table_name='cantidad_de_empleados' and table_type='BASE') then
    drop table cantidad_de_empleados
end if;

if exists(select 1 from sys.systable where table_name='cglauxiliares' and table_type='BASE') then
    drop table cglauxiliares
end if;

if exists(select 1 from sys.systable where table_name='cglauxxaplicacion' and table_type='BASE') then
    drop table cglauxxaplicacion
end if;

if exists(select 1 from sys.systable where table_name='cglcomprobante1' and table_type='BASE') then
    drop table cglcomprobante1
end if;

if exists(select 1 from sys.systable where table_name='cglcomprobante2' and table_type='BASE') then
    drop table cglcomprobante2
end if;

if exists(select 1 from sys.systable where table_name='cglcomprobante3' and table_type='BASE') then
    drop table cglcomprobante3
end if;

if exists(select 1 from sys.systable where table_name='cglcomprobante4' and table_type='BASE') then
    drop table cglcomprobante4
end if;

if exists(select 1 from sys.systable where table_name='cglctasxaplicacion' and table_type='BASE') then
    drop table cglctasxaplicacion
end if;

if exists(select 1 from sys.systable where table_name='cglcuentas' and table_type='BASE') then
    drop table cglcuentas
end if;

if exists(select 1 from sys.systable where table_name='cglniveles' and table_type='BASE') then
    drop table cglniveles
end if;

if exists(select 1 from sys.systable where table_name='cglperiodico1' and table_type='BASE') then
    drop table cglperiodico1
end if;

if exists(select 1 from sys.systable where table_name='cglperiodico2' and table_type='BASE') then
    drop table cglperiodico2
end if;

if exists(select 1 from sys.systable where table_name='cglperiodico3' and table_type='BASE') then
    drop table cglperiodico3
end if;

if exists(select 1 from sys.systable where table_name='cglperiodico4' and table_type='BASE') then
    drop table cglperiodico4
end if;

if exists(select 1 from sys.sysindex I, sys.systable T
 where I.table_id=T.table_id and I.index_name='i_cglposteo_1' and T.table_name='cglposteo') then
   drop index cglposteo.i_cglposteo_1
end if;

if exists(select 1 from sys.systable where table_name='cglposteo' and table_type='BASE') then
    drop table cglposteo
end if;

if exists(select 1 from sys.systable where table_name='cglposteoaux1' and table_type='BASE') then
    drop table cglposteoaux1
end if;

if exists(select 1 from sys.systable where table_name='cglposteoaux2' and table_type='BASE') then
    drop table cglposteoaux2
end if;

if exists(select 1 from sys.systable where table_name='cglrecurrente' and table_type='BASE') then
    drop table cglrecurrente
end if;

if exists(select 1 from sys.systable where table_name='cglsldoaux1' and table_type='BASE') then
    drop table cglsldoaux1
end if;

if exists(select 1 from sys.systable where table_name='cglsldoaux2' and table_type='BASE') then
    drop table cglsldoaux2
end if;

if exists(select 1 from sys.systable where table_name='cglsldocuenta' and table_type='BASE') then
    drop table cglsldocuenta
end if;

if exists(select 1 from sys.systable where table_name='cgltipocomp' and table_type='BASE') then
    drop table cgltipocomp
end if;

if exists(select 1 from sys.systable where table_name='clientes' and table_type='BASE') then
    drop table clientes
end if;

if exists(select 1 from sys.systable where table_name='clientes_agrupados' and table_type='BASE') then
    drop table clientes_agrupados
end if;

if exists(select 1 from sys.systable where table_name='convmedi' and table_type='BASE') then
    drop table convmedi
end if;

if exists(select 1 from sys.systable where table_name='cxcbalance' and table_type='BASE') then
    drop table cxcbalance
end if;

if exists(select 1 from sys.systable where table_name='cxcdocm' and table_type='BASE') then
    drop table cxcdocm
end if;

if exists(select 1 from sys.systable where table_name='cxcfact1' and table_type='BASE') then
    drop table cxcfact1
end if;

if exists(select 1 from sys.systable where table_name='cxcfact2' and table_type='BASE') then
    drop table cxcfact2
end if;

if exists(select 1 from sys.systable where table_name='cxcfact3' and table_type='BASE') then
    drop table cxcfact3
end if;

if exists(select 1 from sys.systable where table_name='cxcmorosidad' and table_type='BASE') then
    drop table cxcmorosidad
end if;

if exists(select 1 from sys.systable where table_name='cxcmotivos' and table_type='BASE') then
    drop table cxcmotivos
end if;

if exists(select 1 from sys.systable where table_name='cxcrecibo1' and table_type='BASE') then
    drop table cxcrecibo1
end if;

if exists(select 1 from sys.systable where table_name='cxcrecibo2' and table_type='BASE') then
    drop table cxcrecibo2
end if;

if exists(select 1 from sys.systable where table_name='cxctrx1' and table_type='BASE') then
    drop table cxctrx1
end if;

if exists(select 1 from sys.systable where table_name='cxctrx2' and table_type='BASE') then
    drop table cxctrx2
end if;

if exists(select 1 from sys.systable where table_name='cxctrx3' and table_type='BASE') then
    drop table cxctrx3
end if;

if exists(select 1 from sys.systable where table_name='cxpajuste1' and table_type='BASE') then
    drop table cxpajuste1
end if;

if exists(select 1 from sys.systable where table_name='cxpajuste2' and table_type='BASE') then
    drop table cxpajuste2
end if;

if exists(select 1 from sys.systable where table_name='cxpajuste3' and table_type='BASE') then
    drop table cxpajuste3
end if;

if exists(select 1 from sys.systable where table_name='cxpbalance' and table_type='BASE') then
    drop table cxpbalance
end if;

if exists(select 1 from sys.systable where table_name='cxpdocm' and table_type='BASE') then
    drop table cxpdocm
end if;

if exists(select 1 from sys.systable where table_name='cxpfact1' and table_type='BASE') then
    drop table cxpfact1
end if;

if exists(select 1 from sys.systable where table_name='cxpfact2' and table_type='BASE') then
    drop table cxpfact2
end if;

if exists(select 1 from sys.systable where table_name='cxpfact3' and table_type='BASE') then
    drop table cxpfact3
end if;

if exists(select 1 from sys.systable where table_name='cxpmorosidad' and table_type='BASE') then
    drop table cxpmorosidad
end if;

if exists(select 1 from sys.systable where table_name='cxpmotivos' and table_type='BASE') then
    drop table cxpmotivos
end if;

if exists(select 1 from sys.systable where table_name='descuentos' and table_type='BASE') then
    drop table descuentos
end if;

if exists(select 1 from sys.systable where table_name='descuentos_por_articulo' and table_type='BASE') then
    drop table descuentos_por_articulo
end if;

if exists(select 1 from sys.systable where table_name='descuentos_por_cliente' and table_type='BASE') then
    drop table descuentos_por_cliente
end if;

if exists(select 1 from sys.systable where table_name='descuentos_por_grupo' and table_type='BASE') then
    drop table descuentos_por_grupo
end if;

if exists(select 1 from sys.systable where table_name='empleados' and table_type='BASE') then
    drop table empleados
end if;

if exists(select 1 from sys.systable where table_name='eys1' and table_type='BASE') then
    drop table eys1
end if;

if exists(select 1 from sys.systable where table_name='eys2' and table_type='BASE') then
    drop table eys2
end if;

if exists(select 1 from sys.systable where table_name='eys3' and table_type='BASE') then
    drop table eys3
end if;

if exists(select 1 from sys.systable where table_name='eys4' and table_type='BASE') then
    drop table eys4
end if;

if exists(select 1 from sys.systable where table_name='facparamcgl' and table_type='BASE') then
    drop table facparamcgl
end if;

if exists(select 1 from sys.systable where table_name='fact_autoriza_descto' and table_type='BASE') then
    drop table fact_autoriza_descto
end if;

if exists(select 1 from sys.systable where table_name='factmotivos' and table_type='BASE') then
    drop table factmotivos
end if;

if exists(select 1 from sys.systable where table_name='factsobregiro' and table_type='BASE') then
    drop table factsobregiro
end if;

if exists(select 1 from sys.systable where table_name='factura1' and table_type='BASE') then
    drop table factura1
end if;

if exists(select 1 from sys.systable where table_name='factura2' and table_type='BASE') then
    drop table factura2
end if;

if exists(select 1 from sys.systable where table_name='factura2_eys2' and table_type='BASE') then
    drop table factura2_eys2
end if;

if exists(select 1 from sys.systable where table_name='factura3' and table_type='BASE') then
    drop table factura3
end if;

if exists(select 1 from sys.systable where table_name='factura4' and table_type='BASE') then
    drop table factura4
end if;

if exists(select 1 from sys.systable where table_name='factura5' and table_type='BASE') then
    drop table factura5
end if;

if exists(select 1 from sys.systable where table_name='factura6' and table_type='BASE') then
    drop table factura6
end if;

if exists(select 1 from sys.systable where table_name='factura7' and table_type='BASE') then
    drop table factura7
end if;

if exists(select 1 from sys.sysindex I, sys.systable T
 where I.table_id=T.table_id and I.index_name='pb_company' and T.table_name='fax') then
   drop index fax.pb_company
end if;

if exists(select 1 from sys.systable where table_name='fax' and table_type='BASE') then
    drop table fax
end if;

if exists(select 1 from sys.systable where table_name='fisico1' and table_type='BASE') then
    drop table fisico1
end if;

if exists(select 1 from sys.systable where table_name='fisico2' and table_type='BASE') then
    drop table fisico2
end if;

if exists(select 1 from sys.systable where table_name='funcionarios_cliente' and table_type='BASE') then
    drop table funcionarios_cliente
end if;

if exists(select 1 from sys.systable where table_name='funcionarios_proveedor' and table_type='BASE') then
    drop table funcionarios_proveedor
end if;

if exists(select 1 from sys.systable where table_name='gral_forma_de_pago' and table_type='BASE') then
    drop table gral_forma_de_pago
end if;

if exists(select 1 from sys.systable where table_name='gral_grupos_aplicacion' and table_type='BASE') then
    drop table gral_grupos_aplicacion
end if;

if exists(select 1 from sys.systable where table_name='gral_impuestos' and table_type='BASE') then
    drop table gral_impuestos
end if;

if exists(select 1 from sys.systable where table_name='gral_valor_grupos' and table_type='BASE') then
    drop table gral_valor_grupos
end if;

if exists(select 1 from sys.systable where table_name='gralaplicaciones' and table_type='BASE') then
    drop table gralaplicaciones
end if;

if exists(select 1 from sys.systable where table_name='gralcompanias' and table_type='BASE') then
    drop table gralcompanias
end if;

if exists(select 1 from sys.systable where table_name='gralparametros' and table_type='BASE') then
    drop table gralparametros
end if;

if exists(select 1 from sys.systable where table_name='gralparaxapli' and table_type='BASE') then
    drop table gralparaxapli
end if;

if exists(select 1 from sys.systable where table_name='gralparaxcia' and table_type='BASE') then
    drop table gralparaxcia
end if;

if exists(select 1 from sys.systable where table_name='gralperiodos' and table_type='BASE') then
    drop table gralperiodos
end if;

if exists(select 1 from sys.systable where table_name='gralsecuencias' and table_type='BASE') then
    drop table gralsecuencias
end if;

if exists(select 1 from sys.systable where table_name='gralsecxcia' and table_type='BASE') then
    drop table gralsecxcia
end if;

if exists(select 1 from sys.systable where table_name='imp_oc' and table_type='BASE') then
    drop table imp_oc
end if;

if exists(select 1 from sys.systable where table_name='impuestos_facturacion' and table_type='BASE') then
    drop table impuestos_facturacion
end if;

if exists(select 1 from sys.systable where table_name='impuestos_por_grupo' and table_type='BASE') then
    drop table impuestos_por_grupo
end if;

if exists(select 1 from sys.systable where table_name='inconsistencias' and table_type='BASE') then
    drop table inconsistencias
end if;

if exists(select 1 from sys.systable where table_name='inv_conversion' and table_type='BASE') then
    drop table inv_conversion
end if;

if exists(select 1 from sys.systable where table_name='invbalance' and table_type='BASE') then
    drop table invbalance
end if;

if exists(select 1 from sys.systable where table_name='invmotivos' and table_type='BASE') then
    drop table invmotivos
end if;

if exists(select 1 from sys.systable where table_name='invparal' and table_type='BASE') then
    drop table invparal
end if;

if exists(select 1 from sys.systable where table_name='listas_de_precio_1' and table_type='BASE') then
    drop table listas_de_precio_1
end if;

if exists(select 1 from sys.systable where table_name='nom_conceptos_para_calculo' and table_type='BASE') then
    drop table nom_conceptos_para_calculo
end if;

if exists(select 1 from sys.systable where table_name='nom_otros_ingresos' and table_type='BASE') then
    drop table nom_otros_ingresos
end if;

if exists(select 1 from sys.systable where table_name='nom_tipo_de_calculo' and table_type='BASE') then
    drop table nom_tipo_de_calculo
end if;

if exists(select 1 from sys.systable where table_name='nomacrem' and table_type='BASE') then
    drop table nomacrem
end if;

if exists(select 1 from sys.systable where table_name='nomauta' and table_type='BASE') then
    drop table nomauta
end if;

if exists(select 1 from sys.systable where table_name='nomconce' and table_type='BASE') then
    drop table nomconce
end if;

if exists(select 1 from sys.systable where table_name='nomctrac' and table_type='BASE') then
    drop table nomctrac
end if;

if exists(select 1 from sys.systable where table_name='nomdedu' and table_type='BASE') then
    drop table nomdedu
end if;

if exists(select 1 from sys.systable where table_name='nomdescuentos' and table_type='BASE') then
    drop table nomdescuentos
end if;

if exists(select 1 from sys.systable where table_name='nomdfer' and table_type='BASE') then
    drop table nomdfer
end if;

if exists(select 1 from sys.systable where table_name='nomextras' and table_type='BASE') then
    drop table nomextras
end if;

if exists(select 1 from sys.systable where table_name='nomhrtrab' and table_type='BASE') then
    drop table nomhrtrab
end if;

if exists(select 1 from sys.systable where table_name='nomimrta' and table_type='BASE') then
    drop table nomimrta
end if;

if exists(select 1 from sys.systable where table_name='nomperiodos' and table_type='BASE') then
    drop table nomperiodos
end if;

if exists(select 1 from sys.systable where table_name='nomrecargos' and table_type='BASE') then
    drop table nomrecargos
end if;

if exists(select 1 from sys.systable where table_name='nomrelac' and table_type='BASE') then
    drop table nomrelac
end if;

if exists(select 1 from sys.systable where table_name='nomtpla' and table_type='BASE') then
    drop table nomtpla
end if;

if exists(select 1 from sys.systable where table_name='nomtpla2' and table_type='BASE') then
    drop table nomtpla2
end if;

if exists(select 1 from sys.systable where table_name='oc1' and table_type='BASE') then
    drop table oc1
end if;

if exists(select 1 from sys.systable where table_name='oc2' and table_type='BASE') then
    drop table oc2
end if;

if exists(select 1 from sys.systable where table_name='oc3' and table_type='BASE') then
    drop table oc3
end if;

if exists(select 1 from sys.systable where table_name='oc4' and table_type='BASE') then
    drop table oc4
end if;

if exists(select 1 from sys.systable where table_name='origen_del_sistema' and table_type='BASE') then
    drop table origen_del_sistema
end if;

if exists(select 1 from sys.systable where table_name='pbcatcol' and table_type='BASE') then
    drop table pbcatcol
end if;

if exists(select 1 from sys.systable where table_name='pbcatcol' and table_type='BASE') then
    drop table pbcatcol
end if;

if exists(select 1 from sys.systable where table_name='pbcatedt' and table_type='BASE') then
    drop table pbcatedt
end if;

if exists(select 1 from sys.systable where table_name='pbcatedt' and table_type='BASE') then
    drop table pbcatedt
end if;

if exists(select 1 from sys.systable where table_name='pbcatfmt' and table_type='BASE') then
    drop table pbcatfmt
end if;

if exists(select 1 from sys.systable where table_name='pbcatfmt' and table_type='BASE') then
    drop table pbcatfmt
end if;

if exists(select 1 from sys.systable where table_name='pbcattbl' and table_type='BASE') then
    drop table pbcattbl
end if;

if exists(select 1 from sys.systable where table_name='pbcattbl' and table_type='BASE') then
    drop table pbcattbl
end if;

if exists(select 1 from sys.systable where table_name='pbcatvld' and table_type='BASE') then
    drop table pbcatvld
end if;

if exists(select 1 from sys.systable where table_name='pbcatvld' and table_type='BASE') then
    drop table pbcatvld
end if;

if exists(select 1 from sys.systable where table_name='periodos_depre' and table_type='BASE') then
    drop table periodos_depre
end if;

if exists(select 1 from sys.systable where table_name='pla_informe' and table_type='BASE') then
    drop table pla_informe
end if;

if exists(select 1 from sys.systable where table_name='pla_vacacion1' and table_type='BASE') then
    drop table pla_vacacion1
end if;

if exists(select 1 from sys.systable where table_name='pla_vacacion2' and table_type='BASE') then
    drop table pla_vacacion2
end if;

if exists(select 1 from sys.systable where table_name='pla_xiii' and table_type='BASE') then
    drop table pla_xiii
end if;

if exists(select 1 from sys.systable where table_name='preventas' and table_type='BASE') then
    drop table preventas
end if;

if exists(select 1 from sys.systable where table_name='productos_sustitutos' and table_type='BASE') then
    drop table productos_sustitutos
end if;

if exists(select 1 from sys.systable where table_name='rela_afi_cglposteo' and table_type='BASE') then
    drop table rela_afi_cglposteo
end if;

if exists(select 1 from sys.systable where table_name='rela_bcocheck1_cglposteo' and table_type='BASE') then
    drop table rela_bcocheck1_cglposteo
end if;

if exists(select 1 from sys.systable where table_name='rela_bcotransac1_cglposteo' and table_type='BASE') then
    drop table rela_bcotransac1_cglposteo
end if;

if exists(select 1 from sys.systable where table_name='rela_caja_trx1_cglposteo' and table_type='BASE') then
    drop table rela_caja_trx1_cglposteo
end if;

if exists(select 1 from sys.systable where table_name='rela_cxcfact1_cglposteo' and table_type='BASE') then
    drop table rela_cxcfact1_cglposteo
end if;

if exists(select 1 from sys.systable where table_name='rela_cxctrx1_cglposteo' and table_type='BASE') then
    drop table rela_cxctrx1_cglposteo
end if;

if exists(select 1 from sys.systable where table_name='rela_cxpajuste1_cglposteo' and table_type='BASE') then
    drop table rela_cxpajuste1_cglposteo
end if;

if exists(select 1 from sys.systable where table_name='rela_cxpfact1_cglposteo' and table_type='BASE') then
    drop table rela_cxpfact1_cglposteo
end if;

if exists(select 1 from sys.systable where table_name='rela_eys1_cglposteo' and table_type='BASE') then
    drop table rela_eys1_cglposteo
end if;

if exists(select 1 from sys.systable where table_name='rela_factura1_cglposteo' and table_type='BASE') then
    drop table rela_factura1_cglposteo
end if;

if exists(select 1 from sys.systable where table_name='rhuacre' and table_type='BASE') then
    drop table rhuacre
end if;

if exists(select 1 from sys.systable where table_name='rhuacre2' and table_type='BASE') then
    drop table rhuacre2
end if;

if exists(select 1 from sys.systable where table_name='rhucargo' and table_type='BASE') then
    drop table rhucargo
end if;

if exists(select 1 from sys.systable where table_name='rhuclvim' and table_type='BASE') then
    drop table rhuclvim
end if;

if exists(select 1 from sys.systable where table_name='rhudirec' and table_type='BASE') then
    drop table rhudirec
end if;

if exists(select 1 from sys.systable where table_name='rhuempl' and table_type='BASE') then
    drop table rhuempl
end if;

if exists(select 1 from sys.systable where table_name='rhugremp' and table_type='BASE') then
    drop table rhugremp
end if;

if exists(select 1 from sys.systable where table_name='rhuturno' and table_type='BASE') then
    drop table rhuturno
end if;

if exists(select 1 from sys.systable where table_name='rs_lastcommit' and table_type='BASE') then
    drop table rs_lastcommit
end if;

if exists(select 1 from sys.systable where table_name='rs_threads' and table_type='BASE') then
    drop table rs_threads
end if;

if exists(select 1 from sys.systable where table_name='rubros_fact_cxc' and table_type='BASE') then
    drop table rubros_fact_cxc
end if;

if exists(select 1 from sys.systable where table_name='rubros_fact_cxp' and table_type='BASE') then
    drop table rubros_fact_cxp
end if;

if exists(select 1 from sys.systable where table_name='saldo_de_proveedores' and table_type='BASE') then
    drop table saldo_de_proveedores
end if;

if exists(select 1 from sys.systable where table_name='tipo_de_empresa' and table_type='BASE') then
    drop table tipo_de_empresa
end if;

if exists(select 1 from sys.systable where table_name='tipo_transacc' and table_type='BASE') then
    drop table tipo_transacc
end if;

if exists(select 1 from sys.systable where table_name='tipoauto' and table_type='BASE') then
    drop table tipoauto
end if;

if exists(select 1 from sys.systable where table_name='tipoauto3' and table_type='BASE') then
    drop table tipoauto3
end if;

if exists(select 1 from sys.systable where table_name='tipocont' and table_type='BASE') then
    drop table tipocont
end if;

if exists(select 1 from sys.systable where table_name='tipos_seguros' and table_type='BASE') then
    drop table tipos_seguros
end if;

if exists(select 1 from sys.systable where table_name='trabajo' and table_type='BASE') then
    drop table trabajo
end if;

create table Activos 
(
    codigo               char(15)                       not null,
    descripcion          char(40)                       not null,
    descripcion_larga    long varchar,
    marca                char(5),
    status               char                           not null,
    grupo                char(5)                        not null,
    costo_inicial        decimal(10,2)                  not null,
    fecha_compra         date                           not null,
    fecha_inicio         date                           not null,
    vencimiento_garantia date,
    valor_rescate        decimal(10,2)                  not null,
    activo_nuevo         char                           not null,
    departamento         char(3),
    seccion              char(3),
    tipo_activo          char(3)                        not null,
    compania             char(2)                        not null,
    Act_codigo           char(15)                       not null,
    primary key (codigo, compania)
);

create table Almacen 
(
    almacen              char(2)                        not null,
    compania             char(2)                        not null,
    desc_almacen         char(40)                       not null,
    direccion1_almacen   char(40)                       not null,
    direccion2_almacen   char(40),
    telefono_almacen     char(15),
    fax_almacen          char(15),
    primary key (almacen)
);

create table Articulos_Agrupados 
(
    Articulo             char(15)                       not null,
    codigo_valor_grupo   char(3)                        not null,
    primary key (Articulo, codigo_valor_grupo)
);

create table Cajas 
(
    caja                 char(3)                        not null,
    cuenta               char(24)                       not null,
    compania             char(2)                        not null,
    auxiliar_1           char(10),
    auxiliar_2           char(10),
    a_nombre             char(50)                       not null,
    responsable          char(50)                       not null,
    secuencial           integer                        not null,
    minimo               decimal(10,2)                  not null,
    usuario_responsable  char(10)                       not null,
    primary key (caja)
);

create table Departamentos 
(
    codigo               char(3)                        not null,
    descripcion          char(50)                       not null,
    primary key (codigo)
);

create table Encuesta 
(
    tipo_empresa         char(2)                        not null,
    empresa              char(40)                       not null,
    Codigo_de_Rango      char(2)                        not null,
    Codigo_de_Origen     char                           not null,
    tiene_sistema        char                           not null,
    cgl                  char                           not null,
    bco                  char                           not null,
    sch                  char                           not null,
    cjm                  char                           not null,
    com                  char                           not null,
    inv                  char                           not null,
    cxp                  char                           not null,
    fac                  char                           not null,
    cxc                  char                           not null,
    afi                  char                           not null,
    pre                  char                           not null,
    pla                  char                           not null,
    satisfaccion         integer                        not null,
    evaluar_aplicacion   char                           not null,
    conoce_empresa       char                           not null,
    recibio_ofertas      char                           not null,
    compraria            char                           not null,
    internet             char                           not null,
    primary key (empresa)
);

comment on table Encuesta is 'Encuesta';

comment on column Encuesta.tipo_empresa is 'tipo_empresa';

comment on column Encuesta.empresa is 'empresa';

comment on column Encuesta.Codigo_de_Rango is 'Codigo de Rango';

comment on column Encuesta.Codigo_de_Origen is 'Codigo de Origen';

comment on column Encuesta.tiene_sistema is 'tiene sistema';

comment on column Encuesta.cgl is 'cgl';

comment on column Encuesta.bco is 'bco';

comment on column Encuesta.sch is 'sch';

comment on column Encuesta.cjm is 'cjm';

comment on column Encuesta.com is 'com';

comment on column Encuesta.inv is 'inv';

comment on column Encuesta.cxp is 'cxp';

comment on column Encuesta.fac is 'fac';

comment on column Encuesta.cxc is 'cxc';

comment on column Encuesta.afi is 'afi';

comment on column Encuesta.pre is 'pre';

comment on column Encuesta.pla is 'pla';

comment on column Encuesta.satisfaccion is 'satisfaccion';

comment on column Encuesta.evaluar_aplicacion is 'evaluar aplicacion';

comment on column Encuesta.conoce_empresa is 'conoce empresa';

comment on column Encuesta.recibio_ofertas is 'recibio ofertas';

comment on column Encuesta.compraria is 'compraria';

create table Listas_de_Precio_2 
(
    secuencia            integer                        not null,
    Articulo             char(15)                       not null,
    almacen              char(2)                        not null,
    precio               decimal(10,2)                  not null,
    primary key (secuencia, Articulo, almacen)
);

create table Marcas 
(
    codigo               char(5)                        not null,
    descripcion          char(50)                       not null,
    primary key (codigo)
);

create table Otros_Cargos 
(
    tipo_de_cargo        char(2)                        not null,
    rubro_fact_cxp       char(15)                       not null,
    desc_cargo           char(40)                       not null,
    status               char                           not null,
    primary key (tipo_de_cargo)
);

create table Precios_por_Cliente_1 
(
    secuencia            integer                        not null,
    cliente              char(6)                        not null,
    cantidad_desde       decimal(10,2)                  not null,
    cantidad_hasta       decimal(10,2)                  not null,
    fecha_desde          date                           not null,
    fecha_hasta          date                           not null,
    status               char                           not null,
    usuario_captura      char(10)                       not null,
    fecha_captura        timestamp                      not null,
    primary key (secuencia)
);

create table Precios_por_Cliente_2 
(
    secuencia            integer                        not null,
    Articulo             char(15)                       not null,
    almacen              char(2)                        not null,
    precio               decimal(10,2)                  not null,
    primary key (secuencia, Articulo, almacen)
);

create table Proveedores 
(
    proveedor            char(6)                        not null,
    forma_pago           char(2)                        not null,
    cuenta               char(24)                       not null,
    nomb_proveedor       char(40)                       not null,
    mail_proveedor       char(40),
    tel1_proveedor       char(15)                       not null,
    tel2_proveedor       char(15),
    fax_proveedor        char(15),
    id_proveedor         char(20),
    dv_proveedor         char(5),
    status               char                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    limite_credito       decimal(10,2)                  not null,
    fecha_apertura       timestamp                      not null,
    fecha_cierre         date,
    direccion1           char(50)                       not null,
    direccion2           char(50),
    direccion3           char(50),
    primary key (proveedor)
);

create table Proveedores_Agrupados 
(
    proveedor            char(6)                        not null,
    codigo_valor_grupo   char(3)                        not null,
    primary key (proveedor, codigo_valor_grupo)
);

create table Secciones 
(
    codigo               char(3)                        not null,
    seccion              char(3)                        not null,
    descripcion          char(50)                       not null,
    primary key (codigo, seccion)
);

create table Status 
(
    tabla                char(30)                       not null,
    status               char                           not null,
    descripcion          char(25)                       not null,
    primary key (tabla, status)
);

create table Unidad_Medida 
(
    unidad_medida        char(10)                       not null,
    primary key (unidad_medida)
);

create table Vendedores 
(
    codigo               char(5)                        not null,
    nombre               char(50)                       not null,
    usuario              char(10)                       not null,
    primary key (codigo)
);

create table afi_depreciacion 
(
    codigo               char(15)                       not null,
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    depreciacion         decimal(10,2)                  not null,
    status               char                           not null,
    primary key (codigo, compania, aplicacion, year, periodo)
);

create table afi_grupos_1 
(
    codigo               char(5)                        not null,
    descripcion          char(60)                       not null,
    primary key (codigo)
);

create table afi_grupos_2 
(
    codigo               char(5)                        not null,
    year                 integer                        not null,
    depreciacion         decimal(10,2)                  not null,
    primary key (codigo, year)
);

create table afi_tipo_activo 
(
    codigo               char(3)                        not null,
    tipo_comp            char(3)                        not null,
    cuenta_activo        char(24)                       not null,
    cuenta_depreciacion  char(24)                       not null,
    cuenta_gasto         char(24)                       not null,
    descripcion          char(50)                       not null,
    primary key (codigo)
);

create table afi_tipo_trx 
(
    tipo_trx             char(3)                        not null,
    tipo_comp            char(3),
    descripcion          char(40)                       not null,
    primary key (tipo_trx)
);

create table articulos 
(
    articulo             char(15)                       not null,
    unidad_medida        char(10)                       not null,
    desc_articulo        char(40)                       not null,
    categoria_abc        char,
    status_articulo      char                           not null,
    desc_larga           char(200),
    servicio             char                           not null
          check (servicio in ('S','N')),
    numero_parte         char(20),
    numero_serie         char(20),
    codigo_barra         char(20),
    primary key (articulo)
);

create table articulos_por_almacen 
(
    Articulo             char(15)                       not null,
    almacen              char(2)                        not null,
    cuenta               char(24)                       not null,
    precio_venta         decimal(10,2)                  not null,
    minimo               decimal(10,2)                  not null,
    maximo               decimal(10,2)                  not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    primary key (Articulo, almacen)
);

create table bancos 
(
    banco                char(3)                        not null,
    nomb_banco           char(40)                       not null,
    siglas_banco         char(5)                        not null,
    nomb_oficial1        char(40)                       not null,
    nomb_oficial2        char(40),
    nomb_gerente         char(40),
    telefono1_banco      char(15)                       not null,
    telefono2_banco      char(15),
    fax_banco            char(15)                       not null,
    direc1_banco         char(40)                       not null,
    direc2_banco         char(40)                       not null,
    direc3_banco         char(40)                       not null,
    status               char                           not null,
    obs_banco            long varchar,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    pagina_web           char(30),
    mail                 char(30),
    primary key (banco)
);

create table bcobalance 
(
    cod_ctabco           char(2)                        not null,
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    balance_inicial      decimal(10,2)                  not null,
    cheques              decimal(10,2)                  not null,
    debe                 decimal(10,2)                  not null,
    haber                decimal(10,2)                  not null,
    primary key (cod_ctabco, compania, aplicacion, year, periodo)
);

create table bcocheck1 
(
    cod_ctabco           char(2)                        not null,
    no_solicitud         integer                        not null,
    no_cheque            integer                        not null,
    proveedor            char(6),
    motivo_bco           char(2)                        not null,
    paguese_a            char(60)                       not null,
    fecha_solicitud      date                           not null,
    fecha_cheque         date                           not null,
    fecha_posteo         date                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    docmto_fuente        char(10)                       not null,
    en_concepto_de       long varchar,
    status               char                           not null,
    monto                decimal(10,2)                  not null,
    primary key (cod_ctabco, no_cheque, motivo_bco)
);

create table bcocheck2 
(
    linea                integer                        not null,
    cuenta               char(24)                       not null,
    cod_ctabco           char(2)                        not null,
    no_cheque            integer                        not null,
    auxiliar1            char(10),
    auxiliar2            char(10),
    motivo_bco           char(2)                        not null,
    monto                decimal(10,2)                  not null,
    primary key (linea, cod_ctabco, no_cheque, motivo_bco)
);

create table bcocheck3 
(
    motivo_cxp           char(3)                        not null,
    cod_ctabco           char(2)                        not null,
    no_cheque            integer                        not null,
    aplicar_a            char(10)                       not null,
    motivo_bco           char(2)                        not null,
    monto                decimal(10,2)                  not null,
    primary key (motivo_cxp, cod_ctabco, no_cheque, aplicar_a, motivo_bco)
);

create table bcocircula 
(
    sec_docmto_circula   integer                        not null,
    cod_ctabco           char(2)                        not null,
    motivo_bco           char(2)                        not null,
    proveedor            char(6),
    no_docmto_sys        integer                        not null,
    no_docmto_fuente     char(10)                       not null,
    fecha_transacc       date                           not null,
    fecha_posteo         date                           not null,
    status               char                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    a_nombre             char(60),
    desc_documento       long varchar,
    monto                decimal(10,2)                  not null,
    primary key (sec_docmto_circula)
);

create table bcoctas 
(
    banco                char(3)                        not null,
    cod_ctabco           char(2)                        not null,
    cuenta               char(24)                       not null,
    compania             char(2)                        not null,
    auxiliar1            char(10),
    auxiliar2            char(10),
    desc_ctabco          char(40)                       not null,
    no_ctabco            char(30)                       not null,
    sobregiro_autorizado float                          not null,
    status               char                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    sec_cheque           integer                        not null default 0
          check (sec_cheque>=0),
    sec_solicitud        integer                        not null default 0
          check (sec_solicitud>=0),
    sec_transac          integer                        not null default 0
          check (sec_transac>=0),
    primary key (cod_ctabco)
);

create table bcomotivos 
(
    motivo_bco           char(2)                        not null,
    desc_motivo_bco      char(40)                       not null,
    signo                integer                        not null
          check (signo in (1,-1)),
    aplica_cheques       char                           not null
          check (aplica_cheques in ('S','N')),
    aplica_transacc      char                           not null
          check (aplica_transacc in ('S','N')),
    solicitud_cheque     char                           not null
          check (solicitud_cheque in ('S','N')),
    tipo_comp            char(3)                        not null,
    primary key (motivo_bco)
);

create table bcotransac1 
(
    cod_ctabco           char(2)                        not null,
    sec_transacc         integer                        not null,
    motivo_bco           char(2)                        not null,
    proveedor            char(6),
    fecha_transacc       date                           not null,
    fecha_posteo         date                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    obs_transac_bco      long varchar,
    status               char                           not null,
    monto                decimal(10,2)                  not null,
    no_docmto            char(10)                       not null,
    primary key (cod_ctabco, sec_transacc)
);

create table bcotransac2 
(
    sec_transacc         integer                        not null,
    line                 integer                        not null,
    cuenta               char(24)                       not null,
    auxiliar1            char(10),
    auxiliar2            char(10),
    cod_ctabco           char(2)                        not null,
    monto                decimal(10,2)                  not null,
    primary key (sec_transacc, line, cod_ctabco)
);

create table bcotransac3 
(
    sec_transacc         integer                        not null,
    aplicar_a            char(10)                       not null,
    motivo_cxp           char(3)                        not null,
    cod_ctabco           char(2)                        not null,
    monto                decimal(10,2)                  not null,
    primary key (sec_transacc, aplicar_a, motivo_cxp, cod_ctabco)
);

create table caja_tipo_trx 
(
    tipo_trx             char(2)                        not null,
    tipo_comp            char(3)                        not null,
    descripcion          char(30)                       not null,
    signo                integer                        not null
          check (signo in (1,-1)),
    primary key (tipo_trx)
);

create table caja_trx1 
(
    numero_trx           integer                        not null,
    caja                 char(3)                        not null,
    tipo_trx             char(2)                        not null,
    concepto             long varchar                   not null,
    fecha_trx            date                           not null,
    fecha_posteo         date                           not null,
    usuario_captura      char(10)                       not null,
    usuario_actualiza    char(10)                       not null,
    fecha_captura        timestamp                      not null,
    fecha_actualiza      timestamp                      not null,
    status               char                           not null,
    monto                decimal(10,2)                  not null,
    primary key (numero_trx, caja)
);

create table caja_trx2 
(
    numero_trx           integer                        not null,
    caja                 char(3)                        not null,
    linea                integer                        not null,
    auxiliar_1           char(10),
    auxiliar_2           char(10),
    cuenta               char(24)                       not null,
    monto                decimal(10,2)                  not null,
    primary key (numero_trx, caja, linea)
);

create table cajas_balance 
(
    caja                 char(3)                        not null,
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    balance_inicial      decimal(10,2)                  not null,
    debe                 decimal(10,2)                  not null,
    haber                float                          not null,
    primary key (caja, compania, aplicacion, year, periodo)
);

create table cantidad_de_empleados 
(
    codigo_de_rango      char(2)                        not null,
    descripcion          char(40)                       not null,
    primary key (codigo_de_rango)
);

comment on table cantidad_de_empleados is 'Cantidad de Empleados';

comment on column cantidad_de_empleados.codigo_de_rango is 'Codigo de Rango';

comment on column cantidad_de_empleados.descripcion is 'Descripción';

create table cglauxiliares 
(
    auxiliar             char(10)                       not null,
    nombre               char(30)                       not null,
    primary key (auxiliar)
);

create table cglauxxaplicacion 
(
    auxiliar             char(10)                       not null,
    aplicacion           char(3)                        not null,
    status               char                           not null
          check (status in ('A','I')),
    primary key (auxiliar, aplicacion)
);

create table cglcomprobante1 
(
    secuencia            integer                        not null,
    aplicacion_origen    char(3)                        not null,
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    tipo_comp            char(3)                        not null,
    estado               char                           not null,
    usuario_captura      char(10)                       not null,
    usuario_actualiza    char(10)                       not null,
    fecha_comprobante    date                           not null,
    fecha_captura        timestamp,
    fecha_actualiza      timestamp,
    primary key (secuencia, compania, aplicacion, year, periodo)
);

create table cglcomprobante2 
(
    linea                integer                        not null,
    cuenta               char(24)                       not null,
    descripcion          char(50)                       not null,
    secuencia            integer                        not null,
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    debito               decimal(10,2)                  not null
          check (debito>=0),
    credito              decimal(10,2)                  not null
          check (credito>=0),
    primary key (linea, secuencia, compania, aplicacion, year, periodo)
);

create table cglcomprobante3 
(
    linea                integer                        not null,
    linea_aux1           integer                        not null,
    secuencia            integer                        not null,
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    auxiliar             char(10)                       not null,
    debito               decimal(10,2)                  not null
          check (debito>=0),
    credito              decimal(10,2)                  not null
          check (credito>=0),
    primary key (linea, linea_aux1, secuencia, compania, aplicacion, year, periodo)
);

create table cglcomprobante4 
(
    linea_aux2           integer                        not null,
    linea                integer                        not null,
    secuencia            integer                        not null,
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    auxiliar             char(10)                       not null,
    debito               decimal(10,2)                  not null
          check (debito>=0),
    credito              decimal(10,2)                  not null
          check (credito>=0),
    primary key (linea_aux2, linea, secuencia, compania, aplicacion, year, periodo)
);

create table cglctasxaplicacion 
(
    cuenta               char(24)                       not null,
    aplicacion           char(3)                        not null,
    status               char                           not null,
    primary key (cuenta, aplicacion)
);

create table cglcuentas 
(
    cuenta               char(24)                       not null,
    nombre               char(30)                       not null,
    nivel                char(2)                        not null,
    naturaleza           integer                        not null,
    auxiliar_1           char                           not null,
    auxiliar_2           char                           not null,
    efectivo             char                           not null,
    tipo_cuenta          char                           not null,
    primary key (cuenta),
    check ((auxiliar_1='S' or auxiliar_1='N') and(auxiliar_2='S' or auxiliar_2='N') and(efectivo='S' or efectivo='N') and(naturaleza=1 or naturaleza=-1) and(tipo_cuenta='B' or tipo_cuenta='R'))
);

create table cglniveles 
(
    nivel                char(2)                        not null,
    descripcion          char(30)                       not null,
    posicion_inicial     integer                        not null,
    posicion_final       integer                        not null,
    recibe               char,
    primary key (nivel)
);

create table cglperiodico1 
(
    compania             char(2)                        not null,
    secuencia            integer                        not null,
    tipo_comp            char(3)                        not null,
    estado               char                           not null
          check (estado in ('A','I')),
    usuario_captura      char(10)                       not null,
    fecha_captura        timestamp                      not null,
    primary key (compania, secuencia)
);

create table cglperiodico2 
(
    cuenta               char(24)                       not null,
    compania             char(2)                        not null,
    secuencia            integer                        not null,
    debito               decimal(10,2)                  not null
          check (debito>=0),
    credito              decimal(10,2)                  not null
          check (credito>=0),
    descripcion          char(50)                       not null,
    linea                integer                        not null,
    primary key (compania, secuencia, linea)
);

create table cglperiodico3 
(
    compania             char(2)                        not null,
    secuencia            integer                        not null,
    linea                integer                        not null,
    auxiliar             char(10)                       not null,
    linea_aux            integer                        not null,
    debito               decimal(10,2)                  not null,
    credito              decimal(10,2)                  not null,
    primary key (compania, secuencia, linea, linea_aux)
);

create table cglperiodico4 
(
    compania             char(2)                        not null,
    secuencia            integer                        not null,
    linea                integer                        not null,
    auxiliar             char(10)                       not null,
    linea_aux            integer                        not null,
    debito               decimal(10,2)                  not null,
    credito              decimal(10,2)                  not null,
    primary key (compania, secuencia, linea, linea_aux)
);

create table cglposteo 
(
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    cuenta               char(24)                       not null,
    consecutivo          integer                        not null,
    tipo_comp            char(3)                        not null,
    secuencia            integer                        not null,
    aplicacion_origen    char(3)                        not null,
    usuario_captura      char(10)                       not null,
    usuario_actualiza    char(10)                       not null,
    fecha_comprobante    date                           not null,
    fecha_captura        timestamp                      not null,
    fecha_actualiza      timestamp                      not null,
    descripcion          char(50)                       not null,
    debito               decimal(10,2)                  not null
          check (debito>=0),
    credito              decimal(10,2)                  not null
          check (credito>=0),
    Status               char                           not null
          check (Status in ('R','U')),
    Linea                integer                        not null
          check (linea>=0),
    primary key (consecutivo)
);

create  index i_cglposteo_1 on cglposteo (
secuencia ASC,
compania ASC,
aplicacion ASC,
year ASC,
periodo ASC,
Linea ASC,
cuenta ASC
);

create table cglposteoaux1 
(
    consecutivo          integer                        not null,
    auxiliar             char(10)                       not null,
    secuencial           integer                        not null,
    debito               decimal(10,2)                  not null
          check (debito>=0),
    credito              decimal(10,2)                  not null
          check (credito>=0),
    primary key (consecutivo, secuencial)
);

create table cglposteoaux2 
(
    consecutivo          integer                        not null,
    auxiliar             char(10)                       not null,
    secuencial           integer                        not null,
    debito               decimal(10,2)                  not null
          check (debito>=0),
    credito              decimal(10,2)                  not null
          check (credito>=0),
    primary key (consecutivo, secuencial)
);

create table cglrecurrente 
(
    compania             char(2)                        not null,
    secuencia            integer                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    status               char                           not null
          check (status in ('A','I')),
    primary key (compania, secuencia, aplicacion, year, periodo)
);

create table cglsldoaux1 
(
    compania             char(2)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    cuenta               char(24)                       not null,
    auxiliar             char(10)                       not null,
    balance_inicio       decimal(10,2)                  not null,
    debito               decimal(10,2)                  not null
          check (debito>=0),
    credito              decimal(10,2)                  not null
          check (credito>=0),
    primary key (compania, year, periodo, cuenta, auxiliar)
);

create table cglsldoaux2 
(
    compania             char(2)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    cuenta               char(24)                       not null,
    auxiliar             char(10)                       not null,
    balance_inicio       decimal(10,2)                  not null,
    debito               decimal(10,2)                  not null
          check (debito>=0),
    credito              decimal(10,2)                  not null
          check (credito>=0),
    primary key (compania, year, periodo, cuenta, auxiliar)
);

create table cglsldocuenta 
(
    compania             char(2)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    cuenta               char(24)                       not null,
    balance_inicio       decimal(10,2)                  not null,
    debito               decimal(10,2)                  not null
          check (debito>=0),
    credito              decimal(10,2)                  not null
          check (credito>=0),
    primary key (compania, year, periodo, cuenta)
);

create table cgltipocomp 
(
    tipo_comp            char(3)                        not null,
    descripcion          char(50)                       not null,
    primary key (tipo_comp)
);

create table clientes 
(
    cliente              char(6)                        not null,
    forma_pago           char(2)                        not null,
    cuenta               char(24)                       not null,
    cli_cliente          char(6)                        not null,
    vendedor             char(5)                        not null,
    lista_de_precio      integer,
    nomb_cliente         char(40)                       not null,
    id                   char(30),
    mail                 char(40),
    homepage             char(40),
    fecha_apertura       timestamp                      not null,
    fecha_cierre         date                           not null,
    status               char                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    tel1_cliente         char(15)                       not null,
    tel2_cliente         char(15),
    fax_cliente          char(15),
    apartado             char(30),
    direccion1           char(50)                       not null,
    direccion2           char(50),
    direccion3           char(50),
    limite_credito       decimal(10,2)                  not null,
    categoria_abc        char(2)                        not null
          check (categoria_abc in ('A','B','C')),
    promedio_dias_cobro  integer                        not null,
    estado_cuenta        char                           not null
          check (estado_cuenta in ('S','N')),
    primary key (cliente)
);

create table clientes_agrupados 
(
    cliente              char(6)                        not null,
    codigo_valor_grupo   char(3)                        not null,
    primary key (cliente, codigo_valor_grupo)
);

create table convmedi 
(
    old_unidad           char(7)                        not null,
    new_unidad           char(7)                        not null,
    factor               decimal(10,2)                  not null,
    primary key (old_unidad, new_unidad)
);

create table cxcbalance 
(
    cliente              char(6)                        not null,
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    balance_anterior     decimal(10,2)                  not null,
    debitos              decimal(10,2)                  not null,
    creditos             decimal(10,2)                  not null,
    primary key (cliente, compania, aplicacion, year, periodo)
);

create table cxcdocm 
(
    documento            char(10)                       not null,
    docmto_aplicar       char(10)                       not null,
    cliente              char(6)                        not null,
    motivo_cxc           char(3)                        not null,
    almacen              char(2)                        not null,
    docmto_ref           char(10)                       not null,
    motivo_ref           char(3)                        not null,
    aplicacion_origen    char(3)                        not null,
    uso_interno          char                           not null
          check (uso_interno in ('S','N')),
    fecha_docmto         date                           not null,
    fecha_vmto           date                           not null,
    monto                decimal                        not null
          check (monto>=0),
    fecha_posteo         date                           not null,
    status               char                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    obs_docmto           long varchar,
    fecha_cancelo        timestamp                      not null,
    primary key (documento, docmto_aplicar, cliente, motivo_cxc, almacen)
);

create table cxcfact1 
(
    cliente              char(6)                        not null,
    almacen              char(2)                        not null,
    no_factura           char(10)                       not null,
    forma_pago           char(2)                        not null,
    motivo_cxc           char(3)                        not null,
    fecha_vence_fact     date                           not null,
    fecha_factura        date                           not null,
    fecha_posteo_fact    date                           not null,
    obs_fact             long varchar,
    status               char                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    primary key (almacen, no_factura)
);

create table cxcfact2 
(
    linea                integer                        not null,
    almacen              char(2)                        not null,
    no_factura           char(10)                       not null,
    cuenta               char(24)                       not null,
    rubro_fact_cxc       char(15)                       not null,
    auxiliar1            char(10),
    auxiliar2            char(10),
    monto                decimal(10,2)                  not null,
    primary key (linea, almacen, no_factura, rubro_fact_cxc)
);

create table cxcfact3 
(
    aplicar_a            char(10)                       not null,
    almacen              char(2)                        not null,
    no_factura           char(10)                       not null,
    motivo_cxc           char(3)                        not null,
    monto                decimal(10,2)                  not null,
    primary key (aplicar_a, almacen, no_factura, motivo_cxc)
);

create table cxcmorosidad 
(
    cliente              char(6)                        not null,
    periodo1             decimal(10,2)                  not null,
    periodo2             decimal(10,2)                  not null,
    periodo3             decimal(10,2)                  not null,
    periodo4             decimal(10,2)                  not null,
    periodo5             decimal(10,2)                  not null,
    usuario              char(10)                       not null,
    documento            char(10)                       not null,
    motivo_cxc           char(3)                        not null,
    compania             char(2)                        not null,
    titulo1              char(20)                       not null,
    titulo2              char(20)                       not null,
    titulo3              char(20)                       not null,
    titulo4              char(20)                       not null,
    titulo5              char(20)                       not null,
    fecha_corte          date                           not null,
    primary key (cliente, documento, motivo_cxc)
);

create table cxcmotivos 
(
    motivo_cxc           char(3)                        not null,
    desc_motivo_cxc      char(40)                       not null,
    signo                integer                        not null
          check (signo in (1,-1)),
    ajustes              char                           not null
          check (ajustes in ('S','N')),
    factura              char                           not null
          check (factura in ('S','N')),
    tipo_comp            char(3)                        not null,
    cobros               char                           not null
          check (cobros in ('S','N')),
    primary key (motivo_cxc)
);

create table cxcrecibo1 
(
    no_recibo            char(10)                       not null,
    cliente              char(6)                        not null,
    almacen              char(2)                        not null,
    motivo_cxc           char(3)                        not null,
    fecha_recibo         date                           not null,
    fecha_posteo         date                           not null,
    observacion          char,
    status               char                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    primary key (no_recibo, almacen)
);

create table cxcrecibo2 
(
    no_recibo            char(10)                       not null,
    almacen              char(2)                        not null,
    valor                decimal(10,2)                  not null,
    docm_aplicar         char(10)                       not null,
    motivo_cxc           char(3)                        not null,
    primary key (no_recibo, almacen, docm_aplicar, motivo_cxc)
);

create table cxctrx1 
(
    sec_ajuste_cxc       integer                        not null,
    motivo_cxc           char(3)                        not null,
    cliente              char(6)                        not null,
    almacen              char(2)                        not null,
    docm_ajuste_cxc      char(10)                       not null,
    fecha_doc_ajuste_cxc date                           not null,
    fecha_posteo_ajuste_cxc date                           not null,
    obs_ajuste_cxc       long varchar,
    status               char                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    efectivo             decimal(10,2)                  not null,
    cheque               decimal(10,2)                  not null,
    primary key (sec_ajuste_cxc, almacen)
);

create table cxctrx2 
(
    aplicar_a            char(10)                       not null,
    sec_ajuste_cxc       integer                        not null,
    almacen              char(2)                        not null,
    motivo_cxc           char(3)                        not null,
    monto                decimal(10,2)                  not null,
    primary key (aplicar_a, sec_ajuste_cxc, almacen, motivo_cxc)
);

create table cxctrx3 
(
    linea                integer                        not null,
    cuenta               char(24)                       not null,
    sec_ajuste_cxc       integer                        not null,
    almacen              char(2)                        not null,
    auxiliar1            char(10),
    auxiliar2            char(10),
    monto                decimal(10,2)                  not null,
    primary key (linea, sec_ajuste_cxc, almacen)
);

create table cxpajuste1 
(
    proveedor            char(6)                        not null,
    compania             char(2)                        not null,
    sec_ajuste_cxp       integer                        not null,
    motivo_cxp           char(3)                        not null,
    docm_ajuste_cxp      char(10)                       not null,
    fecha_doc_ajuste_cxp date                           not null,
    fecha_posteo_ajuste_cxp date                           not null,
    obs_ajuste_cxp       long varchar,
    status               char                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    primary key (compania, sec_ajuste_cxp)
);

create table cxpajuste2 
(
    compania             char(2)                        not null,
    sec_ajuste_cxp       integer                        not null,
    aplicar_a            char(10)                       not null,
    motivo_cxp           char(3)                        not null,
    monto                decimal(10,2)                  not null,
    primary key (compania, sec_ajuste_cxp, aplicar_a, motivo_cxp)
);

create table cxpajuste3 
(
    compania             char(2)                        not null,
    sec_ajuste_cxp       integer                        not null,
    cuenta               char(24)                       not null,
    linea                integer                        not null,
    auxiliar1            char(10),
    auxiliar2            char(10),
    monto                decimal(10,2)                  not null,
    primary key (compania, sec_ajuste_cxp, linea)
);

create table cxpbalance 
(
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    proveedor            char(6)                        not null,
    balance_anterior     decimal(10,2)                  not null,
    debitos              decimal(10,2)                  not null,
    creditos             decimal(10,2)                  not null,
    primary key (compania, aplicacion, year, periodo, proveedor)
);

create table cxpdocm 
(
    proveedor            char(6)                        not null,
    compania             char(2)                        not null,
    documento            char(10)                       not null,
    docmto_aplicar       char(10)                       not null,
    motivo_cxp           char(3)                        not null,
    docmto_aplicar_ref   char(10)                       not null,
    motivo_cxp_ref       char(3)                        not null,
    aplicacion_origen    char(3)                        not null,
    uso_interno          char                           not null
          check (uso_interno in ('S','N')),
    fecha_docmto         date                           not null,
    fecha_vmto           date                           not null,
    monto                decimal(10,2)                  not null
          check (monto>=0),
    fecha_posteo         date                           not null,
    status               char                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    obs_docmto           long varchar,
    fecha_cancelo        timestamp                      not null,
    primary key (proveedor, compania, documento, docmto_aplicar, motivo_cxp)
);

create table cxpfact1 
(
    proveedor            char(6)                        not null,
    fact_proveedor       char(10)                       not null,
    forma_pago           char(2)                        not null,
    numero_oc            integer,
    compania             char(2)                        not null,
    motivo_cxp           char(3)                        not null,
    aplicacion_origen    char(3)                        not null,
    oc1_compania         char(2),
    vence_fact_cxp       date                           not null,
    fecha_factura_cxp    date                           not null,
    fecha_posteo_fact_cxp date                           not null,
    obs_fact_cxp         long varchar,
    status               char                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    primary key (proveedor, fact_proveedor, compania)
);

create table cxpfact2 
(
    proveedor            char(6)                        not null,
    fact_proveedor       char(10)                       not null,
    rubro_fact_cxp       char(15)                       not null,
    cxp_linea            integer                        not null,
    compania             char(2)                        not null,
    auxiliar1            char(10),
    auxiliar2            char(10),
    cuenta               char(24),
    monto                decimal(10,2)                  not null,
    primary key (proveedor, fact_proveedor, rubro_fact_cxp, cxp_linea, compania)
);

create table cxpfact3 
(
    proveedor            char(6)                        not null,
    fact_proveedor       char(10)                       not null,
    aplicar_a            char(10)                       not null,
    compania             char(2)                        not null,
    motivo_cxp           char(3)                        not null,
    monto                decimal                        not null,
    primary key (proveedor, fact_proveedor, aplicar_a, compania, motivo_cxp)
);

create table cxpmorosidad 
(
    proveedor            char(6)                        not null,
    documento            char(10)                       not null,
    motivo_cxp           char(3)                        not null,
    fecha_documento      date                           not null,
    periodo1             decimal(10,2)                  not null,
    periodo2             decimal(10,2)                  not null,
    periodo3             decimal(10,2)                  not null,
    periodo4             decimal(10,2)                  not null,
    periodo5             decimal(10,2)                  not null,
    fecha_corte          date                           not null,
    compania             char(2)                        not null,
    titulo1              char(20)                       not null,
    titulo2              char(20)                       not null,
    titulo3              char(20)                       not null,
    titulo4              char(20)                       not null,
    titulo5              char(20)                       not null,
    usuario              char(10)                       not null,
    primary key (proveedor, documento, motivo_cxp)
);

create table cxpmotivos 
(
    motivo_cxp           char(3)                        not null,
    desc_motivo_cxp      char(40)                       not null,
    signo                integer                        not null
          check (signo in (1,-1)),
    ajuste               char                           not null
          check (ajuste in ('S','N')),
    factura              char                           not null
          check (factura in ('S','N')),
    pago                 char                           not null
          check (pago in ('S','N')),
    tipo_comp            char(3)                        not null,
    primary key (motivo_cxp)
);

create table descuentos 
(
    secuencia            integer                        not null,
    cantidad_desde       decimal(10,2)                  not null,
    cantidad_hasta       decimal(10,2)                  not null,
    descuento            decimal(10,2)                  not null,
    fecha_desde          date                           not null,
    fecha_hasta          date                           not null,
    status               char                           not null,
    usuario_captura      char(10)                       not null,
    fecha_captura        timestamp                      not null,
    observacion          long varchar,
    primary key (secuencia)
);

create table descuentos_por_articulo 
(
    Articulo             char(15)                       not null,
    almacen              char(2)                        not null,
    secuencia            integer                        not null,
    primary key (Articulo, almacen, secuencia)
);

create table descuentos_por_cliente 
(
    secuencia            integer                        not null,
    cliente              char(6)                        not null,
    primary key (secuencia, cliente)
);

create table descuentos_por_grupo 
(
    secuencia            integer                        not null,
    codigo_valor_grupo   char(3)                        not null,
    primary key (secuencia, codigo_valor_grupo)
);

create table empleados 
(
    cedula               char(20)                       not null,
    nombre               char(50)                       not null,
    edad                 integer                        not null,
    direccion            char(50)                       not null,
    rata_x_hora          decimal(10,2)                  not null,
    salario_base         decimal(10,2)                  not null,
    primary key (cedula)
);

create table eys1 
(
    almacen              char(2)                        not null,
    no_transaccion       integer                        not null,
    motivo               char(2)                        not null,
    aplicacion_origen    char(3)                        not null,
    fecha                date                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    observacion          long varchar,
    status               char                           not null,
    primary key (almacen, no_transaccion)
);

create table eys2 
(
    articulo             char(15)                       not null,
    almacen              char(2)                        not null,
    no_transaccion       integer                        not null,
    inv_linea            integer                        not null,
    cantidad             decimal(10,2)                  not null,
    costo                decimal(10,2)                  not null,
    primary key (articulo, almacen, no_transaccion, inv_linea)
);

create table eys3 
(
    almacen              char(2)                        not null,
    no_transaccion       integer                        not null,
    cuenta               char(24)                       not null,
    auxiliar1            char(10),
    auxiliar2            char(10),
    monto                decimal(10,2)                  not null,
    primary key (almacen, no_transaccion, cuenta)
);

create table eys4 
(
    articulo             char(15)                       not null,
    almacen              char(2)                        not null,
    no_transaccion       integer                        not null,
    inv_linea            integer                        not null,
    proveedor            char(6)                        not null,
    fact_proveedor       char(10)                       not null,
    rubro_fact_cxp       char(15)                       not null,
    cxp_linea            integer                        not null,
    compania             char(2)                        not null,
    primary key (articulo, almacen, no_transaccion, inv_linea)
);

create table facparamcgl 
(
    codigo_valor_grupo   char(3)                        not null,
    almacen              char(2)                        not null,
    auxiliar1_ingreso    char(10),
    auxiliar2_ingreso    char(10),
    cuenta_ingreso       char(24)                       not null,
    cuenta_costo         char(24)                       not null,
    auxiliar1_costo      char(10),
    auxiliar2_costo      char(10),
    primary key (codigo_valor_grupo, almacen)
);

create table fact_autoriza_descto 
(
    password             char(10)                       not null,
    monto                decimal(10,2)                  not null,
    primary key (password)
);

create table factmotivos 
(
    tipo                 char(3)                        not null,
    descripcion          char(30)                       not null,
    factura              char                           not null
          check (factura in ('S','N')),
    cotizacion           char                           not null
          check (cotizacion in ('S','N')),
    nota_credito         char                           not null
          check (nota_credito in ('S','N')),
    devolucion           char                           not null
          check (devolucion in ('S','N')),
    signo                integer                        not null
          check (signo in (1,-1)),
    tipo_comp            char(3)                        not null,
    primary key (tipo)
);

create table factsobregiro 
(
    fecha                date                           not null,
    cliente              char(6)                        not null,
    monto                decimal(10,2)                  not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    primary key (fecha, cliente)
);

create table factura1 
(
    almacen              char(2)                        not null,
    tipo                 char(3)                        not null,
    num_documento        integer                        not null,
    cliente              char(6)                        not null,
    forma_pago           char(2)                        not null,
    codigo_vendedor      char(5)                        not null,
    nombre_cliente       char(50)                       not null,
    direccion            long varchar,
    descto_porcentaje    decimal(10,2)                  not null,
    descto_monto         decimal(10,2)                  not null,
    usuario_captura      char(10)                       not null,
    usuario_postea       char(10)                       not null,
    usuario_autoriza_descto char(10),
    fecha_vencimiento    date                           not null,
    fecha_captura        timestamp                      not null,
    fecha_postea         date                           not null,
    fecha_factura        date                           not null,
    status               char                           not null,
    num_cotizacion       integer                        not null,
    num_factura          integer                        not null,
    observacion          long varchar,
    primary key (almacen, tipo, num_documento)
);

create table factura2 
(
    almacen              char(2)                        not null,
    tipo                 char(3)                        not null,
    num_documento        integer                        not null,
    linea                integer                        not null,
    articulo             char(15)                       not null,
    cantidad             decimal(10,2)                  not null,
    precio               decimal(10,2)                  not null,
    descuento_linea      decimal(10,2)                  not null,
    descuento_global     decimal(10,2)                  not null,
    primary key (almacen, tipo, num_documento, linea)
);

create table factura2_eys2 
(
    articulo             char(15)                       not null,
    almacen              char(2)                        not null,
    no_transaccion       integer                        not null,
    eys2_linea           integer                        not null,
    tipo                 char(3)                        not null,
    num_documento        integer                        not null,
    factura2_linea       integer                        not null,
    primary key (articulo, almacen, no_transaccion, eys2_linea)
);

create table factura3 
(
    almacen              char(2)                        not null,
    tipo                 char(3)                        not null,
    num_documento        integer                        not null,
    linea                integer                        not null,
    impuesto             char(2)                        not null,
    Monto                decimal(10,2)                  not null,
    primary key (almacen, tipo, num_documento, linea, impuesto)
);

create table factura4 
(
    almacen              char(2)                        not null,
    tipo                 char(3)                        not null,
    num_documento        integer                        not null,
    rubro_fact_cxc       char(15)                       not null,
    monto                decimal(10,2)                  not null,
    primary key (almacen, tipo, num_documento, rubro_fact_cxc)
);

create table factura5 
(
    almacen              char(2)                        not null,
    tipo                 char(3)                        not null,
    num_documento        integer                        not null,
    banco                char(3)                        not null,
    num_cheque           integer                        not null,
    monto                decimal(10,2)                  not null,
    fecha_cheque         date                           not null,
    primary key (almacen, tipo, num_documento, banco, num_cheque)
);

create table factura6 
(
    almacen              char(2)                        not null,
    tipo                 char(3)                        not null,
    num_documento        integer                        not null,
    banco                char(3)                        not null,
    num_tarjeta_credito  char(40)                       not null,
    monto                decimal(10,2)                  not null,
    primary key (almacen, tipo, num_documento, banco)
);

create table factura7 
(
    almacen              char(2)                        not null,
    tipo                 char(3)                        not null,
    num_documento        integer                        not null,
    monto_recibido       decimal(10,2)                  not null,
    monto_cobrado        decimal(10,2)                  not null,
    primary key (almacen, tipo, num_documento)
);

create table fax 
(
    pb_lname             char(40),
    pb_fname             char(20),
    pb_company           char(50)                       not null,
    pb_title             char(40),
    pb_phnum1            char(20)                       not null,
    pb_phnum2            char(20),
    pb_send              char                           not null,
    pb_observacion       long varchar,
    tipo_cliente         integer                        not null,
    primary key (pb_phnum1)
);

create unique index pb_company on fax (
pb_company ASC
);

create table fisico1 
(
    almacen              char(2)                        not null,
    fecha                timestamp                      not null,
    secuencia            integer                        not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    status               char                           not null,
    fecha_ajuste         timestamp                      not null,
    primary key (almacen, fecha, secuencia)
);

create table fisico2 
(
    Articulo             char(15)                       not null,
    almacen              char(2)                        not null,
    fecha                timestamp                      not null,
    secuencia            integer                        not null,
    existencia           decimal(10,2)                  not null,
    costo                decimal(10,2)                  not null,
    conteo               decimal(10,2)                  not null,
    primary key (Articulo, almacen, fecha, secuencia)
);

create table funcionarios_cliente 
(
    cliente              char(6)                        not null,
    sec_funcionario_clte integer                        not null,
    nomb_funcionario_clte char(40)                       not null,
    cargo_funcionario_clte char(40)                       not null,
    interno_func_clte    char(10),
    mail_func_clte       char(40),
    primary key (cliente, sec_funcionario_clte)
);

create table funcionarios_proveedor 
(
    proveedor            char(6)                        not null,
    sec_funcionario      integer                        not null,
    nomb_funcionario     char(40)                       not null,
    cargo_funcionario    char(40)                       not null,
    interno              char(10),
    mail_func_proveedor  char(40),
    primary key (proveedor, sec_funcionario)
);

create table gral_forma_de_pago 
(
    forma_pago           char(2)                        not null,
    desc_forma_pago      char(40)                       not null,
    dias                 integer                        not null,
    status               char                           not null,
    primary key (forma_pago)
);

create table gral_grupos_aplicacion 
(
    grupo                char(3)                        not null,
    aplicacion           char(3)                        not null,
    desc_grupo           char(40)                       not null,
    status               char                           not null,
    secuencia            integer                        not null,
    requerido            char                           not null
          check (requerido in ('S','N')),
    primary key (grupo, aplicacion)
);

create table gral_impuestos 
(
    impuesto             char(2)                        not null,
    auxiliar1            char(10),
    auxiliar2            char(10),
    cuenta               char(24)                       not null,
    desc_impuesto        char(40)                       not null,
    porcentaje           decimal(10,2)                  not null,
    primary key (impuesto)
);

create table gral_valor_grupos 
(
    grupo                char(3)                        not null,
    aplicacion           char(3)                        not null,
    codigo_valor_grupo   char(3)                        not null,
    gra_codigo_valor_grupo char(3)                        not null,
    desc_valor_grupo     char(40)                       not null,
    status               char                           not null,
    primary key (codigo_valor_grupo)
);

create table gralaplicaciones 
(
    aplicacion           char(3)                        not null,
    descripcion          char(20)                       not null,
    menu                 char(20)                       not null,
    primary key (aplicacion)
);

create table gralcompanias 
(
    compania             char(2)                        not null,
    nombre               char(30)                       not null,
    direccion            char(30)                       not null,
    id_tributario        char(20)                       not null,
    dv                   char(10)                       not null,
    primary key (compania)
);

create table gralparametros 
(
    parametro            char(20)                       not null,
    aplicacion           char(3)                        not null,
    descripcion          char(40)                       not null,
    primary key (parametro, aplicacion)
);

create table gralparaxapli 
(
    parametro            char(20)                       not null,
    aplicacion           char(3)                        not null,
    valor                char(20)                       not null,
    primary key (parametro, aplicacion)
);

create table gralparaxcia 
(
    compania             char(2)                        not null,
    parametro            char(20)                       not null,
    aplicacion           char(3)                        not null,
    valor                char(20)                       not null,
    primary key (compania, parametro, aplicacion)
);

create table gralperiodos 
(
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    descripcion          char(20)                       not null,
    inicio               date                           not null,
    final                date                           not null,
    estado               char                           not null,
    primary key (compania, aplicacion, year, periodo),
    check (estado='A' or estado='I')
);

create table gralsecuencias 
(
    aplicacion           char(3)                        not null,
    parametro            char(20)                       not null,
    descripcion          char(40)                       not null,
    primary key (aplicacion, parametro)
);

create table gralsecxcia 
(
    aplicacion           char(3)                        not null,
    parametro            char(20)                       not null,
    compania             char(2)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    secuencia            integer                        not null,
    primary key (aplicacion, parametro, compania, year, periodo)
);

create table imp_oc 
(
    impuesto             char(2)                        not null,
    rubro_fact_cxp       char(15)                       not null,
    primary key (impuesto)
);

create table impuestos_facturacion 
(
    impuesto             char(2)                        not null,
    rubro_fact_cxc       char(15),
    primary key (impuesto)
);

create table impuestos_por_grupo 
(
    codigo_valor_grupo   char(3)                        not null,
    impuesto             char(2)                        not null,
    primary key (codigo_valor_grupo, impuesto)
);

create table inconsistencias 
(
    usuario              char(10)                       not null,
    codigo               char(15)                       not null,
    fecha                date                           not null,
    mensaje              char(200)                      not null
);

create table inv_conversion 
(
    convertir_d          char(10)                       not null,
    convertir_a          char(10)                       not null,
    factor               decimal(12,5)                  not null,
    primary key (convertir_d, convertir_a)
);

create table invbalance 
(
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    Articulo             char(15)                       not null,
    almacen              char(2)                        not null,
    cantidad_anterior    decimal(10,2)                  not null,
    db_cant_actual       decimal                        not null,
    cr_cant_actual       decimal(10,2)                  not null,
    costo_anterior       decimal(10,2)                  not null,
    db_cost_actual       decimal(10,2)                  not null,
    cr_cost_actual       decimal(10,2)                  not null,
    primary key (compania, aplicacion, year, periodo, Articulo, almacen)
);

create table invmotivos 
(
    motivo               char(2)                        not null,
    desc_motivo          char(40)                       not null,
    signo                integer                        not null,
    costo                char                           not null
          check (costo in ('S','N')),
    cantidad             char                           not null
          check (cantidad in ('S','N')),
    tipo_comp            char(3)                        not null,
    primary key (motivo)
);

create table invparal 
(
    almacen              char(2)                        not null,
    parametro            char(20)                       not null,
    aplicacion           char(3)                        not null,
    valor                char(20)                       not null,
    primary key (almacen, parametro, aplicacion)
);

create table listas_de_precio_1 
(
    secuencia            integer                        not null,
    descripcion          char(50)                       not null,
    cantidad_desde       decimal(10,2)                  not null,
    cantidad_hasta       decimal(10,2)                  not null,
    fecha_desde          date                           not null,
    fecha_hasta          date                           not null,
    status               char                           not null,
    fecha_captura        timestamp                      not null,
    usuario_captura      char(10)                       not null,
    primary key (secuencia)
);

create table nom_conceptos_para_calculo 
(
    cod_concepto_planilla char(3)                        not null,
    concepto_aplica      char(3)                        not null,
    primary key (cod_concepto_planilla, concepto_aplica)
);

comment on column nom_conceptos_para_calculo.cod_concepto_planilla is 'Conceptos utilizados en planilla';

comment on column nom_conceptos_para_calculo.concepto_aplica is 'Conceptos utilizados en planilla';

create table nom_otros_ingresos 
(
    tipo_calculo         char(2)                        not null,
    tipo_planilla        char(2)                        not null,
    numero_planilla      integer                        not null,
    desde                date                           not null,
    codigo_empleado      char(7)                        not null,
    compania             char(2)                        not null,
    cod_concepto_planilla char(3)                        not null,
    status               char                           not null,
    monto                decimal(10,2)                  not null,
    primary key (tipo_calculo, tipo_planilla, numero_planilla, desde, codigo_empleado, compania)
);

comment on column nom_otros_ingresos.tipo_planilla is 'Tipo de Planilla';

comment on column nom_otros_ingresos.cod_concepto_planilla is 'Conceptos utilizados en planilla';

create table nom_tipo_de_calculo 
(
    tipo_calculo         char(2)                        not null,
    descripcion          char(50)                       not null,
    primary key (tipo_calculo)
);

create table nomacrem 
(
    numero_documento     char(6)                        not null,
    codigo_empleado      char(7)                        not null,
    cuenta               char(24),
    cod_acreedores       char(5),
    cod_concepto_planilla char(3)                        not null,
    compania             char(2)                        not null,
    descripcion_descuento char(30),
    monto_original_deuda decimal(8,2)                   not null,
    letras_a_pagar       integer                        not null,
    fecha_inidescto      date                           not null,
    fecha_finaldescto    date,
    status               char                           not null default 'A'
          check (status in ('A','I','C')),
    observacion          long varchar,
    hacer_cheque         char                           not null
          check (hacer_cheque in ('B','M','N','Q','S')),
    varios_o_un_cheque   char                           not null
          check (varios_o_un_cheque in ('V','U')),
    incluir_deduc_carta_trabajo char                           not null
          check (incluir_deduc_carta_trabajo in ('S','N')),
    deduccion_aplica_diciembre char                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    primary key (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
);

comment on table nomacrem is 'Acreedortes x Empleado';

comment on column nomacrem.cod_acreedores is 'Código de identificacion de acreedores';

comment on column nomacrem.cod_concepto_planilla is 'Conceptos utilizados en planilla';

comment on column nomacrem.status is 'Estado del descuento';

comment on column nomacrem.varios_o_un_cheque is 'Varios o Un Cheque?';

comment on column nomacrem.deduccion_aplica_diciembre is 'Deducción en Diciembre?';

create table nomauta 
(
    fecha_laborable      date                           not null,
    codigo_empleado      char(7)                        not null,
    compania             char(2)                        not null,
    tipo_de_auta         char                           not null,
    tipo_planilla        char(2)                        not null,
    numero_planilla      integer                        not null,
    forma_de_registro    char                           not null,
    horas                integer                        not null,
    minutos              integer                        not null,
    justificado          char                           not null,
    primary key (fecha_laborable, codigo_empleado, compania, tipo_de_auta)
);

comment on column nomauta.tipo_planilla is 'Tipo de Planilla';

create table nomconce 
(
    cod_concepto_planilla char(3)                        not null,
    cuenta               char(24)                       not null,
    nombre_concepto      char(30)                       not null,
    signo                integer                        not null,
    solo_patrono         char                           not null,
    priorioridad_impresion integer                        not null,
    porcentaje           decimal(10,2)                  not null,
    primary key (cod_concepto_planilla)
);

comment on table nomconce is 'Concepto Utilizados en planilla';

comment on column nomconce.cod_concepto_planilla is 'Conceptos utilizados en planilla';

comment on column nomconce.nombre_concepto is 'Nombre de los diferentes ingresos que persive el Empleado';

create table nomctrac 
(
    anio                 integer                        not null,
    mes                  integer                        not null,
    codigo_empleado      char(7)                        not null,
    compania             char(2)                        not null,
    tipo_calculo         char(2)                        not null,
    cod_concepto_planilla char(3)                        not null,
    clasificar_concepto  char(2)                       
          check (clasificar_concepto is null or ( clasificar_concepto in ('I','D','P','IM') )),
    monto                decimal(10,2)                  not null,
    tipo_planilla        char(2)                        not null,
    numero_planilla      integer                        not null,
    desde                date                           not null,
    usuario              char(10)                       not null,
    fecha_actualiza      timestamp                      not null,
    status               char                           not null,
    forma_de_registro    char                           not null,
    primary key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla)
);

comment on table nomctrac is 'Control de acumulado de planilla';

comment on column nomctrac.cod_concepto_planilla is 'Conceptos utilizados en planilla';

comment on column nomctrac.clasificar_concepto is 'Código de identificación del concepto';

comment on column nomctrac.tipo_planilla is 'Tipo de Planilla';

create table nomdedu 
(
    numero_documento     char(20)                       not null,
    codigo_empleado      char(7)                        not null,
    cod_concepto_planilla char(3)                        not null,
    compania             char(2)                        not null,
    periodo              integer                        not null,
    monto                decimal(10,2)                  not null,
    primary key (numero_documento, codigo_empleado, cod_concepto_planilla, compania, periodo)
);

comment on column nomdedu.cod_concepto_planilla is 'Conceptos utilizados en planilla';

create table nomdescuentos 
(
    codigo_empleado      char(7)                        not null,
    compania             char(2)                        not null,
    cod_concepto_planilla char(3)                        not null,
    numero_documento     char(20)                       not null,
    numero_planilla      integer                        not null,
    tipo_planilla        char(2)                        not null,
    tipo_calculo         char(2)                        not null,
    monto_descuento      decimal(10,2)                  not null,
    primary key (codigo_empleado, compania, cod_concepto_planilla, numero_documento, numero_planilla, tipo_planilla, tipo_calculo)
);

comment on column nomdescuentos.cod_concepto_planilla is 'Conceptos utilizados en planilla';

comment on column nomdescuentos.tipo_planilla is 'Tipo de Planilla';

create table nomdfer 
(
    fecha                date                           not null,
    descrip_dia_feriado  char(30)                       not null,
    st_referencia        char                           not null,
    recargo              decimal(10,2)                  not null,
    primary key (fecha)
);

comment on table nomdfer is 'Dias Feriados';

comment on column nomdfer.descrip_dia_feriado is 'Descripción del día feriado';

comment on column nomdfer.st_referencia is 'Estado de referencia de días libres';

create table nomextras 
(
    fecha_laborable      date                           not null,
    codigo_empleado      char(7)                        not null,
    compania             char(2)                        not null,
    tipo_planilla        char(2)                        not null,
    numero_planilla      integer                        not null,
    recargo              decimal(12,5)                  not null,
    tipo_d_dia           char                           not null
          check (tipo_d_dia in ('R','D','F')),
    horas                integer                        not null,
    minutos              integer                        not null,
    aprobado             char                           not null,
    forma_de_registro    char                           not null,
    primary key (fecha_laborable, codigo_empleado, compania, recargo, tipo_d_dia)
);

comment on column nomextras.tipo_planilla is 'Tipo de Planilla';

create table nomhrtrab 
(
    fecha_laborable      date                           not null,
    codigo_empleado      char(7)                        not null,
    compania             char(2)                        not null,
    cod_id_turnos        char(2)                        not null,
    tipo_planilla        char(2)                        not null,
    numero_planilla      integer                        not null,
    desde                date                           not null,
    status               char                           not null,
    hora_de_inicio_trabajo time                           not null,
    hora_de_descanso_inicio time,
    hora_de_descanso_final time,
    hora_de_salida_trabajo time,
    total_hr_trabajada   decimal(7,2),
    usuario              char(10)                       not null,
    fecha_actualiza      timestamp                      not null,
    fecha_salida         date                           not null,
    primary key (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla)
);

comment on table nomhrtrab is 'Registro de Horas Trabajadas';

comment on column nomhrtrab.tipo_planilla is 'Tipo de Planilla';

create table nomimrta 
(
    sbruto_inicial       decimal(8,2)                   not null,
    sbruto_final         decimal(8,2)                   not null,
    excedente_aplicar    decimal(8,5)                   not null,
    renta_fija           decimal(8,2)                   not null,
    primary key (sbruto_inicial, sbruto_final)
);

comment on table nomimrta is 'Impuesto sobre la renta';

comment on column nomimrta.sbruto_inicial is 'Monto inicial de Impuesto sobre la renta';

comment on column nomimrta.sbruto_final is 'Monto final sobre el impuesto sobre la renta';

create table nomperiodos 
(
    periodo              integer                        not null,
    primary key (periodo)
);

create table nomrecargos 
(
    recargo              decimal(12,5)                  not null,
    tipo_d_dia           char                           not null
          check (tipo_d_dia in ('R','D','F')),
    tipo_de_jornada      char                           not null
          check (tipo_de_jornada in ('D','N','M')),
    exceso_9horas        char                           not null
          check (exceso_9horas in ('S','N')),
    primary key (recargo, tipo_d_dia)
);

create table nomrelac 
(
    tipo_calculo         char(2)                        not null,
    cod_concepto_planilla char(3)                        not null,
    primary key (tipo_calculo, cod_concepto_planilla)
);

comment on table nomrelac is 'Tabla de relación de conceptos';

comment on column nomrelac.cod_concepto_planilla is 'Conceptos utilizados en planilla';

create table nomtpla 
(
    tipo_planilla        char(2)                        not null,
    descrip_tplanilla    char(20)                       not null,
    periodos_de_pago     integer                        not null,
    ultimo_periodo       integer                        not null,
    primary key (tipo_planilla)
);

comment on table nomtpla is 'Tipo de Planilla';

comment on column nomtpla.tipo_planilla is 'Tipo de Planilla';

comment on column nomtpla.descrip_tplanilla is 'Descripción del Tipo de Planilla';

comment on column nomtpla.periodos_de_pago is 'Cantidad de período';

create table nomtpla2 
(
    tipo_planilla        char(2)                        not null,
    numero_planilla      integer                        not null,
    desde                date                           not null,
    periodo              integer                        not null,
    hasta                date                           not null,
    status               char                           not null,
    dia_d_pago           date                           not null,
    primary key (tipo_planilla, numero_planilla, desde)
);

comment on column nomtpla2.tipo_planilla is 'Tipo de Planilla';

create table oc1 
(
    numero_oc            integer                        not null,
    proveedor            char(6)                        not null,
    forma_pago           char(2)                        not null,
    compania             char(2)                        not null,
    fecha                timestamp                      not null,
    status               char                           not null,
    observacion          long varchar,
    descuento            decimal(10,2)                  not null,
    primary key (numero_oc, compania)
);

create table oc2 
(
    Articulo             char(15)                       not null,
    linea_oc             integer                        not null,
    numero_oc            integer                        not null,
    compania             char(2)                        not null,
    cantidad             decimal(10,2)                  not null,
    precio               decimal(10,2)                  not null,
    descuento            decimal(10,2)                  not null,
    primary key (Articulo, linea_oc, numero_oc, compania)
);

create table oc3 
(
    impuesto             char(2)                        not null,
    numero_oc            integer                        not null,
    compania             char(2)                        not null,
    valor                decimal(10,2)                  not null,
    primary key (impuesto, numero_oc, compania)
);

create table oc4 
(
    tipo_de_cargo        char(2)                        not null,
    numero_oc            integer                        not null,
    compania             char(2)                        not null,
    cargo                decimal(10,2)                  not null,
    primary key (tipo_de_cargo, numero_oc, compania)
);

create table origen_del_sistema 
(
    codigo_de_origen     char                           not null,
    descripcion_del_origen char(40)                       not null,
    primary key (codigo_de_origen)
);

comment on table origen_del_sistema is 'Origen del Sistema';

comment on column origen_del_sistema.codigo_de_origen is 'Codigo de Origen';

comment on column origen_del_sistema.descripcion_del_origen is 'Descripción del Origen';

create table pbcatcol 
(
    pbc_tnam             char(129)                      not null,
    pbc_tid              integer,
    pbc_ownr             char(129)                      not null,
    pbc_cnam             char(129)                      not null,
    pbc_cid              smallint,
    pbc_labl             char(254),
    pbc_lpos             smallint,
    pbc_hdr              char(254),
    pbc_hpos             smallint,
    pbc_jtfy             smallint,
    pbc_mask             char(31),
    pbc_case             smallint,
    pbc_hght             smallint,
    pbc_wdth             smallint,
    pbc_ptrn             char(31),
    pbc_bmap             char,
    pbc_init             char(254),
    pbc_cmnt             char(254),
    pbc_edit             char(31),
    pbc_tag              char(254),
    primary key (pbc_tnam, pbc_ownr, pbc_cnam)
);

create table pbcatcol 
(
    pbc_tnam             char(129)                      not null,
    pbc_tid              integer,
    pbc_ownr             char(129)                      not null,
    pbc_cnam             char(129)                      not null,
    pbc_cid              smallint,
    pbc_labl             char(254),
    pbc_lpos             smallint,
    pbc_hdr              char(254),
    pbc_hpos             smallint,
    pbc_jtfy             smallint,
    pbc_mask             char(31),
    pbc_case             smallint,
    pbc_hght             smallint,
    pbc_wdth             smallint,
    pbc_ptrn             char(31),
    pbc_bmap             char,
    pbc_init             char(254),
    pbc_cmnt             char(254),
    pbc_edit             char(31),
    pbc_tag              char(254),
    primary key (pbc_tnam, pbc_ownr, pbc_cnam)
);

create table pbcatedt 
(
    pbe_name             char(30)                       not null,
    pbe_edit             char(254),
    pbe_type             smallint,
    pbe_cntr             integer,
    pbe_seqn             smallint                       not null,
    pbe_flag             integer,
    pbe_work             char(32),
    primary key (pbe_name, pbe_seqn)
);

create table pbcatedt 
(
    pbe_name             char(30)                       not null,
    pbe_edit             char(254),
    pbe_type             smallint,
    pbe_cntr             integer,
    pbe_seqn             smallint                       not null,
    pbe_flag             integer,
    pbe_work             char(32),
    primary key (pbe_name, pbe_seqn)
);

create table pbcatfmt 
(
    pbf_name             char(30)                       not null,
    pbf_frmt             char(254),
    pbf_type             smallint,
    pbf_cntr             integer,
    primary key (pbf_name)
);

create table pbcatfmt 
(
    pbf_name             char(30)                       not null,
    pbf_frmt             char(254),
    pbf_type             smallint,
    pbf_cntr             integer,
    primary key (pbf_name)
);

create table pbcattbl 
(
    pbt_tnam             char(129)                      not null,
    pbt_tid              integer,
    pbt_ownr             char(129)                      not null,
    pbd_fhgt             smallint,
    pbd_fwgt             smallint,
    pbd_fitl             char,
    pbd_funl             char,
    pbd_fchr             smallint,
    pbd_fptc             smallint,
    pbd_ffce             char(18),
    pbh_fhgt             smallint,
    pbh_fwgt             smallint,
    pbh_fitl             char,
    pbh_funl             char,
    pbh_fchr             smallint,
    pbh_fptc             smallint,
    pbh_ffce             char(18),
    pbl_fhgt             smallint,
    pbl_fwgt             smallint,
    pbl_fitl             char,
    pbl_funl             char,
    pbl_fchr             smallint,
    pbl_fptc             smallint,
    pbl_ffce             char(18),
    pbt_cmnt             char(254),
    primary key (pbt_tnam, pbt_ownr)
);

create table pbcattbl 
(
    pbt_tnam             char(129)                      not null,
    pbt_tid              integer,
    pbt_ownr             char(129)                      not null,
    pbd_fhgt             smallint,
    pbd_fwgt             smallint,
    pbd_fitl             char,
    pbd_funl             char,
    pbd_fchr             smallint,
    pbd_fptc             smallint,
    pbd_ffce             char(18),
    pbh_fhgt             smallint,
    pbh_fwgt             smallint,
    pbh_fitl             char,
    pbh_funl             char,
    pbh_fchr             smallint,
    pbh_fptc             smallint,
    pbh_ffce             char(18),
    pbl_fhgt             smallint,
    pbl_fwgt             smallint,
    pbl_fitl             char,
    pbl_funl             char,
    pbl_fchr             smallint,
    pbl_fptc             smallint,
    pbl_ffce             char(18),
    pbt_cmnt             char(254),
    primary key (pbt_tnam, pbt_ownr)
);

create table pbcatvld 
(
    pbv_name             char(30)                       not null,
    pbv_vald             char(254),
    pbv_type             smallint,
    pbv_cntr             integer,
    pbv_msg              char(254),
    primary key (pbv_name)
);

create table pbcatvld 
(
    pbv_name             char(30)                       not null,
    pbv_vald             char(254),
    pbv_type             smallint,
    pbv_cntr             integer,
    pbv_msg              char(254),
    primary key (pbv_name)
);

create table periodos_depre 
(
    no_activo            char(15)                       not null,
    year                 integer                        not null,
    compania             char(2)                        not null,
    tasa_depre           decimal(10,2)                  not null,
    status               char                           not null,
    primary key (no_activo, year, compania)
);

create table pla_informe 
(
    codigo_empleado      char(7)                        not null,
    compania             char(2)                        not null,
    salario_regular      decimal(10,2)                  not null,
    usuario              char(10)                       not null,
    salario_extra        decimal(10,2)                  not null,
    otros_salarios       decimal(10,2)                  not null,
    xiii                 decimal(10,2)                  not null,
    vacacion             decimal(10,2)                  not null,
    reembolso            decimal(10,2)                  not null,
    comisiones           decimal(10,2)                  not null,
    ayt                  decimal(10,2)                  not null,
    seguro_social        decimal(10,2)                  not null,
    seguro_educativo     decimal(10,2)                  not null,
    renta                decimal(10,2)                  not null,
    descuentos           decimal(10,2)                  not null,
    riesgos_profesionales decimal(10,2)                  not null,
    primary key (codigo_empleado, compania, usuario)
);

create table pla_vacacion1 
(
    codigo_empleado      char(7)                        not null,
    compania             char(2)                        not null,
    legal_desde          date                           not null,
    legal_hasta          date                           not null,
    status               char                           not null,
    primary key (codigo_empleado, compania, legal_desde)
);

create table pla_vacacion2 
(
    codigo_empleado      char(7)                        not null,
    compania             char(2)                        not null,
    legal_desde          date                           not null,
    pagar_desde          date                           not null,
    pagar_hasta          date                           not null,
    tiempo_desde         date                           not null,
    tiempo_hasta         date                           not null,
    primary key (codigo_empleado, compania, legal_desde, pagar_desde)
);

create table pla_xiii 
(
    desde                date                           not null,
    hasta                date                           not null,
    primary key (desde, hasta)
);

create table preventas 
(
    articulo             char(15)                       not null,
    almacen              char(2)                        not null,
    cliente              char(6)                        not null,
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    monto                decimal(10,2)                  not null,
    cantidad             decimal(10,2)                  not null,
    primary key (articulo, almacen, cliente, compania, aplicacion, year, periodo)
);

create table productos_sustitutos 
(
    articulo             char(15)                       not null,
    sustituto            char(15)                       not null,
    art_articulo         char(15),
    prioridad            integer                        not null,
    status               char                           not null,
    usuario              char(10)                       not null,
    fecha_captura        timestamp                      not null,
    primary key (articulo, sustituto)
);

create table rela_afi_cglposteo 
(
    codigo               char(15)                       not null,
    compania             char(2)                        not null,
    aplicacion           char(3)                        not null,
    year                 integer                        not null,
    periodo              integer                        not null,
    consecutivo          integer                        not null,
    primary key (codigo, compania, aplicacion, year, periodo, consecutivo)
);

create table rela_bcocheck1_cglposteo 
(
    cod_ctabco           char(2)                        not null,
    no_cheque            integer                        not null,
    motivo_bco           char(2)                        not null,
    consecutivo          integer                        not null,
    primary key (cod_ctabco, no_cheque, motivo_bco, consecutivo)
);

create table rela_bcotransac1_cglposteo 
(
    cod_ctabco           char(2)                        not null,
    sec_transacc         integer                        not null,
    consecutivo          integer                        not null,
    primary key (cod_ctabco, sec_transacc, consecutivo)
);

create table rela_caja_trx1_cglposteo 
(
    consecutivo          integer                        not null,
    numero_trx           integer                        not null,
    caja                 char(3)                        not null,
    primary key (consecutivo, numero_trx, caja)
);

create table rela_cxcfact1_cglposteo 
(
    consecutivo          integer                        not null,
    almacen              char(2)                        not null,
    no_factura           char(10)                       not null,
    primary key (consecutivo, almacen, no_factura)
);

create table rela_cxctrx1_cglposteo 
(
    consecutivo          integer                        not null,
    sec_ajuste_cxc       integer                        not null,
    almacen              char(2)                        not null,
    primary key (consecutivo, sec_ajuste_cxc, almacen)
);

create table rela_cxpajuste1_cglposteo 
(
    consecutivo          integer                        not null,
    compania             char(2)                        not null,
    sec_ajuste_cxp       integer                        not null,
    primary key (consecutivo, compania, sec_ajuste_cxp)
);

create table rela_cxpfact1_cglposteo 
(
    consecutivo          integer                        not null,
    proveedor            char(6)                        not null,
    fact_proveedor       char(10)                       not null,
    compania             char(2)                        not null,
    primary key (consecutivo, proveedor, fact_proveedor, compania)
);

create table rela_eys1_cglposteo 
(
    consecutivo          integer                        not null,
    almacen              char(2)                        not null,
    no_transaccion       integer                        not null,
    primary key (consecutivo, almacen, no_transaccion)
);

create table rela_factura1_cglposteo 
(
    consecutivo          integer                        not null,
    almacen              char(2)                        not null,
    tipo                 char(3)                        not null,
    num_documento        integer                        not null,
    primary key (consecutivo, almacen, tipo, num_documento)
);

create table rhuacre 
(
    cod_acreedores       char(5)                        not null,
    nombre_acreedores    char(40)                       not null,
    status               char                           not null default 'A'
          check (status in ('A','I')),
    telefono             char(15),
    direccion1           char(50),
    direccion2           char(50),
    direccion3           char(50),
    observacion          long varchar,
    primary key (cod_acreedores)
);

comment on table rhuacre is 'Tabla de Acreedores';

comment on column rhuacre.cod_acreedores is 'Código de identificacion de acreedores';

comment on column rhuacre.nombre_acreedores is 'Nombre de empresas acreedoras';

comment on column rhuacre.status is 'Estado del acreedor';

create table rhuacre2 
(
    cod_acreedores       char(5)                        not null,
    nombre_acreedores    char(40)                       not null,
    estado_acreedor      char                           default 'A'
          check (estado_acreedor is null or ( estado_acreedor in ('A','I') )),
    primary key (cod_acreedores)
);

comment on table rhuacre2 is 'Tabla de Acreedores';

comment on column rhuacre2.cod_acreedores is 'Código de identificacion de acreedores';

comment on column rhuacre2.nombre_acreedores is 'Nombre de empresas acreedoras';

comment on column rhuacre2.estado_acreedor is 'Estado del acreedor';

create table rhucargo 
(
    codigo_cargo         char(2)                        not null,
    descripcion_cargo    char(40)                       not null,
    primary key (codigo_cargo)
);

comment on table rhucargo is 'CARGO';

comment on column rhucargo.codigo_cargo is 'Código de cargo';

comment on column rhucargo.descripcion_cargo is 'Nombre del cargo';

create table rhuclvim 
(
    grup_impto_renta     char                           not null,
    num_dependiente      integer                        not null,
    deducible_basico     decimal(10,2)                  not null,
    deducible_x_esposa   decimal(10,2)                  not null,
    deducible_x_dependte decimal(10,2)                  not null,
    primary key (grup_impto_renta, num_dependiente)
);

comment on table rhuclvim is 'Clave de Impuesto sobre la renta';

comment on column rhuclvim.grup_impto_renta is 'Grupo de Impuesto sobre la renta';

comment on column rhuclvim.num_dependiente is 'Número de Dependientes Declarados';

comment on column rhuclvim.deducible_basico is 'Importe de Ducuble Básico';

comment on column rhuclvim.deducible_x_esposa is 'Importe deducible x Esposa';

comment on column rhuclvim.deducible_x_dependte is 'Deducible adicional por Dependiente';

create table rhudirec 
(
    cod_empleado         char(7),
    codigo_de_direccion  char                          
          check (codigo_de_direccion is null or ( codigo_de_direccion in ('Fisica','Postal','Correo Electrónico') )),
    direccion            varchar(300)
);

comment on column rhudirec.codigo_de_direccion is 'Direcciones del empleado';

create table rhuempl 
(
    codigo_empleado      char(7)                        not null,
    codigo_cargo         char(2),
    apellido_paterno     char(30),
    apellido_materno     char(30),
    apellido_casada      char(30),
    primer_nombre        char(30)                       not null,
    segundo_nombre       char(30),
    nombre_del_empleado  char(50),
    tipo_contrato        char                           not null,
    estado_civil         char                           not null,
    fecha_inicio         date                           not null,
    fecha_terminacion    date,
    fecha_nacimiento     date                           not null,
    fecha_ulti_aumento   date,
    tipo_de_salario      char                          
          check (tipo_de_salario is null or ( tipo_de_salario in ('F','H') )),
    salario_bruto        decimal(7,2)                   not null,
    rata_por_hora        decimal(6,2),
    monto_ult_aumento    decimal(7,2)                   not null,
    forma_de_pago        char                           not null
          check (forma_de_pago in ('E','C','T','N')),
    tipo_calculo_ir      char                          
          check (tipo_calculo_ir is null or ( tipo_calculo_ir in ('R','P','N') )),
    cod_id_turnos        char(2),
    cuenta               char(24),
    compania             char(2)                        not null,
    tipo_planilla        char(2)                        not null,
    grup_impto_renta     char                           not null,
    num_dependiente      integer                        not null,
    telefono_1           char(14),
    telefono_2           char(14),
    status               char                           not null
          check (status in ('A','I','V','L')),
    sexo_empleado        char                           not null
          check (sexo_empleado in ('M','F')),
    numero_cedula        char(15)                       not null,
    numero_ss            char(13),
    direccion1           char(50),
    direccion2           char(50),
    direccion3           char(50),
    direccion4           char(50),
    cta_bco_empleado     char(20),
    primary key (codigo_empleado, compania)
);

comment on table rhuempl is 'Empleado';

comment on column rhuempl.codigo_cargo is 'Código de cargo';

comment on column rhuempl.tipo_contrato is 'Tipo de contrato';

comment on column rhuempl.estado_civil is 'Estado civil';

comment on column rhuempl.forma_de_pago is 'Forma de pago al empleado';

comment on column rhuempl.tipo_planilla is 'Tipo de Planilla';

comment on column rhuempl.grup_impto_renta is 'Grupo de Impuesto sobre la renta';

comment on column rhuempl.num_dependiente is 'Número de Dependientes Declarados';

comment on column rhuempl.status is 'Estado del empleado';

comment on column rhuempl.sexo_empleado is 'Sexo';

comment on column rhuempl.numero_ss is 'Número del seguro social';

create table rhugremp 
(
    codigo_empleado      char(7)                        not null,
    codigo_valor_grupo   char(3)                        not null,
    compania             char(2)                        not null,
    primary key (codigo_empleado, codigo_valor_grupo)
);

comment on table rhugremp is 'agrupacion empleados';

create table rhuturno 
(
    cod_id_turnos        char(2)                        not null,
    hora_inicio_trabajo  time                           not null,
    hora_salida_trabajo  time                           not null,
    inicio_descanso      time,
    finalizar_descanso   time,
    tolerancia_de_entrada time,
    tolerancia_de_salida time,
    tolerancia_descanso  time,
    tipo_de_jornada      char                           not null
          check (tipo_de_jornada in ('D','N','M')),
    primary key (cod_id_turnos)
);

comment on table rhuturno is 'Turnos o jornada de trabajo';

create table rs_lastcommit 
(
    origin               integer                        not null,
    origin_qid           binary(36),
    secondary_qid        binary(36),
    origin_time          timestamp,
    commit_time          timestamp,
    primary key (origin)
);

create table rs_threads 
(
    id                   integer                        not null,
    seq                  integer,
    primary key (id)
);

create table rubros_fact_cxc 
(
    rubro_fact_cxc       char(15)                       not null,
    cuenta               char(24)                       not null,
    auxiliar1            char(10),
    auxiliar2            char(10),
    signo_rubro_fact_cxc integer                        not null
          check (signo_rubro_fact_cxc in (1,-1)),
    orden                integer                        not null,
    primary key (rubro_fact_cxc)
);

create table rubros_fact_cxp 
(
    rubro_fact_cxp       char(15)                       not null,
    cuenta               char(24)                       not null,
    auxiliar1            char(10),
    auxiliar2            char(10),
    signo_rubro_fact_cxp integer                        not null
          check (signo_rubro_fact_cxp in (1,-1)),
    orden                integer                        not null,
    primary key (rubro_fact_cxp)
);

create table saldo_de_proveedores 
(
    proveedor            char(6)                        not null,
    saldo                decimal(10,2)                  not null,
    fecha                date                           not null,
    primary key (proveedor)
);

create table tipo_de_empresa 
(
    tipo_empresa         char(2)                        not null,
    descripcion          char(40)                       not null,
    primary key (tipo_empresa)
);

comment on table tipo_de_empresa is 'Tipo de Empresa';

comment on column tipo_de_empresa.tipo_empresa is 'tipo_empresa';

comment on column tipo_de_empresa.descripcion is 'descripcion';

create table tipo_transacc 
(
    aplicacion           char(3)                        not null,
    tipo_transacc        char(2)                        not null,
    desc_tipo_transacc   char(40)                       not null,
    status               char                           not null,
    signo                integer                        not null
          check (signo in (1,-1)),
    primary key (aplicacion, tipo_transacc)
);

create table tipoauto 
(
    tipo_autorizacion    char(2)                        not null,
    desc_tipo_autoriza   char(40)                       not null,
    clase_autorizacion   char                           not null
          check (clase_autorizacion in ('A','M','N')),
    primary key (tipo_autorizacion)
);

create table tipoauto3 
(
    tipo_autorizacion    char(2)                        not null,
    desc_tipo_autoriza   char(40)                       not null,
    clase_autorizacion   char                           not null
          check (clase_autorizacion in ('A','M','N')),
    primary key (tipo_autorizacion)
);

create table tipocont 
(
    tipo_contenedor      char(2)                        not null,
    desc_contenedor      char(40)                       not null,
    tamano               decimal(10,2)                  not null,
    peso                 decimal(10,2)                  not null,
    carga_minima         decimal(10,2)                  not null,
    volument             decimal(10,2)                  not null,
    primary key (tipo_contenedor)
);

create table tipos_seguros 
(
    tipo_seguro          char(2)                        not null,
    descripcion          char                           not null,
    primary key (tipo_seguro)
);

create table trabajo 
(
    usuario              char(10)                       not null,
    codigo               char(40)                       not null,
    primary key (usuario, codigo)
);

alter table Activos
   add foreign key FK_ACTIVOS_REF_11044_MARCAS (marca)
      references Marcas (codigo)
      on update restrict
      on delete restrict;

alter table Activos
   add foreign key FK_ACTIVOS_REF_11046_AFI_GRUP (grupo)
      references afi_grupos_1 (codigo)
      on update restrict
      on delete restrict;

alter table Activos
   add foreign key FK_ACTIVOS_REF_11049_SECCIONE (departamento, seccion)
      references Secciones (codigo, seccion)
      on update restrict
      on delete restrict;

alter table Activos
   add foreign key FK_ACTIVOS_REF_11252_AFI_TIPO (tipo_activo)
      references afi_tipo_activo (codigo)
      on update restrict
      on delete restrict;

alter table Activos
   add foreign key FK_ACTIVOS_REF_12335_ACTIVOS (Act_codigo, compania)
      references Activos (codigo, compania)
      on update restrict
      on delete restrict;

alter table Articulos_Agrupados
   add foreign key FK_ARTICULO_REF_21604_GRAL_VAL (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on update cascade
      on delete cascade;

alter table articulos
   add foreign key FK_ARTICULO_REF_6133_UNIDAD_M (unidad_medida)
      references Unidad_Medida (unidad_medida)
      on update restrict
      on delete restrict;

alter table bcocheck2
   add foreign key FK_BCOCHECK_REF_38797_BCOCHECK (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on update cascade
      on delete cascade;

alter table bcocheck3
   add foreign key FK_BCOCHECK_REF_38804_BCOCHECK (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on update cascade
      on delete cascade;

alter table bcotransac2
   add foreign key FK_BCOTRANS_REF_29680_BCOTRANS (cod_ctabco, sec_transacc)
      references bcotransac1 (cod_ctabco, sec_transacc)
      on update cascade
      on delete cascade;

alter table bcotransac3
   add foreign key FK_BCOTRANS_REF_29684_BCOTRANS (cod_ctabco, sec_transacc)
      references bcotransac1 (cod_ctabco, sec_transacc)
      on update cascade
      on delete cascade;

alter table caja_trx2
   add foreign key FK_CAJA_TRX_REF_11562_CAJA_TRX (numero_trx, caja)
      references caja_trx1 (numero_trx, caja)
      on update cascade
      on delete cascade;

alter table cglcomprobante4
   add foreign key FK_CGLCOMPR_REF_3414_CGLCOMPR (linea, secuencia, compania, aplicacion, year, periodo)
      references cglcomprobante2 (linea, secuencia, compania, aplicacion, year, periodo)
      on update cascade
      on delete cascade;

alter table cglcomprobante3
   add foreign key FK_CGLCOMPR_REF_3433_CGLCOMPR (linea, secuencia, compania, aplicacion, year, periodo)
      references cglcomprobante2 (linea, secuencia, compania, aplicacion, year, periodo)
      on update cascade
      on delete cascade;

alter table cglcomprobante2
   add foreign key FK_CGLCOMPR_REF_7501_CGLCUENT (cuenta)
      references cglcuentas (cuenta)
      on update restrict
      on delete restrict;

alter table cglcomprobante2
   add foreign key FK_CGLCOMPR_REF_763_CGLCOMPR (secuencia, compania, aplicacion, year, periodo)
      references cglcomprobante1 (secuencia, compania, aplicacion, year, periodo)
      on update cascade
      on delete cascade;

alter table cglcomprobante1
   add foreign key FK_CGLCOMPR_REF_8110_CGLTIPOC (tipo_comp)
      references cgltipocomp (tipo_comp)
      on update restrict
      on delete restrict;

alter table cglperiodico2
   add foreign key FK_CGLPERIO_REF_9616_CGLPERIO (compania, secuencia)
      references cglperiodico1 (compania, secuencia)
      on update cascade
      on delete cascade;

alter table cglperiodico3
   add foreign key FK_CGLPERIO_REF_9936_CGLPERIO (compania, secuencia, linea)
      references cglperiodico2 (compania, secuencia, linea)
      on update cascade
      on delete cascade;

alter table cglperiodico4
   add foreign key FK_CGLPERIO_REF_9957_CGLPERIO (compania, secuencia, linea)
      references cglperiodico2 (compania, secuencia, linea)
      on update cascade
      on delete cascade;

alter table cglposteoaux1
   add foreign key FK_CGLPOSTE_REF_8370_CGLPOSTE (consecutivo)
      references cglposteo (consecutivo)
      on update cascade
      on delete cascade;

alter table cglposteoaux2
   add foreign key FK_CGLPOSTE_REF_8374_CGLPOSTE (consecutivo)
      references cglposteo (consecutivo)
      on update cascade
      on delete cascade;

alter table clientes
   add foreign key FK_CLIENTES_REF_45637_CLIENTES (cli_cliente)
      references clientes (cliente)
      on update cascade
      on delete cascade;

alter table cxcdocm
   add foreign key FK_CXCDOCM_REF_37303_CXCDOCM (docmto_aplicar, docmto_ref, cliente, motivo_ref, almacen)
      references cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen)
      on update cascade
      on delete cascade;

alter table cxcfact2
   add foreign key FK_CXCFACT2_REF_34072_CXCFACT1 (almacen, no_factura)
      references cxcfact1 (almacen, no_factura)
      on update cascade
      on delete cascade;

alter table cxcfact3
   add foreign key FK_CXCFACT3_REF_35585_CXCFACT1 (almacen, no_factura)
      references cxcfact1 (almacen, no_factura)
      on update cascade
      on delete cascade;

alter table cxctrx1
   add foreign key FK_CXCTRX1_REF_32495_CXCMOTIV (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on update restrict
      on delete restrict;

alter table cxctrx1
   add foreign key FK_CXCTRX1_REF_32499_CLIENTES (cliente)
      references clientes (cliente)
      on update restrict
      on delete restrict;

alter table cxctrx1
   add foreign key FK_CXCTRX1_REF_38779_ALMACEN (almacen)
      references Almacen (almacen)
      on update restrict
      on delete restrict;

alter table cxpajuste2
   add foreign key FK_CXPAJUST_REF_25787_CXPAJUST (compania, sec_ajuste_cxp)
      references cxpajuste1 (compania, sec_ajuste_cxp)
      on update cascade
      on delete cascade;

alter table cxpajuste3
   add foreign key FK_CXPAJUST_REF_25794_CXPAJUST (compania, sec_ajuste_cxp)
      references cxpajuste1 (compania, sec_ajuste_cxp)
      on update cascade
      on delete cascade;

alter table cxpdocm
   add foreign key FK_CXPDOCM_REF_25855_CXPDOCM (proveedor, compania, docmto_aplicar, docmto_aplicar_ref, motivo_cxp_ref)
      references cxpdocm (proveedor, compania, documento, docmto_aplicar, motivo_cxp)
      on update cascade
      on delete cascade;

alter table cxpfact2
   add foreign key FK_CXPFACT2_REF_22635_CXPFACT1 (proveedor, fact_proveedor, compania)
      references cxpfact1 (proveedor, fact_proveedor, compania)
      on update cascade
      on delete cascade;

alter table cxpfact2
   add foreign key FK_CXPFACT2_REF_22642_RUBROS_F (rubro_fact_cxp)
      references rubros_fact_cxp (rubro_fact_cxp)
      on update restrict
      on delete restrict;

alter table cxpfact2
   add foreign key FK_CXPFACT2_REF_54544_CGLAUXIL (auxiliar1)
      references cglauxiliares (auxiliar)
      on update restrict
      on delete restrict;

alter table cxpfact2
   add foreign key FK_CXPFACT2_REF_54548_CGLAUXIL (auxiliar2)
      references cglauxiliares (auxiliar)
      on update restrict
      on delete restrict;

alter table cxpfact2
   add foreign key FK_CXPFACT2_REF_64317_CGLCUENT (cuenta)
      references cglcuentas (cuenta)
      on update restrict
      on delete restrict;

alter table cxpfact3
   add foreign key FK_CXPFACT3_REF_22660_CXPFACT1 (proveedor, fact_proveedor, compania)
      references cxpfact1 (proveedor, fact_proveedor, compania)
      on update cascade
      on delete cascade;

alter table eys2
   add foreign key FK_EYS2_REF_14746_ARTICULO (articulo, almacen)
      references articulos_por_almacen (Articulo, almacen)
      on update restrict
      on delete restrict;

alter table eys2
   add foreign key FK_EYS2_REF_14753_EYS1 (almacen, no_transaccion)
      references eys1 (almacen, no_transaccion)
      on update cascade
      on delete cascade;

alter table eys3
   add foreign key FK_EYS3_REF_41979_EYS1 (almacen, no_transaccion)
      references eys1 (almacen, no_transaccion)
      on update cascade
      on delete cascade;

alter table factsobregiro
   add foreign key FK_FACTSOBR_REFERENCE_CLIENTES (cliente)
      references clientes (cliente)
      on update restrict
      on delete restrict;

alter table factura1
   add foreign key FK_FACTURA1_REF_10094_VENDEDOR (codigo_vendedor)
      references Vendedores (codigo)
      on update restrict
      on delete restrict;

alter table factura1
   add foreign key FK_FACTURA1_REF_99208_ALMACEN (almacen)
      references Almacen (almacen)
      on update restrict
      on delete restrict;

alter table factura1
   add foreign key FK_FACTURA1_REF_99219_FACTMOTI (tipo)
      references factmotivos (tipo)
      on update restrict
      on delete restrict;

alter table factura1
   add foreign key FK_FACTURA1_REF_99224_CLIENTES (cliente)
      references clientes (cliente)
      on update restrict
      on delete restrict;

alter table factura1
   add foreign key FK_FACTURA1_REF_99230_GRAL_FOR (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on update restrict
      on delete restrict;

alter table factura2
   add foreign key FK_FACTURA2_REF_10268_FACTURA1 (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on update cascade
      on delete cascade;

alter table factura2_eys2
   add foreign key FK_FACTURA2_REF_17353_EYS2 (articulo, almacen, no_transaccion, eys2_linea)
      references eys2 (articulo, almacen, no_transaccion, inv_linea)
      on update cascade
      on delete cascade;

alter table factura2_eys2
   add foreign key FK_FACTURA2_REF_17355_FACTURA2 (almacen, tipo, num_documento, factura2_linea)
      references factura2 (almacen, tipo, num_documento, linea)
      on update cascade
      on delete cascade;

alter table factura3
   add foreign key FK_FACTURA3_REF_10271_FACTURA2 (almacen, tipo, num_documento, linea)
      references factura2 (almacen, tipo, num_documento, linea)
      on update cascade
      on delete cascade;

alter table factura4
   add foreign key FK_FACTURA4_REF_10274_FACTURA1 (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on update cascade
      on delete cascade;

alter table factura5
   add foreign key FK_FACTURA5_REF_10849_FACTURA1 (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on update cascade
      on delete cascade;

alter table factura6
   add foreign key FK_FACTURA6_REF_10850_FACTURA1 (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on update cascade
      on delete cascade;

alter table factura7
   add foreign key FK_FACTURA7_REF_13516_FACTURA1 (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on update cascade
      on delete cascade;

alter table gralparametros
   add foreign key FK_GRALPARA_REF_20626_GRALAPLI (aplicacion)
      references gralaplicaciones (aplicacion)
      on update restrict
      on delete restrict;

alter table gralperiodos
   add foreign key FK_GRALPERI_REF_15380_GRALCOMP (compania)
      references gralcompanias (compania)
      on update restrict
      on delete restrict;

alter table gralsecxcia
   add foreign key FK_GRALSECX_REF_15383_GRALPERI (compania, aplicacion, year, periodo)
      references gralperiodos (compania, aplicacion, year, periodo)
      on update restrict
      on delete restrict;

alter table gral_valor_grupos
   add foreign key FK_GRAL_VAL_REF_20651_GRAL_GRU (grupo, aplicacion)
      references gral_grupos_aplicacion (grupo, aplicacion)
      on update cascade
      on delete cascade;

alter table gral_valor_grupos
   add foreign key FK_GRAL_VAL_REF_50384_GRAL_VAL (gra_codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on update cascade
      on delete cascade;

alter table invparal
   add foreign key FK_INVPARAL_REFERENCE_ALMACEN (almacen)
      references Almacen (almacen)
      on update restrict
      on delete restrict;

alter table invparal
   add foreign key FK_INVPARAL_REFERENCE_GRALPARA (parametro, aplicacion)
      references gralparametros (parametro, aplicacion)
      on update restrict
      on delete restrict;

alter table inv_conversion
   add foreign key FK_INV_CONV_REFERENCE_UNIDAD_M (convertir_d)
      references Unidad_Medida (unidad_medida)
      on update restrict
      on delete restrict;

alter table nomauta
   add foreign key FK_NOMAUTA_REF_19300_NOMHRTRA (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla)
      references nomhrtrab (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla)
      on update cascade
      on delete cascade;

alter table nomctrac
   add foreign key FK_NOMCTRAC_REF_20713_NOMTPLA2 (tipo_planilla, numero_planilla, desde)
      references nomtpla2 (tipo_planilla, numero_planilla, desde)
      on update restrict
      on delete restrict;

alter table nomdedu
   add foreign key FK_NOMDEDU_REF_20966_NOMPERIO (periodo)
      references nomperiodos (periodo)
      on update restrict
      on delete restrict;

alter table nomdescuentos
   add foreign key FK_NOMDESCU_REF_19800_NOMCTRAC (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla)
      on update cascade
      on delete cascade;

alter table nomextras
   add foreign key FK_NOMEXTRA_REF_19301_NOMHRTRA (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla)
      references nomhrtrab (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla)
      on update cascade
      on delete cascade;

alter table nomextras
   add foreign key FK_NOMEXTRA_REF_22271_NOMRECAR (recargo, tipo_d_dia)
      references nomrecargos (recargo, tipo_d_dia)
      on update restrict
      on delete restrict;

alter table nomhrtrab
   add foreign key FK_NOMHRTRA_REF_19299_RHUEMPL (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on update restrict
      on delete restrict;

alter table nomhrtrab
   add foreign key FK_NOMHRTRA_REF_19300_RHUTURNO (cod_id_turnos)
      references rhuturno (cod_id_turnos)
      on update restrict
      on delete restrict;

alter table nomhrtrab
   add foreign key FK_NOMHRTRA_REF_20711_NOMTPLA2 (tipo_planilla, numero_planilla, desde)
      references nomtpla2 (tipo_planilla, numero_planilla, desde)
      on update restrict
      on delete restrict;

alter table nomtpla2
   add foreign key FK_NOMTPLA2_REF_20710_NOMTPLA (tipo_planilla)
      references nomtpla (tipo_planilla)
      on update restrict
      on delete restrict;

alter table nomtpla2
   add foreign key FK_NOMTPLA2_REF_20965_NOMPERIO (periodo)
      references nomperiodos (periodo)
      on update restrict
      on delete restrict;

alter table nom_conceptos_para_calculo
   add foreign key FK_NOM_CONC_REF_21365_NOMCONCE (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on update restrict
      on delete restrict;

alter table nom_conceptos_para_calculo
   add foreign key FK_NOM_CONC_REF_657_NOMCONCE (concepto_aplica)
      references nomconce (cod_concepto_planilla)
      on update restrict
      on delete restrict;

alter table nom_otros_ingresos
   add foreign key FK_NOM_OTRO_REF_21621_NOM_TIPO (tipo_calculo)
      references nom_tipo_de_calculo (tipo_calculo)
      on update restrict
      on delete restrict;

alter table nom_otros_ingresos
   add foreign key FK_NOM_OTRO_REF_21622_NOMTPLA2 (tipo_planilla, numero_planilla, desde)
      references nomtpla2 (tipo_planilla, numero_planilla, desde)
      on update restrict
      on delete restrict;

alter table nom_otros_ingresos
   add foreign key FK_NOM_OTRO_REF_21623_RHUEMPL (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on update restrict
      on delete restrict;

alter table nom_otros_ingresos
   add foreign key FK_NOM_OTRO_REF_21624_NOMCONCE (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on update restrict
      on delete restrict;

alter table oc2
   add foreign key FK_OC2_REF_97841_OC1 (numero_oc, compania)
      references oc1 (numero_oc, compania)
      on update cascade
      on delete cascade;

alter table oc3
   add foreign key FK_OC3_REF_97834_OC1 (numero_oc, compania)
      references oc1 (numero_oc, compania)
      on update cascade
      on delete cascade;

alter table oc4
   add foreign key FK_OC4_REF_97827_OC1 (numero_oc, compania)
      references oc1 (numero_oc, compania)
      on update cascade
      on delete cascade;

alter table pla_informe
   add foreign key FK_PLA_INFO_REF_23421_RHUEMPL (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on update restrict
      on delete restrict;

alter table pla_vacacion1
   add foreign key FK_PLA_VACA_REF_23155_RHUEMPL (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on update restrict
      on delete restrict;

alter table pla_vacacion2
   add foreign key FK_PLA_VACA_REF_23156_PLA_VACA (codigo_empleado, compania, legal_desde)
      references pla_vacacion1 (codigo_empleado, compania, legal_desde)
      on update cascade
      on delete cascade;

alter table preventas
   add foreign key FK_PREVENTA_REFERENCE_ARTICULO (articulo, almacen)
      references articulos_por_almacen (Articulo, almacen)
      on update restrict
      on delete restrict;

alter table preventas
   add foreign key FK_PREVENTA_REFERENCE_CLIENTES (cliente)
      references clientes (cliente)
      on update restrict
      on delete restrict;

alter table preventas
   add foreign key FK_PREVENTA_REFERENCE_GRALPERI (compania, aplicacion, year, periodo)
      references gralperiodos (compania, aplicacion, year, periodo)
      on update restrict
      on delete restrict;

alter table Proveedores_Agrupados
   add foreign key FK_PROVEEDO_REF_51470_GRAL_VAL (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on update cascade
      on delete cascade;

alter table rela_bcocheck1_cglposteo
   add foreign key FK_RELA_BCO_REF_70271_BCOCHECK (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on update cascade
      on delete cascade;

alter table rela_bcocheck1_cglposteo
   add foreign key FK_RELA_BCO_REF_70281_CGLPOSTE (consecutivo)
      references cglposteo (consecutivo)
      on update cascade
      on delete cascade;

alter table rela_bcotransac1_cglposteo
   add foreign key FK_RELA_BCO_REF_70293_CGLPOSTE (consecutivo)
      references cglposteo (consecutivo)
      on update cascade
      on delete cascade;

alter table rela_cxcfact1_cglposteo
   add foreign key FK_RELA_CXC_REF_70298_CGLPOSTE (consecutivo)
      references cglposteo (consecutivo)
      on update cascade
      on delete cascade;

alter table rela_cxctrx1_cglposteo
   add foreign key FK_RELA_CXC_REF_71933_CGLPOSTE (consecutivo)
      references cglposteo (consecutivo)
      on update cascade
      on delete cascade;

alter table rela_cxpfact1_cglposteo
   add foreign key FK_RELA_CXP_REF_70310_CGLPOSTE (consecutivo)
      references cglposteo (consecutivo)
      on update cascade
      on delete cascade;

alter table rela_cxpajuste1_cglposteo
   add foreign key FK_RELA_CXP_REF_70325_CGLPOSTE (consecutivo)
      references cglposteo (consecutivo)
      on update cascade
      on delete cascade;

alter table rela_eys1_cglposteo
   add foreign key FK_RELA_EYS_REF_71945_CGLPOSTE (consecutivo)
      references cglposteo (consecutivo)
      on update cascade
      on delete cascade;

alter table rhuempl
   add foreign key FK_RHUEMPL_REF_19059_RHUCARGO (codigo_cargo)
      references rhucargo (codigo_cargo)
      on update restrict
      on delete restrict;

alter table rhuempl
   add foreign key FK_RHUEMPL_REF_19060_RHUTURNO (cod_id_turnos)
      references rhuturno (cod_id_turnos)
      on update restrict
      on delete restrict;

alter table rhuempl
   add foreign key FK_RHUEMPL_REF_19061_CGLCUENT (cuenta)
      references cglcuentas (cuenta)
      on update restrict
      on delete restrict;

alter table rhuempl
   add foreign key FK_RHUEMPL_REF_19295_GRALCOMP (compania)
      references gralcompanias (compania)
      on update restrict
      on delete restrict;

alter table rhuempl
   add foreign key FK_RHUEMPL_REF_19550_NOMTPLA (tipo_planilla)
      references nomtpla (tipo_planilla)
      on update restrict
      on delete restrict;

alter table rhuempl
   add foreign key FK_RHUEMPL_REF_20441_RHUCLVIM (grup_impto_renta, num_dependiente)
      references rhuclvim (grup_impto_renta, num_dependiente)
      on update restrict
      on delete restrict;

alter table saldo_de_proveedores
   add foreign key FK_SALDO_DE_REFERENCE_PROVEEDO (proveedor)
      references Proveedores (proveedor)
      on update restrict
      on delete restrict;

alter table cglcuentas
   add foreign key cglniveles (nivel)
      references cglniveles (nivel)
      on update restrict
      on delete restrict;

alter table afi_depreciacion
   add foreign key fk_afi_depr_ref_12215_activos (codigo, compania)
      references Activos (codigo, compania)
      on update restrict
      on delete restrict;

alter table afi_grupos_2
   add foreign key fk_afi_grup_ref_11045_afi_grup (codigo)
      references afi_grupos_1 (codigo)
      on update restrict
      on delete restrict;

alter table articulos_por_almacen
   add foreign key fk_articulo_ref_13279_almacen (almacen)
      references Almacen (almacen)
      on update restrict
      on delete restrict;

alter table bcobalance
   add foreign key fk_bcobalan_ref_31049_bcoctas (cod_ctabco)
      references bcoctas (cod_ctabco)
      on update restrict
      on delete restrict;

alter table bcocheck1
   add foreign key fk_bcocheck_ref_28311_bcoctas (cod_ctabco)
      references bcoctas (cod_ctabco)
      on update restrict
      on delete restrict;

alter table bcocheck1
   add foreign key fk_bcocheck_ref_28322_proveedo (proveedor)
      references Proveedores (proveedor)
      on update restrict
      on delete restrict;

alter table bcocheck3
   add foreign key fk_bcocheck_ref_28367_cxpmotiv (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on update restrict
      on delete restrict;

alter table bcocheck1
   add foreign key fk_bcocheck_ref_28380_bcomotiv (motivo_bco)
      references bcomotivos (motivo_bco)
      on update restrict
      on delete restrict;

alter table bcocircula
   add foreign key fk_bcocircu_ref_31026_bcoctas (cod_ctabco)
      references bcoctas (cod_ctabco)
      on update restrict
      on delete restrict;

alter table bcocircula
   add foreign key fk_bcocircu_ref_31032_bcomotiv (motivo_bco)
      references bcomotivos (motivo_bco)
      on update restrict
      on delete restrict;

alter table bcocircula
   add foreign key fk_bcocircu_ref_31042_proveedo (proveedor)
      references Proveedores (proveedor)
      on update restrict
      on delete restrict;

alter table bcoctas
   add foreign key fk_bcoctas_ref_27092_bancos (banco)
      references bancos (banco)
      on update restrict
      on delete restrict;

alter table bcotransac1
   add foreign key fk_bcotrans_ref_29665_bcoctas (cod_ctabco)
      references bcoctas (cod_ctabco)
      on update restrict
      on delete restrict;

alter table bcotransac1
   add foreign key fk_bcotrans_ref_30995_bcomotiv (motivo_bco)
      references bcomotivos (motivo_bco)
      on update restrict
      on delete restrict;

alter table bcotransac3
   add foreign key fk_bcotrans_ref_31001_cxpmotiv (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on update restrict
      on delete restrict;

alter table bcotransac1
   add foreign key fk_bcotrans_ref_31008_proveedo (proveedor)
      references Proveedores (proveedor)
      on update restrict
      on delete restrict;

alter table caja_trx1
   add foreign key fk_caja_trx_ref_11560_cajas (caja)
      references Cajas (caja)
      on update restrict
      on delete restrict;

alter table caja_trx1
   add foreign key fk_caja_trx_ref_11564_caja_tip (tipo_trx)
      references caja_tipo_trx (tipo_trx)
      on update restrict
      on delete restrict;

alter table cajas_balance
   add foreign key fk_cajas_ba_ref_11565_cajas (caja)
      references Cajas (caja)
      on update restrict
      on delete restrict;

alter table cglrecurrente
   add foreign key fk_cglrecur_ref_9596_cglperio (compania, secuencia)
      references cglperiodico1 (compania, secuencia)
      on update restrict
      on delete restrict;

alter table clientes
   add foreign key fk_clientes_ref_12001_vendedor (vendedor)
      references Vendedores (codigo)
      on update restrict
      on delete restrict;

alter table clientes
   add foreign key fk_clientes_ref_12572_listas_d (lista_de_precio)
      references listas_de_precio_1 (secuencia)
      on update restrict
      on delete restrict;

alter table clientes_agrupados
   add foreign key fk_clientes_ref_32439_clientes (cliente)
      references clientes (cliente)
      on update restrict
      on delete restrict;

alter table clientes_agrupados
   add foreign key fk_clientes_ref_32443_gral_val (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on update restrict
      on delete restrict;

alter table clientes
   add foreign key fk_clientes_ref_32463_gral_for (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on update restrict
      on delete restrict;

alter table cxcbalance
   add foreign key fk_cxcbalan_ref_32545_clientes (cliente)
      references clientes (cliente)
      on update restrict
      on delete restrict;

alter table cxcdocm
   add foreign key fk_cxcdocm_ref_37155_clientes (cliente)
      references clientes (cliente)
      on update restrict
      on delete restrict;

alter table cxcdocm
   add foreign key fk_cxcdocm_ref_37159_cxcmotiv (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on update restrict
      on delete restrict;

alter table cxcdocm
   add foreign key fk_cxcdocm_ref_37167_almacen (almacen)
      references Almacen (almacen)
      on update restrict
      on delete restrict;

alter table cxcfact1
   add foreign key fk_cxcfact1_ref_34059_clientes (cliente)
      references clientes (cliente)
      on update restrict
      on delete restrict;

alter table cxcfact1
   add foreign key fk_cxcfact1_ref_34063_almacen (almacen)
      references Almacen (almacen)
      on update restrict
      on delete restrict;

alter table cxcfact1
   add foreign key fk_cxcfact1_ref_34067_gral_for (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on update restrict
      on delete restrict;

alter table cxcfact1
   add foreign key fk_cxcfact1_ref_35603_cxcmotiv (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on update restrict
      on delete restrict;

alter table cxcfact2
   add foreign key fk_cxcfact2_ref_35592_rubros_f (rubro_fact_cxc)
      references rubros_fact_cxc (rubro_fact_cxc)
      on update restrict
      on delete restrict;

alter table cxcfact3
   add foreign key fk_cxcfact3_ref_38815_cxcmotiv (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on update restrict
      on delete restrict;

alter table cxcmorosidad
   add foreign key fk_cxcmoros_ref_86413_clientes (cliente)
      references clientes (cliente)
      on update restrict
      on delete restrict;

alter table cxcrecibo1
   add foreign key fk_cxcrecib_ref_38746_clientes (cliente)
      references clientes (cliente)
      on update restrict
      on delete restrict;

alter table cxcrecibo1
   add foreign key fk_cxcrecib_ref_38750_almacen (almacen)
      references Almacen (almacen)
      on update restrict
      on delete restrict;

alter table cxcrecibo1
   add foreign key fk_cxcrecib_ref_38754_cxcmotiv (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on update restrict
      on delete restrict;

alter table cxcrecibo2
   add foreign key fk_cxcrecib_ref_38758_cxcrecib (no_recibo, almacen)
      references cxcrecibo1 (no_recibo, almacen)
      on update restrict
      on delete restrict;

alter table cxcrecibo2
   add foreign key fk_cxcrecib_ref_38819_cxcmotiv (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on update restrict
      on delete restrict;

alter table cxctrx2
   add foreign key fk_cxctrx2_ref_38811_cxcmotiv (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on update restrict
      on delete restrict;

alter table cxpajuste1
   add foreign key fk_cxpajust_ref_23665_proveedo (proveedor)
      references Proveedores (proveedor)
      on update restrict
      on delete restrict;

alter table cxpajuste1
   add foreign key fk_cxpajust_ref_25851_cxpmotiv (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on update restrict
      on delete restrict;

alter table cxpajuste1
   add foreign key fk_cxpajust_ref_28363_cxpmotiv (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on update restrict
      on delete restrict;

alter table cxpajuste2
   add foreign key fk_cxpajust_ref_38823_cxpmotiv (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on update restrict
      on delete restrict;

alter table cxpbalance
   add foreign key fk_cxpbalan_ref_27054_proveedo (proveedor)
      references Proveedores (proveedor)
      on update restrict
      on delete restrict;

alter table cxpdocm
   add foreign key fk_cxpdocm_ref_25811_proveedo (proveedor)
      references Proveedores (proveedor)
      on update restrict
      on delete restrict;

alter table cxpdocm
   add foreign key fk_cxpdocm_ref_25843_cxpmotiv (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on update restrict
      on delete restrict;

alter table cxpdocm
   add foreign key fk_cxpdocm_ref_25882_cxpmotiv (motivo_cxp_ref)
      references cxpmotivos (motivo_cxp)
      on update restrict
      on delete restrict;

alter table cxpfact1
   add foreign key fk_cxpfact1_ref_22592_proveedo (proveedor)
      references Proveedores (proveedor)
      on update restrict
      on delete restrict;

alter table cxpfact1
   add foreign key fk_cxpfact1_ref_22597_gral_for (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on update restrict
      on delete restrict;

alter table cxpfact1
   add foreign key fk_cxpfact1_ref_22656_oc1 (numero_oc, oc1_compania)
      references oc1 (numero_oc, compania)
      on update restrict
      on delete restrict;

alter table cxpfact1
   add foreign key fk_cxpfact1_ref_25847_cxpmotiv (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on update restrict
      on delete restrict;

alter table cxpfact3
   add foreign key fk_cxpfact3_ref_38827_cxpmotiv (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on update restrict
      on delete restrict;

alter table cxpmorosidad
   add foreign key fk_cxpmoros_ref_91487_proveedo (proveedor)
      references Proveedores (proveedor)
      on update restrict
      on delete restrict;

alter table cxpmorosidad
   add foreign key fk_cxpmoros_ref_91503_cxpmotiv (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on update restrict
      on delete restrict;

alter table descuentos_por_grupo
   add foreign key fk_descuent_ref_10468_descuent (secuencia)
      references descuentos (secuencia)
      on update restrict
      on delete restrict;

alter table descuentos_por_cliente
   add foreign key fk_descuent_ref_10469_descuent (secuencia)
      references descuentos (secuencia)
      on update restrict
      on delete restrict;

alter table descuentos_por_grupo
   add foreign key fk_descuent_ref_10469_gral_val (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on update restrict
      on delete restrict;

alter table descuentos_por_articulo
   add foreign key fk_descuent_ref_10470_articulo (Articulo, almacen)
      references articulos_por_almacen (Articulo, almacen)
      on update restrict
      on delete restrict;

alter table descuentos_por_cliente
   add foreign key fk_descuent_ref_10470_clientes (cliente)
      references clientes (cliente)
      on update restrict
      on delete restrict;

alter table descuentos_por_articulo
   add foreign key fk_descuent_ref_10471_descuent (secuencia)
      references descuentos (secuencia)
      on update restrict
      on delete restrict;

alter table eys1
   add foreign key fk_eys1_ref_13993_almacen (almacen)
      references Almacen (almacen)
      on update restrict
      on delete restrict;

alter table eys1
   add foreign key fk_eys1_ref_14011_invmotiv (motivo)
      references invmotivos (motivo)
      on update restrict
      on delete restrict;

alter table facparamcgl
   add foreign key fk_facparam_ref_14735_almacen (almacen)
      references Almacen (almacen)
      on update restrict
      on delete restrict;

alter table facparamcgl
   add foreign key fk_facparam_ref_14735_gral_val (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on update restrict
      on delete restrict;

alter table factura2
   add foreign key fk_factura2_ref_10269_articulo (articulo, almacen)
      references articulos_por_almacen (Articulo, almacen)
      on update restrict
      on delete restrict;

alter table factura3
   add foreign key fk_factura3_ref_10273_impuesto (impuesto)
      references impuestos_facturacion (impuesto)
      on update restrict
      on delete restrict;

alter table factura4
   add foreign key fk_factura4_ref_10275_rubros_f (rubro_fact_cxc)
      references rubros_fact_cxc (rubro_fact_cxc)
      on update restrict
      on delete restrict;

alter table factura5
   add foreign key fk_factura5_ref_10850_bancos (banco)
      references bancos (banco)
      on update restrict
      on delete restrict;

alter table factura6
   add foreign key fk_factura6_ref_10851_bancos (banco)
      references bancos (banco)
      on update restrict
      on delete restrict;

alter table fisico1
   add foreign key fk_fisico1_ref_16179_almacen (almacen)
      references Almacen (almacen)
      on update restrict
      on delete restrict;

alter table fisico2
   add foreign key fk_fisico2_ref_16183_articulo (Articulo, almacen)
      references articulos_por_almacen (Articulo, almacen)
      on update restrict
      on delete restrict;

alter table fisico2
   add foreign key fk_fisico2_ref_16194_fisico1 (almacen, fecha, secuencia)
      references fisico1 (almacen, fecha, secuencia)
      on update restrict
      on delete restrict;

alter table funcionarios_proveedor
   add foreign key fk_funciona_ref_19659_proveedo (proveedor)
      references Proveedores (proveedor)
      on update restrict
      on delete restrict;

alter table funcionarios_cliente
   add foreign key fk_funciona_ref_32454_clientes (cliente)
      references clientes (cliente)
      on update restrict
      on delete restrict;

alter table gralsecxcia
   add foreign key fk_gralsecx_ref_714_gralsecu (aplicacion, parametro)
      references gralsecuencias (aplicacion, parametro)
      on update restrict
      on delete restrict;

alter table imp_oc
   add foreign key fk_imp_oc_ref_62804_gral_imp (impuesto)
      references gral_impuestos (impuesto)
      on update restrict
      on delete restrict;

alter table imp_oc
   add foreign key fk_imp_oc_ref_62808_rubros_f (rubro_fact_cxp)
      references rubros_fact_cxp (rubro_fact_cxp)
      on update restrict
      on delete restrict;

alter table impuestos_facturacion
   add foreign key fk_impuesto_ref_10272_gral_imp (impuesto)
      references gral_impuestos (impuesto)
      on update restrict
      on delete restrict;

alter table impuestos_facturacion
   add foreign key fk_impuesto_ref_10273_rubros_f (rubro_fact_cxc)
      references rubros_fact_cxc (rubro_fact_cxc)
      on update restrict
      on delete restrict;

alter table impuestos_por_grupo
   add foreign key fk_impuesto_ref_14223_gral_val (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on update restrict
      on delete restrict;

alter table impuestos_por_grupo
   add foreign key fk_impuesto_ref_14224_gral_imp (impuesto)
      references gral_impuestos (impuesto)
      on update restrict
      on delete restrict;

alter table invbalance
   add foreign key fk_invbalan_ref_27065_articulo (Articulo, almacen)
      references articulos_por_almacen (Articulo, almacen)
      on update restrict
      on delete restrict;

alter table invparal
   add foreign key fk_invparal_ref_38767_almacen (almacen)
      references Almacen (almacen)
      on update restrict
      on delete restrict;

alter table Listas_de_Precio_2
   add foreign key fk_listas_d_ref_10655_listas_d (secuencia)
      references listas_de_precio_1 (secuencia)
      on update restrict
      on delete restrict;

alter table Listas_de_Precio_2
   add foreign key fk_listas_d_ref_10656_articulo (Articulo, almacen)
      references articulos_por_almacen (Articulo, almacen)
      on update restrict
      on delete restrict;

alter table nomacrem
   add foreign key fk_nomacrem_ref_19292_rhuacre (cod_acreedores)
      references rhuacre (cod_acreedores)
      on update restrict
      on delete restrict;

alter table nomrelac
   add foreign key fk_nomrelac_ref_19294_nom_tipo (tipo_calculo)
      references nom_tipo_de_calculo (tipo_calculo)
      on update restrict
      on delete restrict;

alter table oc1
   add foreign key fk_oc1_ref_17828_proveedo (proveedor)
      references Proveedores (proveedor)
      on update restrict
      on delete restrict;

alter table oc1
   add foreign key fk_oc1_ref_17840_gral_for (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on update restrict
      on delete restrict;

alter table oc3
   add foreign key fk_oc3_ref_96514_imp_oc (impuesto)
      references imp_oc (impuesto)
      on update restrict
      on delete restrict;

alter table oc4
   add foreign key fk_oc4_ref_17874_otros_ca (tipo_de_cargo)
      references Otros_Cargos (tipo_de_cargo)
      on update restrict
      on delete restrict;

alter table Otros_Cargos
   add foreign key fk_otros_ca_ref_62799_rubros_f (rubro_fact_cxp)
      references rubros_fact_cxp (rubro_fact_cxp)
      on update restrict
      on delete restrict;

alter table Precios_por_Cliente_1
   add foreign key fk_precios__ref_10658_clientes (cliente)
      references clientes (cliente)
      on update restrict
      on delete restrict;

alter table Precios_por_Cliente_2
   add foreign key fk_precios__ref_10659_precios_ (secuencia)
      references Precios_por_Cliente_1 (secuencia)
      on update restrict
      on delete restrict;

alter table Precios_por_Cliente_2
   add foreign key fk_precios__ref_10660_articulo (Articulo, almacen)
      references articulos_por_almacen (Articulo, almacen)
      on update restrict
      on delete restrict;

alter table Proveedores_Agrupados
   add foreign key fk_proveedo_ref_21626_proveedo (proveedor)
      references Proveedores (proveedor)
      on update restrict
      on delete restrict;

alter table Proveedores
   add foreign key fk_proveedo_ref_22587_gral_for (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on update restrict
      on delete restrict;

alter table rela_afi_cglposteo
   add foreign key fk_rela_afi_ref_12218_afi_depr (codigo, compania, aplicacion, year, periodo)
      references afi_depreciacion (codigo, compania, aplicacion, year, periodo)
      on update restrict
      on delete restrict;

alter table rela_afi_cglposteo
   add foreign key fk_rela_afi_ref_12219_cglposte (consecutivo)
      references cglposteo (consecutivo)
      on update restrict
      on delete restrict;

alter table rela_bcotransac1_cglposteo
   add foreign key fk_rela_bco_ref_70286_bcotrans (cod_ctabco, sec_transacc)
      references bcotransac1 (cod_ctabco, sec_transacc)
      on update restrict
      on delete restrict;

alter table rela_caja_trx1_cglposteo
   add foreign key fk_rela_caj_ref_11997_cglposte (consecutivo)
      references cglposteo (consecutivo)
      on update restrict
      on delete restrict;

alter table rela_caja_trx1_cglposteo
   add foreign key fk_rela_caj_ref_11998_caja_trx (numero_trx, caja)
      references caja_trx1 (numero_trx, caja)
      on update restrict
      on delete restrict;

alter table rela_cxcfact1_cglposteo
   add foreign key fk_rela_cxc_ref_70302_cxcfact1 (almacen, no_factura)
      references cxcfact1 (almacen, no_factura)
      on update restrict
      on delete restrict;

alter table rela_cxpfact1_cglposteo
   add foreign key fk_rela_cxp_ref_70314_cxpfact1 (proveedor, fact_proveedor, compania)
      references cxpfact1 (proveedor, fact_proveedor, compania)
      on update restrict
      on delete restrict;

alter table rela_cxpajuste1_cglposteo
   add foreign key fk_rela_cxp_ref_70329_cxpajust (compania, sec_ajuste_cxp)
      references cxpajuste1 (compania, sec_ajuste_cxp)
      on update restrict
      on delete restrict;

alter table rela_eys1_cglposteo
   add foreign key fk_rela_eys_ref_71949_eys1 (almacen, no_transaccion)
      references eys1 (almacen, no_transaccion)
      on update restrict
      on delete restrict;

alter table rela_factura1_cglposteo
   add foreign key fk_rela_fac_ref_11999_cglposte (consecutivo)
      references cglposteo (consecutivo)
      on update restrict
      on delete restrict;

alter table rhugremp
   add foreign key fk_rhugremp_ref_19061_gral_val (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on update restrict
      on delete restrict;

alter table Secciones
   add foreign key fk_seccione_ref_11048_departam (codigo)
      references Departamentos (codigo)
      on update restrict
      on delete restrict;

