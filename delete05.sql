delete from bcocircula;
delete from rela_bcocheck1_cglposteo;
update bcocheck1 set motivo_bco = 'SO', status = 'R';
update bcotransac1 set status = 'R';

