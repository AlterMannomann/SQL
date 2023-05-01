--------------------------------------------------------
--  Datei erstellt -Freitag-April-21-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Sequence USIM_OVR_ID_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "USIM"."USIM_OVR_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence USIM_PDI_ID_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "USIM"."USIM_PDI_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence USIM_POS_ID_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "USIM"."USIM_POS_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence USIM_SPO_ID_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "USIM"."USIM_SPO_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Table USIM_OVERFLOW
--------------------------------------------------------

  CREATE TABLE "USIM"."USIM_OVERFLOW" 
   (	"USIM_ID_OVR" NUMBER(38,0), 
	"USIM_ENERGY" NUMBER, 
	"USIM_AMPLITUDE" NUMBER, 
	"USIM_WAVELENGTH" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "WORK" ;

   COMMENT ON TABLE "USIM"."USIM_OVERFLOW"  IS 'Keeps overflows of space point. Will use the alias ovr.';
--------------------------------------------------------
--  DDL for Table USIM_POINT_DIMENSION
--------------------------------------------------------

  CREATE TABLE "USIM"."USIM_POINT_DIMENSION" 
   (	"USIM_ID_PDI" NUMBER(38,0), 
	"USIM_DIMENSION" NUMBER(2,0)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "WORK" ;

   COMMENT ON COLUMN "USIM"."USIM_POINT_DIMENSION"."USIM_DIMENSION" IS 'The n-sphere dimension 0-99 for space points';
   COMMENT ON TABLE "USIM"."USIM_POINT_DIMENSION"  IS 'Keeps the possible dimensions. Will use the alias pdi.';
--------------------------------------------------------
--  DDL for Table USIM_POSITION
--------------------------------------------------------

  CREATE TABLE "USIM"."USIM_POSITION" 
   (	"USIM_ID_POS" NUMBER(38,0), 
	"USIM_POSITION" NUMBER(38,0)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "WORK" ;
--------------------------------------------------------
--  DDL for Table USIM_SPACE_POINT
--------------------------------------------------------

  CREATE TABLE "USIM"."USIM_SPACE_POINT" 
   (	"USIM_ID_SPO" NUMBER(38,0), 
	"USIM_ENERGY" NUMBER, 
	"USIM_AMPLITUDE" NUMBER, 
	"USIM_WAVELENGTH" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "WORK" ;

   COMMENT ON COLUMN "USIM"."USIM_SPACE_POINT"."USIM_ID_SPO" IS 'Generic ID to identify a space point.';
   COMMENT ON COLUMN "USIM"."USIM_SPACE_POINT"."USIM_ENERGY" IS 'The current energy of the space point.';
   COMMENT ON COLUMN "USIM"."USIM_SPACE_POINT"."USIM_AMPLITUDE" IS 'The current amplitude of the space point.';
   COMMENT ON COLUMN "USIM"."USIM_SPACE_POINT"."USIM_WAVELENGTH" IS 'The current wavelength of the space point.';
   COMMENT ON TABLE "USIM"."USIM_SPACE_POINT"  IS 'Keeps all space points with their energy attributes. Will use the alias spo.';
--------------------------------------------------------
--  DDL for Index USIM_PDI_UK
--------------------------------------------------------

  CREATE UNIQUE INDEX "USIM"."USIM_PDI_UK" ON "USIM"."USIM_POINT_DIMENSION" ("USIM_DIMENSION") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "WORK" ;
--------------------------------------------------------
--  DDL for Index USIM_PDI_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "USIM"."USIM_PDI_PK" ON "USIM"."USIM_POINT_DIMENSION" ("USIM_ID_PDI") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "WORK" ;
--------------------------------------------------------
--  DDL for Index USIM_OVR_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "USIM"."USIM_OVR_PK" ON "USIM"."USIM_OVERFLOW" ("USIM_ID_OVR") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "WORK" ;
--------------------------------------------------------
--  DDL for Index USIM_SPO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "USIM"."USIM_SPO_PK" ON "USIM"."USIM_SPACE_POINT" ("USIM_ID_SPO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "WORK" ;
--------------------------------------------------------
--  DDL for Index USIM_POS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "USIM"."USIM_POS_PK" ON "USIM"."USIM_POSITION" ("USIM_ID_POS") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "WORK" ;
--------------------------------------------------------
--  DDL for Trigger USIM_OVR_ID_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "USIM"."USIM_OVR_ID_TRG" 
  BEFORE INSERT ON usim_overflow 
    FOR EACH ROW 
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_ovr IS NULL 
        THEN
          SELECT usim_ovr_id_seq.NEXTVAL INTO :NEW.usim_id_ovr FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;

/
ALTER TRIGGER "USIM"."USIM_OVR_ID_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger USIM_PDI_ID_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "USIM"."USIM_PDI_ID_TRG" 
  BEFORE INSERT ON usim_point_dimension 
    FOR EACH ROW 
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_pdi IS NULL 
        THEN
          SELECT usim_pdi_id_seq.NEXTVAL INTO :NEW.usim_id_pdi FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;

/
ALTER TRIGGER "USIM"."USIM_PDI_ID_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger USIM_POS_ID_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "USIM"."USIM_POS_ID_TRG" 
  BEFORE INSERT ON usim_position 
    FOR EACH ROW 
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_pos IS NULL 
        THEN
          SELECT usim_pos_id_seq.NEXTVAL INTO :NEW.usim_id_pos FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;

/
ALTER TRIGGER "USIM"."USIM_POS_ID_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger USIM_SPO_ID_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "USIM"."USIM_SPO_ID_TRG" 
  BEFORE INSERT ON usim_space_point 
    FOR EACH ROW 
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_spo IS NULL 
        THEN
          SELECT usim_spo_id_seq.NEXTVAL INTO :NEW.usim_id_spo FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;

/
ALTER TRIGGER "USIM"."USIM_SPO_ID_TRG" ENABLE;
--------------------------------------------------------
--  Constraints for Table USIM_POINT_DIMENSION
--------------------------------------------------------

  ALTER TABLE "USIM"."USIM_POINT_DIMENSION" MODIFY ("USIM_ID_PDI" NOT NULL ENABLE);
  ALTER TABLE "USIM"."USIM_POINT_DIMENSION" MODIFY ("USIM_DIMENSION" NOT NULL ENABLE);
  ALTER TABLE "USIM"."USIM_POINT_DIMENSION" ADD CONSTRAINT "USIM_PDI_PK" PRIMARY KEY ("USIM_ID_PDI")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "WORK"  ENABLE;
  ALTER TABLE "USIM"."USIM_POINT_DIMENSION" ADD CONSTRAINT "USIM_PDI_UK" UNIQUE ("USIM_DIMENSION")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "WORK"  ENABLE;
--------------------------------------------------------
--  Constraints for Table USIM_SPACE_POINT
--------------------------------------------------------

  ALTER TABLE "USIM"."USIM_SPACE_POINT" MODIFY ("USIM_ID_SPO" NOT NULL ENABLE);
  ALTER TABLE "USIM"."USIM_SPACE_POINT" ADD CONSTRAINT "USIM_SPO_PK" PRIMARY KEY ("USIM_ID_SPO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "WORK"  ENABLE;
--------------------------------------------------------
--  Constraints for Table USIM_OVERFLOW
--------------------------------------------------------

  ALTER TABLE "USIM"."USIM_OVERFLOW" MODIFY ("USIM_ID_OVR" NOT NULL ENABLE);
  ALTER TABLE "USIM"."USIM_OVERFLOW" ADD CONSTRAINT "USIM_OVR_PK" PRIMARY KEY ("USIM_ID_OVR")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "WORK"  ENABLE;
--------------------------------------------------------
--  Constraints for Table USIM_POSITION
--------------------------------------------------------

  ALTER TABLE "USIM"."USIM_POSITION" MODIFY ("USIM_ID_POS" NOT NULL ENABLE);
  ALTER TABLE "USIM"."USIM_POSITION" ADD CONSTRAINT "USIM_POS_PK" PRIMARY KEY ("USIM_ID_POS")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "WORK"  ENABLE;
