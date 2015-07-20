select 'unload from table '+table_name+' to ''c:\tmp\'+table_name+'.dat'';'  from systable where table_name not like 'sys%' 
order by table_id ;
output to c:\abaco\design\unload03.sql format text;




