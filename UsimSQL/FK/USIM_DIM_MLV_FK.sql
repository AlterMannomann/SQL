-- fk universe for dimensions for documentation, if disabled
ALTER TABLE usim_dimension
  ADD CONSTRAINT usim_dim_mlv_fk
  FOREIGN KEY (usim_id_mlv) REFERENCES usim_multiverse (usim_id_mlv) ON DELETE CASCADE
  ENABLE
;