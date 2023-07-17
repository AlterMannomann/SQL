CREATE OR REPLACE PACKAGE usim_process
IS
-- 3D koordinaten und prüfen, ob auch alle Nodes pro Dimension vorhanden sind.
-- die untergeordneten Dimensionen sind immer Teil der neuen Dimension.
-- Reihenfolge
-- erst alle from - to in einem volume in jeder Dimension ein planck tick
-- dann alle to mit den
END usim_process;
/
-- Nodes sind falsch, wir brauchen nur die to in der nächsten Dimension
-- dafür mehrfach. from mit to verbunden für alle from-to aus Dimension 1
-- UK Constraint ist falsch
-- Dim 1 0, 1 -> 2 Nodes
-- Dim 2 0,0 - 0,1 und 1,0 - 1,1 und 0,1 - 1,1 -> 4 Nodes, 2 neue Nodes
-- Dim 3 0,0,0 - 0,0,1 und 0,1,0 / 0,1,0 - 0,1,1 / 1,0,0 - 1,1,0 und 1,0,1 / 1,1,0 - 1,1,1 -> 8 Nodes, 4 neue Nodes
SELECT *
  FROM usim_rrpn_v
 WHERE usim_n_dimension <= 2
   AND usim_sign = 1
   AND usim_coordinate IN (0,1)
;