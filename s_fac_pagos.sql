select fac_pagos.* from factura1, fac_pagos
where factura1.almacen = fac_pagos.almacen
and factura1.tipo = fac_pagos.tipo
and factura1.num_documento = fac_pagos.num_documento
and factura1.sec_z = 47