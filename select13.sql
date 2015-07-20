select '03', pb_phnum1 from fax;
output to c:\abaco\data\fax_compania.txt;
delete from fax_compania;
load table fax_compania from 'c:\abaco\data\fax_compania.txt';
commit;
