delete from cgl_financiero where no_informe = 15;
insert into cgl_financiero(no_informe, cuenta, d_fila)
select 15, cuenta, '4606'
from cgl_financiero
where no_informe = 14;

delete from cgl_financiero
where no_informe = 15
and cuenta in (select cuenta from cgl_financiero where no_informe = 16);
