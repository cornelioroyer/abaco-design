select count(*) a, pb_phnum1 from fax 
group by pb_phnum1
having a > 1
order by pb_phnum1
