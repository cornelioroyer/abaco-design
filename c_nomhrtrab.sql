-- Table: nomhrtrab

-- DROP TABLE nomhrtrab;

CREATE TABLE nomhrtrab
(
  fecha_laborable date NOT NULL,
  codigo_empleado character(7) NOT NULL,
  compania character(2) NOT NULL,
  cod_id_turnos character(2) NOT NULL,
  tipo_planilla character(2) NOT NULL,
  numero_planilla integer NOT NULL,
  "year" integer NOT NULL,
  status character(1) NOT NULL,
  hora_de_inicio_trabajo time without time zone NOT NULL,
  hora_de_descanso_inicio time without time zone,
  hora_de_descanso_final time without time zone,
  hora_de_salida_trabajo time without time zone,
  usuario character(10) NOT NULL,
  fecha_actualiza timestamp with time zone NOT NULL,
  fecha_salida date NOT NULL,
  CONSTRAINT pk_nomhrtrab PRIMARY KEY (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla, fecha_salida),
  CONSTRAINT fk_nomhrtra_ref_192992_rhuempl FOREIGN KEY (codigo_empleado, compania)
      REFERENCES rhuempl (codigo_empleado, compania) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_nomhrtra_ref_193001_rhuturno FOREIGN KEY (cod_id_turnos)
      REFERENCES rhuturno (cod_id_turnos) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_nomhrtra_ref_207116_nomtpla2 FOREIGN KEY (tipo_planilla, numero_planilla, "year")
      REFERENCES nomtpla2 (tipo_planilla, numero_planilla, "year") MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (OIDS=FALSE);
ALTER TABLE nomhrtrab OWNER TO postgres;
COMMENT ON TABLE nomhrtrab IS 'Registro de Horas Trabajadas';

-- Index: i1_nomhrtrab

-- DROP INDEX i1_nomhrtrab;

CREATE UNIQUE INDEX i1_nomhrtrab
  ON nomhrtrab
  USING btree
  (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla, fecha_salida);

-- Index: i2_nomhrtrab

-- DROP INDEX i2_nomhrtrab;

CREATE INDEX i2_nomhrtrab
  ON nomhrtrab
  USING btree
  (codigo_empleado, compania);

-- Index: i3_nomhrtrab

-- DROP INDEX i3_nomhrtrab;

CREATE INDEX i3_nomhrtrab
  ON nomhrtrab
  USING btree
  (tipo_planilla, numero_planilla, year);

-- Index: i4_nomhrtrab

-- DROP INDEX i4_nomhrtrab;

CREATE INDEX i4_nomhrtrab
  ON nomhrtrab
  USING btree
  (cod_id_turnos);


-- Trigger: t_nomhrtrab_before_before on nomhrtrab

-- DROP TRIGGER t_nomhrtrab_before_before ON nomhrtrab;

CREATE TRIGGER t_nomhrtrab_before_before
  BEFORE UPDATE
  ON nomhrtrab
  FOR EACH ROW
  EXECUTE PROCEDURE f_nomhrtrab_before_update();

-- Trigger: t_nomhrtrab_before_delete on nomhrtrab

-- DROP TRIGGER t_nomhrtrab_before_delete ON nomhrtrab;

CREATE TRIGGER t_nomhrtrab_before_delete
  BEFORE DELETE
  ON nomhrtrab
  FOR EACH ROW
  EXECUTE PROCEDURE f_nomhrtrab_before_delete();

-- Trigger: t_nomhrtrab_before_insert on nomhrtrab

-- DROP TRIGGER t_nomhrtrab_before_insert ON nomhrtrab;

CREATE TRIGGER t_nomhrtrab_before_insert
  BEFORE INSERT
  ON nomhrtrab
  FOR EACH ROW
  EXECUTE PROCEDURE f_nomhrtrab_before_insert();

