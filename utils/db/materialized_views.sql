-- POI

DROP MATERIALIZED VIEW IF EXISTS osm_poi_point_planet;
CREATE MATERIALIZED VIEW osm_poi_point_planet AS
(
SELECT opp.*,
       osm_id * 10 AS osm_id_hash
FROM osm_poi_point opp, contextmaps.catalunya c
WHERE ST_Disjoint(c.geometry, opp.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_poi_point_planet_idx ON osm_poi_point_planet USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_poi_polygon_planet;
CREATE MATERIALIZED VIEW osm_poi_polygon_planet AS
(
SELECT  opp.*,
        NULL::integer AS agg_stop,
        CASE
            WHEN osm_id < 0 THEN -osm_id * 10 + 4
            ELSE osm_id * 10 + 1
            END AS osm_id_hash
FROM osm_poi_polygon opp, contextmaps.catalunya c
WHERE ST_Disjoint(c.geometry, opp.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_poi_polygon_planet_idx ON osm_poi_polygon_planet USING gist (geometry);

-- Building

DROP MATERIALIZED VIEW IF EXISTS osm_building_block_planet;
CREATE MATERIALIZED VIEW osm_building_planet AS
(
SELECT *
FROM osm_building_block_gen_z13 obbp, contextmaps.catalunya c
WHERE ST_DISJOINT(c.geometry, obbp.geometry)
);
CREATE INDEX IF NOT EXISTS osm_building_block_planet_idx ON osm_building_block_planet USING gist (geometry);

CREATE INDEX IF NOT EXISTS osm_building_relation_building_idx ON osm_building_relation (building) WHERE building = '' AND ST_GeometryType(geometry) = 'ST_Polygon';
CREATE INDEX IF NOT EXISTS osm_building_relation_member_idx ON osm_building_relation (member) WHERE role = 'outline';

DROP MATERIALIZED VIEW IF EXISTS osm_all_buildings;
CREATE MATERIALIZED VIEW osm_all_buildings AS
(
SELECT
    -- etldoc: osm_building_relation -> layer_building:z14_
    -- Buildings built from relations
    member AS osm_id,
    b.geometry,
    COALESCE(CleanNumeric(height), CleanNumeric(buildingheight)) AS height,
    COALESCE(CleanNumeric(min_height), CleanNumeric(buildingmin_height)) AS min_height,
    COALESCE(CleanNumeric(levels), CleanNumeric(buildinglevels)) AS levels,
    COALESCE(CleanNumeric(min_level), CleanNumeric(buildingmin_level)) AS min_level,
    nullif(material, '') AS material,
    nullif(colour, '') AS colour,
    FALSE AS hide_3d
FROM osm_building_relation b, contextmaps.catalunya c
WHERE building = ''
  AND ST_GeometryType(b.geometry) = 'ST_Polygon'
  AND ST_Disjoint(c.geometry, b.geometry)
UNION ALL

SELECT
    -- etldoc: osm_building_polygon -> layer_building:z14_
    -- Standalone buildings
    obp.osm_id,
    obp.geometry,
    COALESCE(CleanNumeric(obp.height), CleanNumeric(obp.buildingheight)) AS height,
    COALESCE(CleanNumeric(obp.min_height), CleanNumeric(obp.buildingmin_height)) AS min_height,
    COALESCE(CleanNumeric(obp.levels), CleanNumeric(obp.buildinglevels)) AS levels,
    COALESCE(CleanNumeric(obp.min_level), CleanNumeric(obp.buildingmin_level)) AS min_level,
    nullif(obp.material, '') AS material,
    nullif(obp.colour, '') AS colour,
    obr.role IS NOT NULL AS hide_3d
FROM osm_building_polygon obp
         LEFT JOIN osm_building_relation obr ON
        obp.osm_id >= 0 AND
        obr.member = obp.osm_id AND
        obr.role = 'outline',
      contextmaps.catalunya c
WHERE ST_GeometryType(obp.geometry) IN ('ST_Polygon', 'ST_MultiPolygon')
   AND ST_Disjoint(c.geometry, obp.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_all_buildings_idx ON osm_all_buildings USING gist (geometry);

-- Landcover

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z7;
CREATE MATERIALIZED VIEW osm_landcover_planet_z7 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z7 ol, contextmaps.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z7_idx ON osm_landcover_planet_z7 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z8;
CREATE MATERIALIZED VIEW osm_landcover_planet_z8 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z8 ol, contextmaps.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z8_idx ON osm_landcover_planet_z8 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z9;
CREATE MATERIALIZED VIEW osm_landcover_planet_z9 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z9 ol, contextmaps.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z9_idx ON osm_landcover_planet_z9 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z10;
CREATE MATERIALIZED VIEW osm_landcover_planet_z10 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z10 ol, contextmaps.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z10_idx ON osm_landcover_planet_z10 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z11;
CREATE MATERIALIZED VIEW osm_landcover_planet_z11 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z11 ol, contextmaps.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z11_idx ON osm_landcover_planet_z11 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover__planetz12;
CREATE MATERIALIZED VIEW osm_landcover_planet_z12 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z12 ol, contextmaps.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z12_idx ON osm_landcover_planet_z12 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z13;
CREATE MATERIALIZED VIEW osm_landcover_planet_z13 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z13 ol, contextmaps.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z13_idx ON osm_landcover_planet_z13 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_landcover_planet_z14;
CREATE MATERIALIZED VIEW osm_landcover_planet_z14 AS
(
SELECT l.geometry, 
       subclass,
       NULL::int as icgc_id
FROM osm_landcover_gen_z14 ol, contextmaps.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_landcover_planet_z14_idx ON osm_landcover_planet_z14 USING gist (geometry);

-- Place

DROP MATERIALIZED VIEW IF EXISTS osm_island_point_planet;
CREATE MATERIALIZED VIEW osm_island_point_planet AS
(
SELECT osm_id * 10 AS osm_id,
             oip.geometry,
             name,
             'island' AS class,
             7 AS "rank"
FROM osm_island_point oip, contextmaps.catalunya c
WHERE ST_Disjoint(c.geometry, ol.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_island_point_planet_idx ON osm_island_point_planet USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS osm_island_polygon_planet;
CREATE MATERIALIZED VIEW osm_island_polygon_planet AS
(
SELECT  osm_id * 10 AS osm_id,
        oip.geometry,
        oip.name,
        'island' AS class,
        island_rank(area) AS "rank"
FROM osm_island_polygon oip, contextmaps.catalunya c
WHERE ST_Disjoint(c.geometry, oip.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_island_polygon_planet_idx ON osm_island_polygon_planet USING gist (geometry);

-- Transportation


--- Transportation tables creation

DROP MATERIALIZED VIEW IF EXISTS transportation_gen_planet_z6;
CREATE MATERIALIZED VIEW transportation_gen_planet_z6 AS
(
	SELECT    
		ST_Difference(otml.geometry, c.geometry) AS geometry, 
		osm_id,
		highway,
		network,
		construction,
		is_bridge,
		is_tunnel,
		is_ford,
		z_order
	FROM osm_transportation_merge_linestring_gen_z6 otml, contextmaps.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z6_idx ON transportation_gen_planet_z6 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_gen_planet_z7;
CREATE MATERIALIZED VIEW transportation_gen_planet_z7 AS
(
	SELECT    
		ST_Difference(otml.geometry, c.geometry) AS geometry, 
		osm_id,
		highway,
		network,
		construction,
		is_bridge,
		is_tunnel,
		is_ford,
		z_order
	FROM osm_transportation_merge_linestring_gen_z7 otml, contextmaps.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z7_idx ON transportation_gen_planet_z7 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_gen_planet_z8;
CREATE MATERIALIZED VIEW transportation_gen_planet_z8 AS
(
	SELECT    
		ST_Difference(otml.geometry, c.geometry) AS geometry, 
		osm_id,
		highway,
		network,
		construction,
		is_bridge,
		is_tunnel,
		is_ford,
		z_order
	FROM osm_transportation_merge_linestring_gen_z8 otml, contextmaps.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z8_idx ON transportation_gen_planet_z8 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_gen_planet_z9;
CREATE MATERIALIZED VIEW transportation_gen_planet_z9 AS
(
	SELECT    
			ST_Difference(otml.geometry, c.geometry) AS geometry, 
			osm_id,
			highway,
			network,
			construction,
			is_bridge,
			is_tunnel,
			is_ford,
			z_order
	FROM osm_transportation_merge_linestring_gen_z9 otml, contextmaps.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z9_idx ON transportation_gen_planet_z9 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_gen_planet_z10;
CREATE MATERIALIZED VIEW transportation_gen_planet_z10 AS
(
	SELECT    
			ST_Difference(otml.geometry, c.geometry) AS geometry, 
			osm_id,
			highway,
			network,
			construction,
			is_bridge,
			is_tunnel,
			is_ford,
			z_order
	FROM osm_transportation_merge_linestring_gen_z10 otml, contextmaps.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z10_idx ON transportation_gen_planet_z10 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS transportation_gen_planet_z11;
CREATE MATERIALIZED VIEW transportation_gen_planet_z11 AS
(
	SELECT    
			ST_Difference(otml.geometry, c.geometry) AS geometry, 
			osm_id,
			highway,
			network,
			construction,
			is_bridge,
			is_tunnel,
			is_ford,
			z_order
	FROM osm_transportation_merge_linestring_gen_z11 otml, contextmaps.catalunya c
);
CREATE INDEX IF NOT EXISTS transportation_gen_planet_z11_idx ON transportation_gen_planet_z11 USING gist (geometry);

-- Water

DROP MATERIALIZED VIEW IF EXISTS water_z6;
CREATE MATERIALIZED VIEW water_z6 AS
(
-- etldoc:  osm_ocean_polygon_gen_z6 ->  water_z6
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_gen_z6
UNION ALL
-- etldoc:  osm_water_polygon_gen_z6 ->  water_z6
SELECT w.geometry,
       water_class(waterway, water) AS class,
       w.is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon_gen_z6 w, contextmaps.catalunya c
WHERE "natural" != 'bay'
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z6_idx ON water_z6 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS water_z7;
CREATE MATERIALIZED VIEW water_z7 AS
(
-- etldoc:  osm_ocean_polygon_gen_z7 ->  water_z7
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_gen_z7
UNION ALL
-- etldoc:  osm_water_polygon_gen_z7 ->  water_z7
SELECT w.geometry,
       water_class(waterway, water) AS class,
       w.is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon_gen_z7 w, contextmaps.catalunya c
WHERE "natural" != 'bay'
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z7_idx ON water_z7 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS water_z8;
CREATE MATERIALIZED VIEW water_z8 AS
(
-- etldoc:  osm_ocean_polygon_gen_z8 ->  water_z8
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_gen_z8
UNION ALL
-- etldoc:  osm_water_polygon_gen_z8 ->  water_z8
SELECT w.geometry,
       water_class(waterway, water) AS class,
       w.is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon_gen_z8 w, contextmaps.catalunya c
WHERE "natural" != 'bay' 
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z8_idx ON water_z8 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS water_z9;
CREATE MATERIALIZED VIEW water_z9 AS
(
-- etldoc:  osm_ocean_polygon_gen_z9 ->  water_z9
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_gen_z9
UNION ALL
-- etldoc:  osm_water_polygon_gen_z9 ->  water_z9
SELECT w.geometry,
       water_class(waterway, water) AS class,
       w.is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon_gen_z9 w, contextmaps.catalunya c
WHERE "natural" != 'bay'
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z9_idx ON water_z9 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS water_z10;
CREATE MATERIALIZED VIEW water_z10 AS
(
-- etldoc:  osm_ocean_polygon_gen_z10 ->  water_z10
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_gen_z10
UNION ALL
-- etldoc:  osm_water_polygon_gen_z10 ->  water_z10
SELECT w.geometry,
       water_class(waterway, water) AS class,
       w.is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon_gen_z10 w, contextmaps.catalunya c
WHERE "natural" != 'bay'
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z10_idx ON water_z10 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS water_z11;
CREATE MATERIALIZED VIEW water_z11 AS
(
-- etldoc:  osm_ocean_polygon_gen_z11 ->  water_z11
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_gen_z11
UNION ALL
-- etldoc:  osm_water_polygon_gen_z11 ->  water_z11
SELECT w.geometry,
       water_class(waterway, water) AS class,
       w.is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon_gen_z11 w, contextmaps.catalunya c
WHERE "natural" != 'bay'
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z11_idx ON water_z11 USING gist (geometry);

DROP MATERIALIZED VIEW IF EXISTS water_z12;
CREATE MATERIALIZED VIEW water_z12 AS
(
-- etldoc:  osm_ocean_polygon_union ->  water_z12
SELECT geometry,
       'ocean'::text AS class,
       NULL::boolean AS is_intermittent,
       NULL::boolean AS is_bridge,
       NULL::boolean AS is_tunnel,
       0::int AS icgc_id
FROM osm_ocean_polygon_union
UNION ALL
-- etldoc:  osm_water_polygon ->  water_z12
SELECT w.geometry,
       water_class(waterway, water) AS class,
       w.is_intermittent,
       w.is_bridge,
       w.is_tunnel,
       0::int AS icgc_id
FROM osm_water_polygon w, contextmaps.catalunya c
WHERE "natural" != 'bay'
 AND ST_Disjoint(c.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS water_z12_idx ON water_z12 USING gist (geometry);

-- Waterway

DROP MATERIALIZED VIEW IF EXISTS waterway_z6;
CREATE MATERIALIZED VIEW waterway_z6 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       class,
       name,
       NULL::text AS entorn
FROM waterway_relation_gen_z6 w, contextmaps.catalunya
WHERE ST_DISJOINT(contextmaps.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z6_idx ON waterway_z6 USING gist (geometry);

-- etldoc: waterway_relation_gen_z7 ->  waterway_z7
DROP MATERIALIZED VIEW IF EXISTS waterway_z7;
CREATE MATERIALIZED VIEW waterway_z7 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       class,
       name,
       NULL::text AS entorn
FROM waterway_relation_gen_z7 w, contextmaps.catalunya
WHERE ST_DISJOINT(contextmaps.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z7_idx ON waterway_z7 USING gist (geometry);

-- etldoc: waterway_relation_gen_z8 ->  waterway_z8
DROP MATERIALIZED VIEW IF EXISTS waterway_z8;
CREATE MATERIALIZED VIEW waterway_z8 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       class,
       name,
       NULL::text AS entorn
FROM waterway_relation_gen_z8 w, contextmaps.catalunya
WHERE ST_DISJOINT(contextmaps.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z8_idx ON waterway_z8 USING gist (geometry);

-- etldoc: osm_important_waterway_linestring_gen_z9 ->  waterway_z9
DROP MATERIALIZED VIEW IF EXISTS waterway_z9;
CREATE MATERIALIZED VIEW waterway_z9 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       'river'::text AS class,
       name,
       NULL::text AS entorn
FROM osm_important_waterway_linestring_gen_z9 w, contextmaps.catalunya
WHERE ST_DISJOINT(contextmaps.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z9_idx ON waterway_z9 USING gist (geometry);

-- etldoc: osm_important_waterway_linestring_gen_z10 ->  waterway_z10
DROP MATERIALIZED VIEW IF EXISTS waterway_z10;
CREATE MATERIALIZED VIEW waterway_z10 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       'river'::text AS class,
       name,
       NULL::text AS entorn
FROM osm_important_waterway_linestring_gen_z10 w, contextmaps.catalunya
WHERE ST_DISJOINT(contextmaps.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z10_idx ON waterway_z10 USING gist (geometry);

-- etldoc:osm_important_waterway_linestring_gen_z11 ->  waterway_z11
DROP MATERIALIZED VIEW IF EXISTS waterway_z11;
CREATE MATERIALIZED VIEW waterway_z11 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       'river'::text AS class,
       name,
       NULL::text AS entorn
FROM osm_important_waterway_linestring_gen_z11 w, contextmaps.catalunya
WHERE ST_DISJOINT(contextmaps.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z11_idx ON waterway_z11 USING gist (geometry);

-- etldoc: osm_waterway_linestring ->  waterway_z12
DROP MATERIALIZED VIEW IF EXISTS waterway_z12;
CREATE MATERIALIZED VIEW waterway_z12 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       waterway::text AS class,
       name,
       NULL::text AS entorn
FROM osm_waterway_linestring w, contextmaps.catalunya
WHERE w.waterway IN ('river', 'canal') 
AND ST_DISJOINT(contextmaps.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z12_idx ON waterway_z12 USING gist (geometry);

-- etldoc: osm_waterway_linestring ->  waterway_z13
DROP MATERIALIZED VIEW IF EXISTS waterway_z13;
CREATE MATERIALIZED VIEW waterway_z13 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       waterway::text AS class,
       name,
       NULL::text AS entorn
FROM osm_waterway_linestring w, contextmaps.catalunya
WHERE w.waterway IN ('river', 'canal', 'stream', 'drain', 'ditch')
AND ST_DISJOINT(contextmaps.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z13_idx ON waterway_z13 USING gist (geometry);

-- etldoc: osm_waterway_linestring ->  waterway_z14
DROP MATERIALIZED VIEW IF EXISTS waterway_z14;
CREATE MATERIALIZED VIEW waterway_z14 AS
(
SELECT NULL::bigint AS icgc_id,
       w.geometry,
       waterway::text AS class,
       name,
       NULL::text AS entorn
FROM osm_waterway_linestring w, contextmaps.catalunya
WHERE ST_DISJOINT(contextmaps.catalunya.geometry, w.geometry)
    );
CREATE INDEX IF NOT EXISTS waterway_z14_idx ON waterway_z14 USING gist (geometry);

$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;