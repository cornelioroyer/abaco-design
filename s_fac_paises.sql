select trim(fac_paises.pais) as pais, trim(fac_paises.nombre) as nombre_pais, 
trim(fac_ciudades.ciudad) as ciudad, trim(fac_ciudades.nombre) as nombre_ciudad
from fac_paises, fac_ciudades
where fac_paises.pais = fac_ciudades.pais
order by 1, 3
