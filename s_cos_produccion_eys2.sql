select f_cos_produccion_eys2(cos_produccion.compania, cos_produccion.secuencia,
cos_produccion.linea)
from cos_trx, cos_produccion
where cos_trx.compania = cos_produccion.compania
and cos_trx.secuencia = cos_produccion.secuencia
and cos_trx.fecha >= '2006-04-01';
