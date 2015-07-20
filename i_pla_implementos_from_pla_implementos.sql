insert into pla_implementos(compania, implemento, concepto, descripcion, recargo, status)
select 1324, implemento, concepto, descripcion, recargo, status
from pla_implementos
where compania in (1142);
