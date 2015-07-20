select anio, mes, producto, sum(cantidad) from vtahist2 
where anio = 1990
group by anio, mes, producto
order by anio, mes
