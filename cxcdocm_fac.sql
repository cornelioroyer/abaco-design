create rule r_cxcdocm_fact on insert or delete or update to abaco_lock
do
    update factura1
	set documento = trim(cast(num_documento as char(10)))
	where documento is null or trim(documento) <> trim(cast(num_documento as char(10)));
