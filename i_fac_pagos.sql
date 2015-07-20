insert into fac_pagos
select almacen, tipo, num_documento, 1, 0, null
from factura1
where not exists
(select * from fac_pagos
where fac_pagos.almacen = factura1.almacen
and fac_pagos.tipo = factura1.tipo
and fac_pagos.num_documento = factura1.num_documento)