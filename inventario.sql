
drop table proveedor;
create table proveedores
(
 proveedor integer not null primary key,
 Nombre char(30) not null,
 Direccion char(30) not null,
 Ciudad char(16),
 Estado char(2),
 Apartado char(10),
 Telefono char(15),
 Contacto char(30)
);


create table almacen
(
 almacen integer not null primary key,
 nombre char(30) not null,
 direccion char(30) not null,
 ciudad char(16) not  null,
 estado char(2) not null,
 apartado char(10),
 telefono char(15),
 contacto char(30)
);


create table articulos
(
articulo integer not null primary key,
descripcion char(30),
precio_compra decimal(7,2) not null,
precio_venta decimal(10,2) not null,
almacen integer references almacen,
proveedor integer references proveedores
);

create table clientes
(
cliente integer primary key,
nombre char(30),
direccion1 char(30),
direccion2 char(30),
Ciudad char(16),
Estado char(2),
Apartado char(10),
Telefono char(15),
Contacto char(30)
);

create table facturas
(
factura integer primary key,
fecha date,
cliente integer references clientes,
impuesto decimal(7,2) not null,
cargo_misc decimal(7,2) not null,
freight decimal(7,2) not null,
comentarios char(200)
);


create table lineas_factura
(
factura integer references facturas,
articulo integer references articulos,
cantidad integer not null,
primary key(factura, articulo)
);



