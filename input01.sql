begin transaction;
delete from cglcomprobante1
where compania = '03' and year = 1999 and periodo = 12;
INPUT INTO cglcomprobante1 FROM c:\abaco\data\cglcomp1.txt FORMAT ASCII;
INPUT INTO cglcomprobante2 FROM c:\abaco\data\cglcomp2.txt FORMAT ASCII;
INPUT INTO cglcomprobante3 FROM c:\abaco\data\cglcomp3.txt FORMAT ASCII;
INPUT INTO cglcomprobante4 FROM c:\abaco\data\cglcomp4.txt FORMAT ASCII;
commit;
select * from cglcomprobante1 where compania = '03' order by fecha_comprobante desc;



