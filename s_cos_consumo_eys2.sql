select f_cos_consumo_eys2(cos_consumo.compania, cos_consumo.secuencia,
cos_consumo.linea)
from cos_trx, cos_consumo
where cos_trx.compania = cos_consumo.compania
and cos_trx.secuencia = cos_consumo.secuencia
and cos_trx.fecha >= '2006-04-01';
