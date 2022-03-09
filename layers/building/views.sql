DROP MATERIALIZED VIEW IF EXISTS osm_building_block_planet;
CREATE MATERIALIZED VIEW osm_building_planet AS
(
SELECT *
FROM osm_building_block_gen_z13 obbp, icgc_data.catalunya c
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
FROM osm_building_relation b, icgc_data.catalunya c
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
FROM osm_building_polygon obp, icgc_data.catalunya c
         LEFT JOIN osm_building_relation obr ON
        obp.osm_id >= 0 AND
        obr.member = obp.osm_id AND
        obr.role = 'outline',
      icgc_data.catalunya c
WHERE ST_GeometryType(obp.geometry) IN ('ST_Polygon', 'ST_MultiPolygon')
    AND ST_Disjoint(c.geometry, obp.geometry)
    );
CREATE INDEX IF NOT EXISTS osm_all_buildings_idx ON osm_all_buildings USING gist (geometry);