-- etldoc: layer_building[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_building | <z13> z13 | <z14_> z14+ " ] ;
DROP FUNCTION IF EXISTS layer_building(bbox geometry, zoom_level int);
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
SELECT geom,
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

        -- poblament
        SELECT
             NULL::bigint AS osm_id,
             icgc_id,
             geom,
             NULL::int as render_height,
             NULL::int AS render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             NULL::boolean AS hide_3d,
             building
         FROM icgc_data.poblament
         WHERE zoom_level = 11 AND geom && bbox
         UNION ALL

         -- building_z12
         SELECT
             NULL::bigint AS osm_id,
             icgc_id,
             geom,
             render_height,
             render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             NULL::boolean AS hide_3d,
             building
         FROM icgc_data.building_z12
         WHERE zoom_level = 12 AND geom && bbox
         UNION ALL

         -- building
         SELECT
             NULL::bigint AS osm_id,
             icgc_id,
             geom,
             render_height,
             render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             NULL::boolean AS hide_3d,
             building
         FROM icgc_data.building
         WHERE zoom_level = 13 AND geom && bbox
         UNION ALL

         -- building_bt5m
         SELECT
             NULL::bigint AS osm_id,
             icgc_id,
             geom,
             render_height,
             render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             NULL::boolean AS hide_3d,
             building
         FROM icgc_data.building
         WHERE zoom_level > 13 AND building IN ('industrial', 'cns-XE', 'dip') AND geom && bbox
         UNION ALL

         -- building_bt5m
         SELECT
             NULL::bigint AS osm_id,
             icgc_id,
             geom,
             render_height,
             render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             NULL::boolean AS hide_3d,
             building
         FROM icgc_data.building
         WHERE zoom_level > 13 AND building NOT IN ('industrial', 'cns-XE', 'dip') AND geom && bbox
         UNION ALL

         -- ascensors
         SELECT
             NULL::bigint AS osm_id,
             icgc_id,
             geom,
             NULL::int as render_height,
             NULL::int AS render_min_height,
             NULL::text AS material,
             NULL::text AS colour,
             NULL::boolean AS hide_3d,
             building
         FROM icgc_data.ascensors
         WHERE zoom_level > 13 AND geom && bbox
     ) AS zoom_levels
ORDER BY render_height ASC, ST_YMin(geom) DESC;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE
                ;

-- not handled: where a building outline covers building parts
