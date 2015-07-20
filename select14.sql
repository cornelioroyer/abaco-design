update fax set pb_lname = 'GERENTE FINANCIERO';
commit;
select pb_lname, pb_company, pb_phnum1 from fax where pb_send = 'N' and tipo_cliente = 1 order by pb_company;
output to c:\bitware\fax3.dbf format dbaseiii;
