delete from proveedores;
insert into proveedores(proveedor, nomb_proveedor,
forma_pago, cuenta, tel1_proveedor, fax_proveedor, id_proveedor,
dv_proveedor, status, usuario, limite_credito,
fecha_apertura, direccion1, direccion3, fecha_captura)
select trim(codigo), nombre, '30', '2200110', telefono, fax, 
substring(ruc from 1 for 20), '00', 'A', 
current_user, 
0, current_date, direccion1, contacto1,
current_timestamp
from tmp_proveedores
