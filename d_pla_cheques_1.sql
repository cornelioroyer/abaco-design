

begin work;
update pla_cheques_1 
set status = 'A'
from pla_bancos
where pla_cheques_1.id_pla_bancos = pla_bancos.id
and pla_bancos.compania = 1263;
commit work;




delete from pla_cheques_1 using pla_bancos
where pla_cheques_1.id_pla_bancos = pla_bancos.id
and pla_bancos.compania = 1263;
