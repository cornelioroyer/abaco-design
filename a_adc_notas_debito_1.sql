
begin work;
alter table adc_notas_debito_1 add column observacion_1 char(60);
alter table adc_notas_debito_1 add column observacion_2 char(60);
alter table adc_notas_debito_1 add column observacion_3 char(60);
alter table adc_notas_debito_1 add column observacion_4 char(60);

update adc_notas_debito_1
set observacion_1 = observacion;

alter table adc_notas_debito_1 drop column observacion;

commit work;
