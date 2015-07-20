



begin work;
delete from pla_auxiliares
where compania in 
(select compania from pla_companias
where e_mail in ('cornelioroyer@winsof.com','cornelioroyer@hotmail.com'));
commit work;

begin work;
delete from pla_cheques_1 using pla_bancos
where pla_cheques_1.id_pla_bancos = pla_bancos.id
and pla_bancos.compania in 
(select compania from pla_companias
where e_mail in ('cornelioroyer@winsof.com','cornelioroyer@hotmail.com'));

delete from pla_bancos
where compania in 
(select compania from pla_companias
where e_mail in ('cornelioroyer@winsof.com','cornelioroyer@hotmail.com'));

commit work;

delete from pla_deducciones
where exists (select * from pla_retenciones, pla_companias
where pla_retenciones.compania = pla_companias.compania
and pla_companias.e_mail in ('cornelioroyer@winsof.com','cornelioroyer@hotmail.com'));


delete from pla_retenciones
where compania in (select compania from pla_companias
where e_mail in ('cornelioroyer@winsof.com','cornelioroyer@hotmail.com'));


delete from users
where username in ('cornelioroyer@winsof.com','cornelioroyer@hotmail.com');

delete from pla_retenciones
where compania in 
(select compania from pla_companias
where e_mail in ('cornelioroyer@winsof.com','cornelioroyer@hotmail.com'));

delete from pla_acreedores
where compania in 
(select compania from pla_companias
where e_mail in ('cornelioroyer@winsof.com','cornelioroyer@hotmail.com'));
commit work;

begin work;
delete from pla_parametros_contables
where compania in 
(select compania from pla_companias
where e_mail in ('cornelioroyer@winsof.com','cornelioroyer@hotmail.com'));


delete from pla_dias_feriados
where compania in 
(select compania from pla_companias
where e_mail in ('cornelioroyer@winsof.com','cornelioroyer@hotmail.com'));
commit work;


begin work;
delete from pla_parametros_x_cia
where compania in 
(select compania from pla_companias
where e_mail in ('cornelioroyer@winsof.com','cornelioroyer@hotmail.com'));

delete from pla_cuentas
where compania in 
(select compania from pla_companias
where e_mail in ('cornelioroyer@winsof.com','cornelioroyer@hotmail.com'));
commit work;



delete from pla_companias
where e_mail in ('cornelioroyer@winsof.com','cornelioroyer@hotmail.com');