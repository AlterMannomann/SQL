-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE BODY &USIM_SCHEMA..usim_nod
IS
  -- see header for documentation
  FUNCTION has_data
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_node;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data(p_usim_id_nod IN usim_node.usim_id_nod%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_node WHERE usim_id_nod = p_usim_id_nod;
    RETURN l_result;
  END has_data
  ;

  FUNCTION get_energy(p_usim_id_nod IN usim_node.usim_id_nod%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    IF usim_nod.has_data(p_usim_id_nod) = 1
    THEN
      SELECT usim_energy INTO l_result FROM usim_node WHERE usim_id_nod = p_usim_id_nod;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_nod.get_energy', 'Used with not existing node id [' || p_usim_id_nod || '].');
      RETURN NULL;
    END IF;
  END get_energy
  ;

  FUNCTION insert_node(p_do_commit  IN BOOLEAN  DEFAULT TRUE)
    RETURN usim_node.usim_id_nod%TYPE
  IS
    l_result usim_node.usim_id_nod%TYPE;
  BEGIN
    INSERT INTO usim_node (usim_energy) VALUES (NULL) RETURNING usim_id_nod INTO l_result;
    IF p_do_commit
    THEN
      COMMIT;
    END IF;
    RETURN l_result;
  END insert_node
  ;

  FUNCTION update_energy( p_usim_energy  IN usim_node.usim_energy%TYPE
                        , p_usim_id_nod  IN usim_node.usim_id_nod%TYPE
                        , p_do_commit    IN BOOLEAN                    DEFAULT TRUE
                        )
    RETURN usim_node.usim_energy%TYPE
  IS
    l_result usim_node.usim_energy%TYPE;
  BEGIN
    IF usim_nod.has_data(p_usim_id_nod) = 1
    THEN
      UPDATE usim_node SET usim_energy = p_usim_energy WHERE usim_id_nod = p_usim_id_nod RETURNING usim_energy INTO l_result;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_nod.update_energy', 'Used with not existing node id [' || p_usim_id_nod || '].');
      RETURN NULL;
    END IF;
  END update_energy
  ;

  FUNCTION add_energy( p_usim_energy  IN NUMBER
                     , p_usim_id_nod  IN usim_node.usim_id_nod%TYPE
                     , p_do_commit    IN BOOLEAN                    DEFAULT TRUE
                     )
    RETURN usim_node.usim_energy%TYPE
  IS
    l_energy NUMBER;
  BEGIN
    l_energy := NVL(p_usim_energy, 0) + NVL(usim_nod.get_energy(p_usim_id_nod), 0);
    RETURN usim_nod.update_energy(l_energy, p_usim_id_nod, p_do_commit);
  END add_energy
  ;

END usim_nod;
/