select sum(cxpdocm.monto*cxpmotivos.signo) from cxpdocm, cxpmotivos
where cxpdocm.motivo_cxp = cxpmotivos.motivo_cxp and
cxpdocm.fecha_posteo <= '2000-12-31';

select sum(debito-credito) from cglposteo where fecha_comprobante <= '2000-12-31' 
and cuenta = '20501';
