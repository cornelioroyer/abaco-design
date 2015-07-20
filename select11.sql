select cliente from clientes 
where cliente not in 
(select cliente from factura1, gral_forma_de_pago