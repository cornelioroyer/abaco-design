update gralperiodos set estado = 'A';
update nomtpla2 set status = 'A';


delete from pla_no_marcaron;
delete from plapermisos;
begin work;
    delete from pla_riesgos_profesionales;
    delete from placertificadosmedico;
    delete from pla_preelaborada;
    delete from pla_vacacion1;
    delete from pla_constancias;
    delete from pla_ajuste_renta;
    delete from nom_otros_ingresos;
    delete from pla_certificados;
    delete from pla_permisos;
commit work;

delete from rhuturno_x_dia;
delete from pla_work1;
delete from plapermisosindical;
delete from plareemplazos;
begin work;
delete from pla_vacacion;
delete from pla_reloj;
delete from pla_fondo_de_cesantia;
commit work;
begin work;
delete from nomhrtrab;
delete from pla_extemporaneo;
commit work;

delete from pla_desglose_planilla;
begin work;
delete from nomctrac;
commit work;

delete from pla_saldo_acreedores;
delete from nomacrem;
delete from rhuempl;