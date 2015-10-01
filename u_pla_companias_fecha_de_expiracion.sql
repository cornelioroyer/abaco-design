set search_path to planilla;

update pla_companias
set fecha_de_expiracion = '2300-07-01'
where compania in (1286, 1287, 1288, 1289, 1290, 1292, 1293, 1294, 1295, 1296, 1297, 1298, 1299, 1300, 1302, 1303, 1305, 1321, 1322, 1340, 1347, 1359);
