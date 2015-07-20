
drop function f_relative_mes(date, integer);

create function f_relative_mes(date, integer) returns date as '
declare
    ad_fecha alias for $1;
    ai_meses alias for $2;
    ld_retorno date;
    li_work int4;
    li_temp_month int4;
    li_adjust_months int4;
    li_adjust_years int4;
    li_year int4;
    li_month int4;
    li_day int4;
    ls_sql varchar(300);
begin
    ld_retorno = ad_fecha;

    if ai_meses = 0 then
        return ad_fecha;
    end if;

    if ai_meses > 0 then
        li_adjust_months = mod(ai_meses, 12);
        li_adjust_years = (ai_meses / 12);
        li_temp_month = Mes(ad_fecha) + li_adjust_months;
    
        If li_temp_month > 12 Then
        	li_month = li_temp_month - 12;
        	li_adjust_years = li_adjust_years + 1;
        elsif li_temp_month <= 0 Then
        	li_month = li_temp_month + 12;
        	li_adjust_years = li_adjust_years + 1;
        Else
        	li_month = li_temp_month;
        End If;
        li_year = Anio(ad_fecha) + li_adjust_years;
        li_day = extract (day from ad_fecha);


        If li_day > f_days_in_month(li_month) Then
        	If li_month = 2 and f_isleapyear(li_year) Then
        		li_day = 29;
        	Else
        		li_day = f_days_in_month(li_month);
        	end If;
        End IF;
    
        ld_retorno = f_to_date(li_year,li_month,li_day);
    else
        li_adjust_months = mod(ai_meses, 12);
        li_adjust_years = (ai_meses / 12);
        li_temp_month = Mes(ad_fecha) + li_adjust_months;
    
        If li_temp_month > 12 Then
        	li_month = li_temp_month - 12;
        	li_adjust_years = li_adjust_years + 1;
        elsif li_temp_month <= 0 Then
            if ai_meses <= -12 then
            	li_month = li_temp_month + 12;
            	li_adjust_years = li_adjust_years + 1;
            else
            	li_month = li_temp_month + 12;
                li_adjust_years = -1;
            end if;
        Else
        	li_month = li_temp_month;
        End If;
        li_year = Anio(ad_fecha) + li_adjust_years;
        li_day = extract (day from ad_fecha);

        If li_day > f_days_in_month(li_month) Then
        	If li_month = 2 and f_isleapyear(li_year) Then
        		li_day = 29;
        	Else
        		li_day = f_days_in_month(li_month);
        	end If;
        End IF;
    
        ld_retorno = f_to_date(li_year,li_month,li_day);
    end if;    
    
    return ld_retorno;
end;
' language plpgsql;


select '12 mesees   ' || f_relative_mes(current_date, -13);

select '6 mesees   ' || f_relative_mes(current_date, -6);


