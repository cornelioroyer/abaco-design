 SELECT  dba.bcocheck1.cod_ctabco ,          
 dba.bcocheck1.no_cheque ,          
 dba.bcocheck1.proveedor ,          
 dba.bcocheck1.motivo_bco 
    FROM dba.bcocheck1 ,           dba.bcocheck2    
 WHERE dba.bcocheck1.cod_ctabco = '11'
 and dba.bcocheck1.motivo_bco = 'CK' 
and ( dba.bcocheck1.no_cheque = 13) 
AND  ( dba.bcocheck2.cod_ctabco = dba.bcocheck1.cod_ctabco )
 and          ( dba.bcocheck2.no_cheque = dba.bcocheck1.no_cheque ) 
and          ( dba.bcocheck2.motivo_bco = dba.bcocheck1.motivo_bco ) 
 ORDER BY dba.bcocheck1.no_cheque          ASC 
