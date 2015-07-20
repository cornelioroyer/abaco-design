select count(*) from clientes;
select cliente from clientes 
where cliente not in (select cliente from cxcdocm
group by cliente)
order by cliente;
