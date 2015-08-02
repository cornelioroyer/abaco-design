select * from mail_mass_mailing_contact
where trim(email) like '%arnau%';

select * from mail_mass_mailing_contact
where opt_out = 1;
