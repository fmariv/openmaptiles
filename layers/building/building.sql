-- etldoc: layer_building[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_building | <z13> z13 | <z14_> z14+ " ] ;

CREATE INDEX IF NOT EXISTS osm_building_relation_building_idx ON osm_building_relation (building) WHERE building = '' AND ST_GeometryType(geometry) = 'ST_Polygon';
CREATE INDEX IF NOT EXISTS osm_building_relation_member_idx ON osm_building_relation (member) WHERE role = 'outline';

CREATE OR REPLACE VIEW osm_all_buildings AS
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
FROM osm_building_relation b, admin.cat c
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
      admin.cat c
WHERE ST_GeometryType(obp.geometry) IN ('ST_Polygon', 'ST_MultiPolygon')
   AND ST_Disjoint(c.geometry, obp.geometry)
    );

CREATE OR REPLACE FUNCTION layer_building(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                geometry          geometry,
                osm_id            bigint,
                icgc_id           bigint,
                render_height     integer,
                render_min_height integer,
                colour            text,
                hide_3d           boolean,
                building          text
            )
AS
$$
SELECT geometry,
       osm_id,
       icgc_id,
       render_height,
       render_min_height,
       COALESCE(colour, CASE material
           -- Ordered by count from taginfo
                            WHEN 'cement_block' THEN '#6a7880'
                            WHEN 'brick' THEN '#bd8161'
                            WHEN 'plaster' THEN '#dadbdb'
                            WHEN 'wood' THEN '#d48741'
                            WHEN 'concrete' THEN '#d3c2b0'
                            WHEN 'metal' THEN '#b7b1a6'
                            WHEN 'stone' THEN '#b4a995'
                            WHEN 'mud' THEN '#9d8b75'
                            WHEN 'steel' THEN '#b7b1a6' -- same as metal
                            WHEN 'glass' THEN '#5a81a0'
                            WHEN 'traditional' THEN '#bd8161' -- same as brick
                            WHEN 'masonry' THEN '#bd8161' -- same as brick
                            WHEN 'Brick' THEN '#bd8161' -- same as brick
                            WHEN 'tin' THEN '#b7b1a6' -- same as metal
                            WHEN 'timber_framing' THEN '#b3b0a9'
                            WHEN 'sandstone' THEN '#b4a995' -- same as stone
                            WHEN 'clay' THEN '#9d8b75' -- same as mud
           END) AS colour,
       CASE WHEN hide_3d THEN TRUE END AS hide_3d,
       NULLIF(building, '') AS building
FROM (
         -- etldoc: osm_building_block_gen_z13 -> layer_building:z13
         SELECT
             obp.osm_id,
             NULL::int as icgc_id,
             obp.geometry,
             NULL::int AS render_height,
             NULL::int AS render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             FALSE AS hide_3d,
             NULL::text AS building
         FROM osm_building_block_gen_z13 obp, admin.cat c
         WHERE zoom_level = 13
           AND obp.geometry && bbox
           AND ST_Disjoint(c.geometry, obp.geometry)
         UNION ALL

         -- etldoc: osm_building_polygon -> layer_building:z14_
         SELECT
             DISTINCT ON (osm_id) osm_id,
                                  NULL::int as icgc_id,
                                  geometry,
                                  ceil(COALESCE(height, levels * 3.66, 5))::int AS render_height,
                                  floor(COALESCE(min_height, min_level * 3.66, 0))::int AS render_min_height,
                                  material,
                                  colour,
                                  hide_3d,
                                  NULL::text AS building
         -- Don't need to filter by extent because the view it's already filtered on its creation
         FROM osm_all_buildings
         WHERE (levels IS NULL OR levels < 1000)
           AND (min_level IS NULL OR min_level < 1000)
           AND (height IS NULL OR height < 3000)
           AND (min_height IS NULL OR min_height < 3000)
           AND zoom_level >= 14
           AND geometry && bbox
         UNION ALL

        -- z_9_10mtc_poblament_poligon
        SELECT
             NULL::int AS osm_id,
             icgc_id,
             geom,
             NULL::int as render_height,
             NULL::int AS render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             NULL::boolean AS hide_3d,
             building
         FROM z_9_10mtc_poblament_poligon
         WHERE (zoom_level BETWEEN 7 AND 10) AND geom && bbox
         UNION ALL

        -- poblament
        SELECT
             NULL::int AS osm_id,
             icgc_id,
             geom,
             NULL::int as render_height,
             NULL::int AS render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             NULL::boolean AS hide_3d,
             building
         FROM poblament
         WHERE zoom_level = 11 AND geom && bbox
         UNION ALL

         -- building_z12
         SELECT
             NULL::int AS osm_id,
             icgc_id,
             geom,
             render_height,
             render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             NULL::boolean AS hide_3d,
             building
         FROM building_z12
         WHERE zoom_level = 12 AND geom && bbox
         UNION ALL

         -- building
         SELECT
             NULL::int AS osm_id,
             icgc_id,
             geom,
             render_height,
             render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             NULL::boolean AS hide_3d,
             building
         FROM building
         WHERE zoom_level = 13 AND geom && bbox
         UNION ALL

         -- building_bt5m
         SELECT
             NULL::int AS osm_id,
             icgc_id,
             geom,
             render_height,
             render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             NULL::boolean AS hide_3d,
             building
         FROM building
         WHERE zoom_level > 13 AND building IN ('industrial', 'cns-XE', 'dip') AND geom && bbox
         UNION ALL

         -- building_bt5m
         SELECT
             NULL::int AS osm_id,
             icgc_id,
             geom,
             render_height,
             render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             NULL::boolean AS hide_3d,
             building
         FROM building
         WHERE zoom_level > 13 AND building NOT IN ('industrial', 'cns-XE', 'dip') AND geom && bbox
         UNION ALL

         -- ascensors
         SELECT
             NULL::int AS osm_id,
             icgc_id,
             geom,
             NULL::int as render_height,
             NULL::int AS render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             NULL::boolean AS hide_3d,
             building
         FROM ascensors
         WHERE zoom_level > 13 AND geom && bbox
     ) AS zoom_levels
ORDER BY render_height ASC, ST_YMin(geometry) DESC;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE
                ;

-- not handled: where a building outline covers building parts
