update fax
set pb_send = 'S'
where trim(pb_phnum1) in 
(select trim(fax) from enviados)