
drop function f_months_between(date, date) cascade;

create function f_months_between(date, date) returns integer as '
declare
    ad_start alias for $1;
    ad_end alias for $2;
    li_month integer;
begin 

li_month = (Anio(ad_end) - Anio(ad_start) ) * 12;
return li_month + Mes(ad_end) - Mes(ad_start);

end;
' language plpgsql;



/*
date 		ld_temp
integer 	li_month
integer	li_mult

//Check parameters
If IsNull(ad_start) or IsNull(ad_end) or &
	Not of_IsValid(ad_start) or Not of_IsValid(ad_end) Then
	long ll_null
	SetNull(ll_null)
	Return ll_null
End If

If ad_start > ad_end Then
	ld_temp = ad_start
	ad_start = ad_end
	ad_end = ld_temp
	li_mult = -1
else
	li_mult = 1
End If

li_month = (year(ad_end) - year(ad_start) ) * 12
li_month = li_month + month(ad_end) - month(ad_start)

If day(ad_start) > day(ad_end) Then 
	li_month --
End If

Return li_month * li_mult
*/

