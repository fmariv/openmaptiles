DROP INDEX IF EXISTS idx_aerodrome_label_geom;
DROP INDEX IF EXISTS idx_aeroway_geom;
DROP INDEX IF EXISTS idx_ascensors_geom;
DROP INDEX IF EXISTS idx_boundary_geom;
DROP INDEX IF EXISTS idx_building_geom;
DROP INDEX IF EXISTS idx_building_bt5m_geom;
DROP INDEX IF EXISTS idx_building_z12_geom;
DROP INDEX IF EXISTS idx_contour_geom;
DROP INDEX IF EXISTS idx_corbes_mtc250m_geom;
DROP INDEX IF EXISTS idx_hipsometria_geom;
DROP INDEX IF EXISTS landcover_bt5m_geom;
DROP INDEX IF EXISTS idx_landcover_ini_geom;
DROP INDEX IF EXISTS idx_landcover_z11_z12_geom;
DROP INDEX IF EXISTS idx_landcover_z7_z8_geom;
DROP INDEX IF EXISTS idx_landcover_z9_z10_geom;
DROP INDEX IF EXISTS idx_park_geom;
DROP INDEX IF EXISTS idx_place_geom;
DROP INDEX IF EXISTS idx_poblament_geom;
DROP INDEX IF EXISTS idx_poi_geom;
DROP INDEX IF EXISTS idx_transportation_name_geom;
DROP INDEX IF EXISTS idx_transportation_name_lines_geom;
DROP INDEX IF EXISTS idx_water_geom;
DROP INDEX IF EXISTS idx_water_name_geom;
DROP INDEX IF EXISTS idx_water_z_10_11_carto_geom;
DROP INDEX IF EXISTS idx_water_z_7_8_carto_geom;
DROP INDEX IF EXISTS idx_water_z_9_10_carto_geom;
DROP INDEX IF EXISTS idx_waterway_z_10_11_carto_geom;
DROP INDEX IF EXISTS idx_waterway_z_7_8_carto_geom;
DROP INDEX IF EXISTS idx_waterway_z_9_10_carto_geom;
DROP INDEX IF EXISTS idx_waterway_bt5mv30_strahler_geom;
DROP INDEX IF EXISTS idx_z_9_12_transportation_contextmaps_geom;
DROP INDEX IF EXISTS idx_z_13_18_transportation_contextmaps_geom;
DROP INDEX IF EXISTS z_13_18_transportation_contextmaps_name_geom;
DROP INDEX IF EXISTS idx_z_7mtc_vials_geom;
DROP INDEX IF EXISTS idx_z_6_8_mtc_vials_geom;
DROP INDEX IF EXISTS idx_z_9_10mtc_poblament_poligon_geom;

CREATE INDEX IF NOT EXISTS idx_aerodrome_label_geom ON contextmaps.aerodrome_label USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_aeroway_geom ON contextmaps.aeroway USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_ascensors_geom ON contextmaps.ascensors USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_boundary_geom ON contextmaps.boundary USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_building_geom ON contextmaps.building USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_building_bt5m_geom ON contextmaps.building_bt5m USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_building_z12_geom ON contextmaps.building_z12 USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_contour_geom ON contextmaps.contour USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_corbes_mtc250m_geom ON contextmaps.corbes_mtc250m USING gist (ST_MakeValid(geometry));
CREATE INDEX IF NOT EXISTS idx_hipsometria_geom ON icgc_data.hipsometria USING gist (ST_MakeValid(geometry));
CREATE INDEX IF NOT EXISTS idx_housenumber_geom ON icgc_data.housenumber_not_used USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS landcover_bt5m_geom ON icgc_data.landcover_bt5m USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_landcover_ini_geom ON icgc_data.landcover_ini USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_landcover_z11_z12_geom ON icgc_data.landcover_z11_z12 USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_landcover_z7_z8_geom ON icgc_data.landcover_z7_z8 USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_landcover_z9_z10_geom ON icgc_data.landcover_z9_z10 USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_park_geom ON icgc_data.park USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_place_geom ON icgc_data.place USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_place_zoom ON icgc_data.place USING btree (zoom);
CREATE INDEX IF NOT EXISTS idx_poblament_geom ON icgc_data.poblament USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_poi_geom ON icgc_data.poi USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_transportation_name_geom ON icgc_data.transportation_name USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_transportation_name_zoom ON icgc_data.transportation_name USING btree (zoom);
CREATE INDEX IF NOT EXISTS idx_transportation_name_lines_geom ON icgc_data.transportation_name_lines USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_water_geom ON icgc_data.water USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_water_name_geom ON icgc_data.water_name USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_water_z_10_11_carto_geom ON icgc_data.water_z_10_11_carto USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_water_z_7_8_carto_geom ON icgc_data.water_z_7_8_carto USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_water_z_9_10_carto_geom ON icgc_data.water_z_9_10_carto USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_waterway_z_10_11_carto_geom ON icgc_data.waterway_z_10_11_carto USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_waterway_z_7_8_carto_geom ON icgc_data.waterway_z_7_8_carto USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_waterway_z_9_10_carto_geom ON icgc_data.waterway_z_9_10_carto USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_waterway_bt5mv30_strahler_geom ON icgc_data.waterway_bt5mv30_strahler USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_z_9_12_transportation_contextmaps_geom ON icgc_data.z_9_12_transportation_contextmaps USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_z_13_18_transportation_contextmaps_geom ON icgc_data.z_13_18_transportation_contextmaps USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS z_13_18_transportation_contextmaps_name_geom ON icgc_data.z_13_18_transportation_contextmaps_name USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_z_7mtc_vials_geom ON icgc_data.z_7mtc_vials_not_used USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_z_6_8_mtc_vials_geom ON icgc_data.z_6_8_mtc_vials USING gist (ST_MakeValid(geom));
CREATE INDEX IF NOT EXISTS idx_z_9_10mtc_poblament_poligon_geom ON icgc_data.z_9_10mtc_poblament_poligon USING gist (ST_MakeValid(geom));