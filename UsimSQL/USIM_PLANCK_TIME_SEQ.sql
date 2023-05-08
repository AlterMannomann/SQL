-- a sequence for planck time ticks
CREATE SEQUENCE usim_planck_time_seq
  MINVALUE 1
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  ORDER
  NOCYCLE
  NOKEEP
  NOSCALE
  GLOBAL
;