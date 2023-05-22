-- output trigger FUNKTIONIERT NICHT, da Zugriff auf USIM_POINT benötigt wird
CREATE OR REPLACE TRIGGER usim_poi_output_trg
  AFTER INSERT OR UPDATE ON usim_point
    FOR EACH ROW
    BEGIN
      IF     (INSERTING OR UPDATING)
         AND (   NVL(:NEW.usim_energy, 0) != 0
              OR NVL(:NEW.usim_amplitude, 0) != 0
              OR NVL(:NEW.usim_wavelength, 0) != 0
             )
      THEN
        FOR rec IN (SELECT * FROM usim_poi_relations_v WHERE usim_id_poi = :NEW.usim_id_poi)
        LOOP
          -- insert in output table
          IF rec.usim_id_parent IS NOT NULL
          THEN
            INSERT INTO usim_output
              ( usim_id_source
              , usim_id_target
              , usim_plancktime
              , usim_energy
              , usim_amplitude
              , usim_wavelength
              )
              VALUES
              ( :NEW.usim_id_poi
              , rec.usim_id_poi_parent
              , usim_planck_time_seq.CURRVAL
              , :NEW.usim_energy
              , :NEW.usim_amplitude
              , :NEW.usim_wavelength
              )
            ;
          END IF;
          IF rec.usim_id_child_left IS NOT NULL
          THEN
            INSERT INTO usim_output
              ( usim_id_source
              , usim_id_target
              , usim_plancktime
              , usim_energy
              , usim_amplitude
              , usim_wavelength
              )
              VALUES
              ( :NEW.usim_id_poi
              , rec.usim_id_poi_leftchild
              , usim_planck_time_seq.CURRVAL
              , :NEW.usim_energy
              , :NEW.usim_amplitude
              , :NEW.usim_wavelength
              )
            ;
          END IF;
          IF rec.usim_id_child_right IS NOT NULL
          THEN
            INSERT INTO usim_output
              ( usim_id_source
              , usim_id_target
              , usim_plancktime
              , usim_energy
              , usim_amplitude
              , usim_wavelength
              )
              VALUES
              ( :NEW.usim_id_poi
              , rec.usim_id_poi_rightchild
              , usim_planck_time_seq.CURRVAL
              , :NEW.usim_energy
              , :NEW.usim_amplitude
              , :NEW.usim_wavelength
              )
            ;
          END IF;
        END LOOP;
      END IF;
    END;
/
ALTER TRIGGER usim_poi_output_trg ENABLE;

