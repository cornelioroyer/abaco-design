update fax set pb_send = 'S' where pb_phnum1 in (select phone from cornelio.bftxl where status = 0);
commit;
