-- etldoc: layer_building[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_building | <z13> z13 | <z14_> z14+ " ] ;
DROP FUNCTION IF EXISTS layer_building(bbox geometry, zoom_level int);
CREATE OR REPLACE FUNCTION layer_building(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                geometry          geometry,
                icgc_id           bigint,
                render_height     integer,
                render_min_height integer,
                building          text
            )
AS
$$
SELECT geom,
       icgc_id,
       render_height,
       render_min_height,
       building
FROM (
        -- z_9_10mtc_poblament_poligon
        SELECT
             icgc_id,
             geom,
             NULL::int AS render_height,
             NULL::int AS render_min_height,
             building
         FROM contextmaps.z_9_10mtc_poblament_poligon
         WHERE zoom_level BETWEEN 7 AND 10 AND geom && bbox
         UNION ALL
        -- poblament
        SELECT
             icgc_id,
             geom,
             NULL::int AS render_height,
             NULL::int AS render_min_height,
             building
         FROM contextmaps.poblament
         WHERE zoom_level = 11 AND geom && bbox
         UNION ALL

         -- building_z12
         SELECT
             icgc_id,
             geom,
             render_height,
             render_min_height,
             building
         FROM contextmaps.building_z12
         WHERE zoom_level = 12 AND geom && bbox
         UNION ALL

         -- building
         SELECT
             icgc_id,
             geom,
             render_height,
             render_min_height,
             building
         FROM contextmaps.building
         WHERE zoom_level = 13 AND geom && bbox
         UNION ALL

         -- building_bt5m
         SELECT
             icgc_id,
             geom,
             render_height,
             render_min_height,
             'industrial' AS building
         FROM contextmaps.building_bt5m
         WHERE zoom_level > 13 AND building IN ('industrial', 'cns-XE', 'dip') AND geom && bbox
         UNION ALL

         -- building_bt5m
         SELECT
             icgc_id,
             geom,
             render_height,
             render_min_height,
             building
         FROM contextmaps.building_bt5m
         WHERE zoom_level > 13 AND building NOT IN ('industrial', 'cns-XE', 'dip') AND geom && bbox
         UNION ALL

         -- ascensors
         SELECT
             icgc_id,
             geom,
             NULL::int AS render_height,
             NULL::int AS render_min_height,
             NULL::text AS building
         FROM contextmaps.ascensors
         WHERE zoom_level > 13 AND geom && bbox
     ) AS zoom_levels
ORDER BY render_height ASC, ST_YMin(geom) DESC;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE
                ;

-- not handled: where a building outline covers building parts
