-- define session for test schema first (temporary for tests)
SET search_path TO usim_test, public;

DROP TABLE IF EXISTS usim_basedata;
-- sort columns by space needed, small columns first, character varying last (slowest access)
CREATE TABLE usim_basedata
(
    bda_id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MAXVALUE 32767 ),
    bda_max_dimension smallint NOT NULL DEFAULT 42,
    bda_overflow_behavior smallint NOT NULL DEFAULT 0,
    bda_created timestamp without time zone NOT NULL DEFAULT now(),
    bda_updated timestamp without time zone NOT NULL DEFAULT now(),
    bda_max_abs_number numeric(1000, 0) NOT NULL DEFAULT 99999999999999999999999999999999999999,
    bda_simulation_name character varying(128) NOT NULL DEFAULT 'USim Simulation',
    bda_created_by character varying(128) NOT NULL DEFAULT USER,
    bda_updated_by character varying(128) NOT NULL DEFAULT USER,
    CONSTRAINT bda_pk PRIMARY KEY (bda_id),
    CONSTRAINT bda_uk UNIQUE (bda_simulation_name),
    CONSTRAINT bda_chk_dimension CHECK (bda_max_dimension >= 0 AND bda_max_dimension < 100) NOT VALID,
    CONSTRAINT bda_chk_max_abs_number CHECK (bda_max_abs_number >= 0) NOT VALID,
    CONSTRAINT bda_chk_overflow_behavior CHECK (bda_overflow_behavior IN (0, 1)) NOT VALID
)
TABLESPACE usim_data;

COMMENT ON TABLE usim_basedata
    IS 'Holds the basic data used by the multiverse simulation that belong to all universes of this simulation. Will use the alias bda.';

COMMENT ON COLUMN usim_basedata.bda_id
    IS 'The unique id of the base data. Always generated. Avoid inserts causing constraint errors on insert as this will waste a serial and leave holes in the serials.';

COMMENT ON COLUMN usim_basedata.bda_simulation_name
    IS 'The unique name of this simulation definition.';

COMMENT ON COLUMN usim_basedata.bda_max_dimension
    IS 'The maximum dimension supported for any universe in this multiverse. Must be set on insert, ignored on update.';

COMMENT ON COLUMN usim_basedata.bda_max_abs_number
    IS 'The absolute maximum number possible on the used system. Must be set on insert, ignored on update. Double use, limits the possible positions and also the maximum underflow or overflow.';

COMMENT ON COLUMN usim_basedata.bda_overflow_behavior
    IS 'Set to 1 if all new structures should start with parent in dimension n = 0. Set to 0, if new structures should use standard overflow handling. Must be set on insert, ignored on update.';

COMMENT ON COLUMN usim_basedata.bda_created
    IS 'The date of record creation.';

COMMENT ON COLUMN usim_basedata.bda_updated
    IS 'The last date of record update.';

COMMENT ON COLUMN usim_basedata.bda_created_by
    IS 'The user that created the record.';

COMMENT ON COLUMN usim_basedata.bda_updated_by
    IS 'The last user that committed an update.';

-- FUNCTION: bda_fn_ins_trg()
-- DROP FUNCTION IF EXISTS bda_fn_ins_trg();

CREATE OR REPLACE FUNCTION bda_fn_ins_trg()
    RETURNS trigger
    LANGUAGE 'plpgsql'
AS $BODY$
    BEGIN
        -- Check that id is given and NOT NULL in any case, other columns should be protected by constraints
        IF NEW.bda_id IS NULL THEN
            RAISE EXCEPTION 'bda_id cannot be null';
        END IF;
        -- Remember who changed the base data, ignore any inputs
        NEW.bda_created := current_timestamp;
        NEW.bda_created_by := current_user;
        NEW.bda_updated := current_timestamp;
        NEW.bda_updated_by := current_user;
        RETURN NEW;
    END;
$BODY$;

-- FUNCTION: bda_fn_upd_trg()
-- DROP FUNCTION IF EXISTS bda_fn_upd_trg();

CREATE OR REPLACE FUNCTION bda_fn_upd_trg()
    RETURNS trigger
    LANGUAGE 'plpgsql'
AS $BODY$
    BEGIN
        -- Only column that can be changed is bda_simulation_name
        IF NEW.bda_max_dimension != OLD.bda_max_dimension THEN
            RAISE EXCEPTION 'bda_max_dimension cannot be changed, create a new base dataset instead';
        END IF;
        IF NEW.bda_max_abs_number != OLD.bda_max_abs_number THEN
            RAISE EXCEPTION 'bda_max_abs_number cannot be changed, create a new base dataset instead';
        END IF;
        IF NEW.bda_overflow_behavior != OLD.bda_overflow_behavior THEN
            RAISE EXCEPTION 'bda_overflow_behavior cannot be changed, create a new base dataset instead';
        END IF;
        -- Remember who changed the base data, ignore any updates
        NEW.bda_updated := current_timestamp;
        NEW.bda_updated_by := current_user;
        RETURN NEW;
    END;
$BODY$;

-- Trigger: bda_ins_trg
-- DROP TRIGGER IF EXISTS bda_ins_trg ON usim_basedata;

CREATE TRIGGER bda_ins_trg
    AFTER INSERT
    ON usim_basedata
    FOR EACH ROW
    EXECUTE FUNCTION bda_fn_ins_trg();

-- Trigger: bda_upd_trg
-- DROP TRIGGER IF EXISTS bda_upd_trg ON usim_basedata;

CREATE TRIGGER bda_upd_trg
    AFTER UPDATE
    ON usim_basedata
    FOR EACH ROW
    EXECUTE FUNCTION bda_fn_upd_trg();
