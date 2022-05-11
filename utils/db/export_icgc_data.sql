--
-- Export ICGC data from public schema to contextmaps schema
--

CREATE SCHEMA IF NOT EXISTS contextmaps;

-- aerodrome label
SELECT *
INTO contextmaps.aerodrome_label
FROM aerodrome_label;
CREATE INDEX idx_aerodrome_label_geom ON contextmaps.aerodrome_label USING gist (geom);
DROP TABLE public.aerodrome_label;

-- aeroway
SELECT *
INTO contextmaps.aeroway
FROM aeroway;
CREATE INDEX idx_aeroway_geom ON contextmaps.aeroway USING gist (geom);
DROP TABLE public.aeroway;

-- ascensors
SELECT *
INTO contextmaps.ascensors
FROM ascensors;
CREATE INDEX idx_ascensors_20210112_geom ON contextmaps.ascensors USING gist (geom);
DROP TABLE public.ascensors;

-- boundary
SELECT *
INTO contextmaps.boundary
FROM boundary;
CREATE INDEX idx_boundary_geom ON contextmaps.boundary USING gist (geom);
DROP TABLE public.boundary;

-- building
SELECT *
INTO contextmaps.building
FROM building;
CREATE INDEX idx_building_geom ON contextmaps.building USING gist (geom);
DROP TABLE public.building;

-- building_bt5m
SELECT *
INTO contextmaps.building_bt5m
FROM building_bt5m;
CREATE INDEX idx_building_bt5m_geom ON contextmaps.building_bt5m USING gist (geom);
DROP TABLE public.building_bt5m;

-- building_z12
SELECT *
INTO contextmaps.building_z12
FROM building_z12;
CREATE INDEX idx_building_z12_geom ON contextmaps.building_z12 USING gist (geom);
DROP TABLE public.building_z12;

-- cat_limit_z
SELECT *
INTO contextmaps.cat_limit_z
FROM cat_limit_z;
CREATE INDEX idx_cat_limit_z_geom ON contextmaps.cat_limit_z USING gist (geom);
DROP TABLE public.cat_limit_z;

-- contour
SELECT *
INTO contextmaps.contour
FROM contour;
CREATE INDEX idx_contour_geom ON contextmaps.contour USING gist (geom);
DROP TABLE public.contour;

-- housenumber
SELECT *
INTO contextmaps.housenumber
FROM housenumber;
CREATE INDEX idx_housenumber_geom ON contextmaps.housenumber USING gist (geom);
DROP TABLE public.housenumber;

-- landcover_bt5m
SELECT *
INTO contextmaps.landcover_bt5m
FROM landcover_bt5m;
CREATE INDEX landcover_bt5m_geom ON contextmaps.landcover_bt5m USING gist (geom);
DROP TABLE public.landcover_bt5m;

-- landcover_ini
SELECT *
INTO contextmaps.landcover_ini
FROM landcover_ini;
CREATE INDEX idx_landcover_ini_geom ON contextmaps.landcover_ini USING gist (geom);
DROP TABLE public.landcover_ini;

-- landcover_z11_z12
SELECT *
INTO contextmaps.landcover_z11_z12
FROM landcover_z11_z12;
CREATE INDEX idx_landcover_z11_z12_geom ON contextmaps.landcover_z11_z12 USING gist (geom);
DROP TABLE public.landcover_z11_z12;

-- landcover_z7_z8
SELECT *
INTO contextmaps.landcover_z7_z8
FROM landcover_z7_z8;
CREATE INDEX idx_landcover_z7_z8_geom ON contextmaps.landcover_z7_z8 USING gist (geom);
DROP TABLE public.landcover_z7_z8;

-- landcover_z9_z10
SELECT *
INTO contextmaps.landcover_z9_z10
FROM landcover_z9_z10;
CREATE INDEX idx_landcover_z9_z10_geom ON contextmaps.landcover_z9_z10 USING gist (geom);
DROP TABLE public.landcover_z9_z10;

-- park
SELECT *
INTO contextmaps.park
FROM park;
CREATE INDEX idx_park_geom ON contextmaps.park USING gist (geom);
DROP TABLE public.park;

-- place
SELECT *
INTO contextmaps.place
FROM place;
CREATE INDEX idx_place_geom ON contextmaps.place USING gist (geom);
CREATE INDEX idx_place_zoom ON contextmaps.place USING btree (zoom);
DROP TABLE public.place;

-- poblament
SELECT *
INTO contextmaps.poblament
FROM poblament;
CREATE INDEX idx_poblament_geom ON contextmaps.poblament USING gist (geom);
DROP TABLE public.poblament;

-- poi
SELECT *
INTO contextmaps.poi
FROM poi;
CREATE INDEX idx_poi_geom ON contextmaps.poi USING gist (geom);
DROP TABLE public.poi;

-- transportation
SELECT *
INTO contextmaps.transportation
FROM transportation;
CREATE INDEX idx_transportation_geom ON contextmaps.transportation USING gist (geom);
CREATE INDEX transportation_class_idx ON contextmaps.transportation USING btree (class);
DROP TABLE public.transportation;

-- transportation_bdcarrers
SELECT *
INTO contextmaps.transportation_bdcarrers
FROM transportation_bdcarrers;
CREATE INDEX idx_transportation_bdcarrers_geom ON contextmaps.transportation_bdcarrers USING gist (geom);
DROP TABLE public.transportation_bdcarrers;

-- transportation_name
SELECT *
INTO contextmaps.transportation_name
FROM transportation_name;
CREATE INDEX idx_transportation_name_geom ON contextmaps.transportation_name USING gist (geom);
CREATE INDEX idx_transportation_name_zoom ON contextmaps.transportation_name USING btree (zoom);
DROP TABLE public.transportation_name;

-- transportation_name_bdcarrers
SELECT *
INTO contextmaps.transportation_name_bdcarrers
FROM transportation_name_bdcarrers;
CREATE INDEX idx_transportation_name_bdcarrers_geom ON contextmaps.transportation_name_bdcarrers USING gist (geom);
DROP TABLE public.transportation_name_bdcarrers;

-- transportation_name_lines
SELECT *
INTO contextmaps.transportation_name_lines
FROM transportation_name_lines;
CREATE INDEX idx_transportation_name_lines_geom ON contextmaps.transportation_name_lines USING gist (geom);
DROP TABLE public.transportation_name_lines;

-- transportation_z10
SELECT *
INTO contextmaps.transportation_z10
FROM transportation_z10;
CREATE INDEX idx_transportation_z10_geom ON contextmaps.transportation_z10 USING gist (geom);
DROP TABLE public.transportation_z10;

-- transportation_z9
SELECT *
INTO contextmaps.transportation_z9
FROM transportation_z9;
CREATE INDEX idx_transportation_z9_geom ON contextmaps.transportation_z9 USING gist (geom);
DROP TABLE public.transportation_z9;

-- water
SELECT *
INTO contextmaps.water
FROM water;
CREATE INDEX idx_water_geom ON contextmaps.water USING gist (geom);
DROP TABLE public.water;

-- water_name
SELECT *
INTO contextmaps.water_name
FROM water_name;
CREATE INDEX idx_water_name_geom ON contextmaps.water_name USING gist (geom);
DROP TABLE public.water_name;

-- water_z_10_11_carto
SELECT *
INTO contextmaps.water_z_10_11_carto
FROM water_z_10_11_carto;
CREATE INDEX idx_water_z_10_11_carto_geom ON contextmaps.water_z_10_11_carto USING gist (geom);
DROP TABLE public.water_z_10_11_carto;

-- water_z_7_8_carto
SELECT *
INTO contextmaps.water_z_7_8_carto
FROM water_z_7_8_carto;
CREATE INDEX idx_water_z_7_8_carto_geom ON contextmaps.water_z_7_8_carto USING gist (geom);
DROP TABLE public.water_z_7_8_carto;

-- water_z_9_10_carto
SELECT *
INTO contextmaps.water_z_9_10_carto
FROM water_z_9_10_carto;
CREATE INDEX idx_water_z_9_10_carto_geom ON contextmaps.water_z_9_10_carto USING gist (geom);
DROP TABLE public.water_z_9_10_carto;

-- waterway
SELECT *
INTO contextmaps.waterway
FROM waterway;
CREATE INDEX idx_waterway_geom ON contextmaps.waterway USING gist (geom);
DROP TABLE public.waterway;

-- waterway_z_10_11_carto
SELECT *
INTO contextmaps.waterway_z_10_11_carto
FROM waterway_z_10_11_carto;
CREATE INDEX idx_waterway_z_10_11_carto_geom ON contextmaps.waterway_z_10_11_carto USING gist (geom);
DROP TABLE public.waterway_z_10_11_carto;

-- waterway_z_7_8_carto
SELECT *
INTO contextmaps.waterway_z_7_8_carto
FROM waterway_z_7_8_carto;
CREATE INDEX idx_waterway_z_7_8_carto_geom ON contextmaps.waterway_z_7_8_carto USING gist (geom);
DROP TABLE public.waterway_z_7_8_carto;

-- waterway_z_9_10_carto
SELECT *
INTO contextmaps.waterway_z_9_10_carto
FROM waterway_z_9_10_carto;
CREATE INDEX idx_waterway_z_9_10_carto_geom ON contextmaps.waterway_z_9_10_carto USING gist (geom);
DROP TABLE public.waterway_z_9_10_carto;

-- waterway_bt5mv30_strahler
SELECT *
INTO contextmaps.waterway_bt5mv30_strahler
FROM waterway_bt5mv30_strahler;
CREATE INDEX idx_waterway_bt5mv30_strahler_geom ON contextmaps.waterway_bt5mv30_strahler USING gist (geom);
DROP TABLE public.waterway_bt5mv30_strahler;

-- z_11_13_transportation_contextmaps
SELECT *
INTO contextmaps.z_11_13_transportation_contextmaps
FROM z_11_13_transportation_contextmaps;
CREATE INDEX idx_z_11_13_transportation_contextmaps_geom ON contextmaps.z_11_13_transportation_contextmaps USING gist (geom);
DROP TABLE public.z_11_13_transportation_contextmaps;

-- z_13_18_transportation_contextmaps
SELECT *
INTO contextmaps.z_13_18_transportation_contextmaps
FROM z_13_18_transportation_contextmaps;
CREATE INDEX idx_z_13_18_transportation_contextmaps_geom ON contextmaps.z_13_18_transportation_contextmaps USING gist (geom);
DROP TABLE public.z_13_18_transportation_contextmaps;

-- z_13_18_transportation_contextmaps_name
SELECT *
INTO contextmaps.z_13_18_transportation_contextmaps_name
FROM z_13_18_transportation_contextmaps_name;
CREATE INDEX z_13_18_transportation_contextmaps_name_geom ON contextmaps.z_13_18_transportation_contextmaps_name USING gist (geom);
DROP TABLE public.z_13_18_transportation_contextmaps_name;

-- z_7mtc_vials
SELECT *
INTO contextmaps.z_7mtc_vials
FROM z_7mtc_vials;
CREATE INDEX idx_z_7mtc_vials_geom ON contextmaps.z_7mtc_vials USING gist (geom);
DROP TABLE public.z_7mtc_vials;

-- z_8mtc_vials
SELECT *
INTO contextmaps.z_8mtc_vials
FROM z_8mtc_vials;
CREATE INDEX idx_z_8mtc_vials_geom ON contextmaps.z_8mtc_vials USING gist (geom);
DROP TABLE public.z_8mtc_vials;

-- z_9_10mtc_poblament_poligon
SELECT *
INTO contextmaps.z_9_10mtc_poblament_poligon
FROM z_9_10mtc_poblament_poligon;
CREATE INDEX idx_z_9_10mtc_poblament_poligon_geom ON contextmaps.z_9_10mtc_poblament_poligon USING gist (geom);
DROP TABLE public.z_9_10mtc_poblament_poligon;

-- waterway
SELECT *
INTO contextmaps.waterway
FROM waterway;
CREATE INDEX idx_waterway_geom ON contextmaps.waterway USING gist (geom);
DROP TABLE public.waterway;