select * from crosstab('select articulo, motivo, cantidad from v_eys1_eys2
where fecha >= ''2013-07-08'' order by 1, 2')
as v_eys1_eys2(articulo, motivo, cantidad)
