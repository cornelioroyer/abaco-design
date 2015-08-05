			delete from factura1
			where factura1.tipo in (select tipo from factmotivos where cotizacion = 'S') 
			and almacen in (select almacen from almacen where compania = '03')
