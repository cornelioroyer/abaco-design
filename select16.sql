select 'load into table '+table_name+' from ''c:\tmp\'+table_name+'.dat'';'  from systable
where table_name not like 'sys%' order by file_id ;
output to c:\abaco\design\load02.sql format text;




