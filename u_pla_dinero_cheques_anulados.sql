
update pla_dinero
set id_pla_cheques_1 = null
where id_pla_cheques_1 in
    (select id from pla_cheques_1
    where status = 'A');

