update fax set pb_send = 'X' where pb_phnum1 in (select phone from cornelio.bftxl );
commit;
