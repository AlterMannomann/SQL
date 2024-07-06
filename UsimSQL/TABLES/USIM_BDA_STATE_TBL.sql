-- define session for test schema first (temporary for tests)
SET search_path TO usim_test, public;

DROP TABLE IF EXISTS usim_bda_state;
-- sort columns by space needed, small columns first, character varying last (slowest access)
CREATE TABLE usim_bda_state
(
    bds_id smallint NOT NULL DEFAULT 1,
    bda_id smallint NOT NULL,
    bds_created timestamp without time zone NOT NULL DEFAULT now(),
    bds_updated timestamp without time zone NOT NULL DEFAULT now(),
    bds_created_by character varying(128) NOT NULL DEFAULT USER,
    bds_updated_by character varying(128) NOT NULL DEFAULT USER,
    CONSTRAINT bds_pk PRIMARY KEY (bds_id),
    CONSTRAINT bda_fk FOREIGN KEY (bda_id) REFERENCES usim_basedata (bda_id) ON DELETE RESTRICT
)
TABLESPACE usim_data;

COMMENT ON TABLE usim_bda_state
    IS 'Holds the active state for a defined simulation. Only one data row allowed. Will use the alias bds.';

COMMENT ON COLUMN usim_bda_state.bds_id
    IS 'The unique id of the base data state. Always 1. Limited to exactly one record with bds_id = 1.';

COMMENT ON COLUMN usim_bda_state.bda_id
    IS 'The unique id of the base data for the active simulation. Only one simulation can be active at any time.';

-- FUNCTION: bds_fn_ins_trg()
-- DROP FUNCTION IF EXISTS bds_fn_ins_trg();

CREATE OR REPLACE FUNCTION bds_fn_ins_trg()
    RETURNS trigger
    LANGUAGE 'plpgsql'
AS $BODY$
    BEGIN
        -- Check that id is given and 1
        IF NEW.bds_id != 1 THEN
            RAISE EXCEPTION 'bds_id cannot only be 1, no other value allowed';
        END IF;
        -- Remember who changed the base data, ignore any inputs
        NEW.bds_created := current_timestamp;
        NEW.bds_created_by := current_user;
        NEW.bds_updated := current_timestamp;
        NEW.bds_updated_by := current_user;
        RETURN NEW;
    END;
$BODY$;

-- Trigger: bds_ins_trg
-- DROP TRIGGER IF EXISTS bds_ins_trg ON usim_bda_state;

CREATE TRIGGER bds_ins_trg
    AFTER INSERT
    ON usim_bda_state
    FOR EACH ROW
    EXECUTE FUNCTION bds_fn_ins_trg();
