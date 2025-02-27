ALTER TABLE icgc_data.aerodrome_label DROP CONSTRAINT IF EXISTS aerodrome_label_pk;
ALTER TABLE icgc_data.aerodrome_label ADD CONSTRAINT aerodrome_label_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.aeroway DROP CONSTRAINT IF EXISTS aeroway_pk;
ALTER TABLE icgc_data.aeroway ADD CONSTRAINT aeroway_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.ascensors DROP CONSTRAINT IF EXISTS ascensors_pk;
ALTER TABLE icgc_data.ascensors ADD CONSTRAINT IF NOT EXISTS ascensors_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.contour DROP CONSTRAINT IF EXISTS contour_pk;
ALTER TABLE icgc_data.contour ADD CONSTRAINT contour_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.boundary DROP CONSTRAINT IF EXISTS boundary_pk;
ALTER TABLE icgc_data.boundary ADD CONSTRAINT boundary_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.building DROP CONSTRAINT IF EXISTS building_pk;
ALTER TABLE icgc_data.building ADD CONSTRAINT building_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.building_bt5m DROP CONSTRAINT IF EXISTS building_bt5m_pk;
ALTER TABLE icgc_data.building_bt5m ADD CONSTRAINT building_bt5m_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.building_z12 DROP CONSTRAINT IF EXISTS building_z12_pk;
ALTER TABLE icgc_data.building_z12 ADD CONSTRAINT building_z12_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.contour DROP CONSTRAINT IF EXISTS contour_pk;
ALTER TABLE icgc_data.contour ADD CONSTRAINT contour_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.corbes_mtc250m DROP CONSTRAINT IF EXISTS corbes_mtc250m_pk;
ALTER TABLE icgc_data.corbes_mtc250m ADD CONSTRAINT corbes_mtc250m_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.hipsometria DROP CONSTRAINT IF EXISTS hipsometria_pk;
ALTER TABLE icgc_data.hipsometria ADD CONSTRAINT hipsometria_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.landcover_bt5m DROP CONSTRAINT IF EXISTS landcover_bt5m_pk;
ALTER TABLE icgc_data.landcover_bt5m ADD CONSTRAINT landcover_bt5m_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.landcover_ini DROP CONSTRAINT IF EXISTS landcover_ini_pk;
ALTER TABLE icgc_data.landcover_ini ADD CONSTRAINT landcover_ini_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.landcover_z11_z12 DROP CONSTRAINT IF EXISTS landcover_z11_z12_pk;
ALTER TABLE icgc_data.landcover_z11_z12 ADD CONSTRAINT landcover_z11_z12_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.landcover_z7_z8 DROP CONSTRAINT IF EXISTS landcover_z7_z8_pk;
ALTER TABLE icgc_data.landcover_z7_z8 ADD CONSTRAINT landcover_z7_z8_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.landcover_z9_z10 DROP CONSTRAINT IF EXISTS landcover_z9_z10_pk;
ALTER TABLE icgc_data.landcover_z9_z10 ADD CONSTRAINT landcover_z9_z10_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.park DROP CONSTRAINT IF EXISTS park_pk;
ALTER TABLE icgc_data.park ADD CONSTRAINT park_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.place DROP CONSTRAINT IF EXISTS place_pk;
ALTER TABLE icgc_data.place ADD CONSTRAINT place_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.poblament DROP CONSTRAINT IF EXISTS poblament_pk;
ALTER TABLE icgc_data.poblament ADD CONSTRAINT poblament_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.poi DROP CONSTRAINT IF EXISTS poi_pk;
ALTER TABLE icgc_data.poi ADD CONSTRAINT poi_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.transportation_name DROP CONSTRAINT IF EXISTS transportation_name_pk;
ALTER TABLE icgc_data.transportation_name ADD CONSTRAINT transportation_name_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.transportation_name_lines DROP CONSTRAINT IF EXISTS transportation_name_lines_pk;
ALTER TABLE icgc_data.transportation_name_lines ADD CONSTRAINT transportation_name_lines_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.water DROP CONSTRAINT IF EXISTS water_pk;
ALTER TABLE icgc_data.water ADD CONSTRAINT water_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.water_name DROP CONSTRAINT IF EXISTS water_name_pk;
ALTER TABLE icgc_data.water_name ADD CONSTRAINT water_name_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.water_z_10_11_carto DROP CONSTRAINT IF EXISTS water_z_10_11_carto_pk;
ALTER TABLE icgc_data.water_z_10_11_carto ADD CONSTRAINT water_z_10_11_carto_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.water_z_7_8_carto DROP CONSTRAINT IF EXISTS water_z_7_8_carto_pk;
ALTER TABLE icgc_data.water_z_7_8_carto ADD CONSTRAINT water_z_7_8_carto_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.water_z_9_10_carto DROP CONSTRAINT IF EXISTS water_z_9_10_carto_pk;
ALTER TABLE icgc_data.water_z_9_10_carto ADD CONSTRAINT water_z_9_10_carto_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.waterway_z_10_11_carto DROP CONSTRAINT IF EXISTS waterway_z_10_11_carto_pk;
ALTER TABLE icgc_data.waterway_z_10_11_carto ADD CONSTRAINT waterway_z_10_11_carto_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.waterway_z_7_8_carto DROP CONSTRAINT IF EXISTS waterway_z_7_8_carto_pk;
ALTER TABLE icgc_data.waterway_z_7_8_carto ADD CONSTRAINT waterway_z_7_8_carto_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.waterway_z_9_10_carto DROP CONSTRAINT IF EXISTS waterway_z_9_10_carto_pk;
ALTER TABLE icgc_data.waterway_z_9_10_carto ADD CONSTRAINT waterway_z_9_10_carto_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.waterway_bt5mv30_strahler DROP CONSTRAINT IF EXISTS waterway_bt5mv30_strahler_pk;
ALTER TABLE icgc_data.waterway_bt5mv30_strahler ADD CONSTRAINT waterway_bt5mv30_strahler_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.z_9_12_transportation_contextmaps DROP CONSTRAINT IF EXISTS z_9_12_transportation_contextmaps_pk;
ALTER TABLE icgc_data.z_9_12_transportation_contextmaps ADD CONSTRAINT z_9_12_transportation_contextmaps_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.z_13_18_transportation_contextmaps DROP CONSTRAINT IF EXISTS z_13_18_transportation_contextmaps_pk;
ALTER TABLE icgc_data.z_13_18_transportation_contextmaps ADD CONSTRAINT z_13_18_transportation_contextmaps_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.z_13_18_transportation_contextmaps_name DROP CONSTRAINT IF EXISTS z_13_18_transportation_contextmaps_name_pk;
ALTER TABLE icgc_data.z_13_18_transportation_contextmaps_name ADD CONSTRAINT z_13_18_transportation_contextmaps_name_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.z_9_10mtc_poblament_poligon DROP CONSTRAINT IF EXISTS z_9_10mtc_poblament_poligon_pk;
ALTER TABLE icgc_data.z_9_10mtc_poblament_poligon ADD CONSTRAINT z_9_10mtc_poblament_poligon_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.z_6_8_mtc_vials DROP CONSTRAINT IF EXISTS z_6_8_mtc_vials_pk;
ALTER TABLE icgc_data.z_6_8_mtc_vials ADD CONSTRAINT z_6_8_mtc_vials_pk PRIMARY KEY (icgc_id);

ALTER TABLE icgc_data.z_9_10mtc_poblament_poligon DROP CONSTRAINT IF EXISTS z_9_10mtc_poblament_poligon_pk;
ALTER TABLE icgc_data.z_9_10mtc_poblament_poligon ADD CONSTRAINT z_9_10mtc_poblament_poligon_pk PRIMARY KEY (icgc_id);

