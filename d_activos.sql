update gralperiodos
set estado = 'A';

begin work;
    delete from afi_trx1;
commit work;

begin work;
delete from afi_depreciacion;
commit work;


delete from activos;