alter table adc_house
add column cod_destino char(2) references destinos;


update adc_house
set cod_destino = '01';

alter table adc_house
alter column cod_destino set not null;
