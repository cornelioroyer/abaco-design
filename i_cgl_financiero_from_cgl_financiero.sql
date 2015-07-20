insert into cgl_financiero (no_informe, cuenta, d_fila)
select 20, cuenta, d_fila
from cgl_financiero
where no_informe = 14;
